//%attributes = {"executedOnServer":true}
// _______
// Method: EDI_DESADV_Readiness_EOS   ( ) ->
// By: Mel Bohince @ 11/16/20, 18:50:06
// Description
// based on EDI_DESADV_Readiness, but execute on server attribute set
// ----------------------------------------------------
//ON ERR CALL("e_ExeOnServerError")  // Modified by: Mel Bohince (12/11/20) .fromCollection hates locked records
// Modified by: Mel Bohince (12/15/20) replace the .toCollection/.fromCollection with util_EntitySelectionFromObject and util_EntitySelectionToObject
//because using the collection can try to update records and get stopped by a locked record
// Modified by: Mel Bohince (1/20/21) remove date limitation, shipping window now meaning that it was called off on OPN and not yet ASN'd
// Modified by: Mel Bohince (1/27/21) dock date not in past
// Modified by: Mel Bohince (4/2/21) Deal with O/S inventory, don't block the asn for that reason

C_OBJECT:C1216($allOpenFirm)  //this makes the code the same as EDI_DESADV_Readiness once re-baked

//C_COLLECTION($1;$openELC_c;$0;$ready_c)
//$openELC_c:=$1
//$ready_c:=New collection  //the return value of an ent sel coverted to a col
//convert collection back to entitySelection
//$allOpenFirm:=ds.Customers_ReleaseSchedules.fromCollection($openELC_c)  //convert collection back to entitySelection

C_OBJECT:C1216($1; $openELC_o; $ready_o; $0)
$openELC_o:=$1
$allOpenFirm:=util_EntitySelectionFromObject($openELC_o; ->[Customers_ReleaseSchedules:46])

//BIZ RULES:
// 1) dock date in range // Modified by: Mel Bohince (1/27/21) not in past
// 2) even lot multiple
// 3) launch OKs
// 4) in-house inventories
// 5) accepted orderline
// 6) available inventory
// 7) shipto record requests ASN

// first test and log if important requirements are met, 
// then if qualifies prepare an asn and place in EDI_outbox
// see also EDI_DESADV_PO_Notification which sets the ediASNmsgID flag
// based on enclusion in the Open PO Notification report
// ----------------------------------------------------


C_BOOLEAN:C305($sendASN; $showThemo)
$showThemo:=False:C215

C_OBJECT:C1216($shippingWindow_es; $params; $relObj; $result; $ready_es; $openFirm)
C_COLLECTION:C1488($criteria; $sortOrder)
//$allOpenFirm:=$1

C_LONGINT:C283($look_ahead_days; $qtyPerCase; $numberOfCases)
C_DATE:C307($shippingFenceTooSoon)  // Modified by: Mel Bohince (7/13/20) don't send missed shipdate
$look_ahead_days:=14
$shippingFenceTooSoon:=Add to date:C393(Current date:C33; 0; 0; $look_ahead_days)  //how far out can we seen them

//build the query

$criteria:=New collection:C1472

$criteria.push(0)  //:7 not already ASN'd, ediASNmsgID either virgin or tagged for ASN
$criteria.push($shippingFenceTooSoon)

// Modified by: Mel Bohince (1/20/21) $params not used
$params:=New object:C1471
$params.parameters:=$criteria

//build the sort order
$sortOrder:=New collection:C1472
$sortOrder.push(New object:C1471("propertyPath"; "Shipto"; "descending"; False:C215))
$sortOrder.push(New object:C1471("propertyPath"; "Sched_Date"; "descending"; False:C215))
//get the interesting releases
//$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID <= :1 and Sched_Date <= :2";$params).orderBy($sortOrder)
//$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID <= :1 and user_date_1 <= :2";$params).orderBy($sortOrder)
//$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID = :1";-1).orderBy($sortOrder)  // Modified by: Mel Bohince (1/20/21) meaning that it was called off on OPN and not yet ASN'd
$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID = :1 and Promise_Date >= :2"; -1; Current date:C33).orderBy($sortOrder)  // Modified by: Mel Bohince (1/27/21) dock date not in past

//$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID # :1";0).orderBy($sortOrder)  //called off
//if ui list is wanted by "logonly" start an es to use at the end
$ready_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()

If ($showThemo)  // Added by: Mel Bohince (6/26/20) progress indicators
	C_LONGINT:C283($innerBar; $innerLoop; $in)  //this could also be called repeativly inside the loop if the quit is also moved inside
	$innerLoop:=$shippingWindow_es.length
	$innerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($innerBar; True:C214)  // no stop button
	Progress SET TITLE($innerBar; "Finding ready releases...")
End if 

For each ($relObj; $shippingWindow_es)
	If ($showThemo)  // Added by: Mel Bohince (6/26/20) progress indicators
		$in:=$in+1  //update a counter
		Progress SET PROGRESS($innerBar; $in/$innerLoop)  //update the thermometer
		Progress SET MESSAGE($innerBar; String:C10($in)+"/"+String:C10($innerLoop))  //optional verbose status
	End if 
	
	$sendASN:=True:C214  //optimistic
	
	If ($relObj.FINISHED_GOOD#Null:C1517)  //for packing and launch
		
		If (True:C214)  //Test packing
			
			If ($relObj.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
				$qtyPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.CaseCount  //PK_getCaseCount ($packingSpecID)PK_getCaseCount ($packingSpecID)
				$numberOfCases:=Int:C8($relObj.Sched_Qty/$qtyPerCase)
				
				If (($numberOfCases*$qtyPerCase)#$relObj.Sched_Qty)  //evenlot multiples
					$sendASN:=False:C215
				End if 
				
			Else   //no packing spec
				$sendASN:=False:C215
			End if 
			
		End if   //test packing
		
		If (True:C214)  //test launch status on the related f/g record for 
			If (($relObj.FINISHED_GOOD.DateLaunchReceived#!00-00-00!) & \
				($relObj.FINISHED_GOOD.DateLaunchApproved=!00-00-00!) & \
				($relObj.FINISHED_GOOD.OriginalOrRepeat="Original"))  //unapproved launch, don't send, see FG_LaunchItem and qryLaunch
				$sendASN:=False:C215
			End if 
		End if   //test launch
		
	Else   //related fg not found
		$sendASN:=False:C215
	End if   //fg for packing and launch
	
	
	If (True:C214)  //test inventory, location not outside service
		
		If ($relObj.FINISHED_GOOD.LOCATIONS#Null:C1517)
			If ($relObj.FINISHED_GOOD.LOCATIONS.query("Location = :1"; "@:OS@").length>0)  // outside service inventory, don't send, this needs to be handled with phone calls
				//$sendASN:=False // Modified by: Mel Bohince (4/2/21) Deal with O/S inventory, don't block the asn for that reason
			End if 
			
		Else   //no location
			$sendASN:=False:C215
		End if 
		
	End if   //test inventory
	
	
	//Next section is to evaluate whether this candidate release should be acted on
	//. testing or orderline status, launch status, o/s inventory, adequit inventory, RFM requested, ASN requested
	//test if order has been booked
	If ($relObj.ORDER_LINE#Null:C1517)
		
		If ($relObj.ORDER_LINE.Status#"Accepted")  //booked?
			$sendASN:=False:C215
		End if 
		
		If ($relObj.ORDER_LINE.ORDER=Null:C1517)
			$sendASN:=False:C215
		End if   //header
		
	Else 
		$sendASN:=False:C215
	End if 
	
	If ($relObj.THC_State>0)
		$sendASN:=False:C215
	End if 
	
	
	
	If ($relObj.SHIPTO_ADDR#Null:C1517)
		If (Not:C34($relObj.SHIPTO_ADDR.edi_Send_ASN))
			$sendASN:=False:C215
		End if 
		
	Else   //no shipto
		$sendASN:=False:C215
	End if 
	
	
	
	If ($sendASN)
		$ready_es.add($relObj)
	End if 
	
	
	
End for each   //each release

If ($ready_es.length>0)
	//convert entitySelection to collection to be returned
	//$ready_c:=$ready_es.toCollection("ReleaseNumber";dk with primary key)
	
	$ready_o:=util_EntitySelectionToObject($ready_es; ->[Customers_ReleaseSchedules:46])
End if 

//$0:=$ready_c
$0:=$ready_o

If ($showThemo)
	Progress QUIT($innerBar)  //remove the thermometer  // Added by: Mel Bohince (6/26/20) progress indicators
End if 

//ON ERR CALL("")


