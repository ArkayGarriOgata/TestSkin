//%attributes = {}
// _______
// Method: EDI_DESADV_Readiness   ( ) ->
// By: Mel Bohince @ 10/13/20, 10:49:46
// Description
// based on EDI_DESADV_get_PO_Calloffs
// ----------------------------------------------------

//BIZ RULES:
// 1) dock date in range
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


C_BOOLEAN:C305($sendASN)

C_OBJECT:C1216($shippingWindow_es; $params; $relObj; $result; $ready_es; $openFirm; $1)
C_COLLECTION:C1488($criteria; $sortOrder)
$allOpenFirm:=$1

C_LONGINT:C283($look_ahead_days; $qtyPerCase; $numberOfCases)
C_DATE:C307($shippingFenceTooSoon)  // Modified by: Mel Bohince (7/13/20) don't send missed shipdate
$look_ahead_days:=14
$shippingFenceTooSoon:=Add to date:C393(Current date:C33; 0; 0; $look_ahead_days)  //how far out can we seen them


//build the query

$criteria:=New collection:C1472

$criteria.push(0)  //:7 not already processed, ediASNmsgID 
$criteria.push($shippingFenceTooSoon)

$params:=New object:C1471
$params.parameters:=$criteria

//build the sort order
$sortOrder:=New collection:C1472
$sortOrder.push(New object:C1471("propertyPath"; "Shipto"; "descending"; False:C215))
$sortOrder.push(New object:C1471("propertyPath"; "Sched_Date"; "descending"; False:C215))
//get the interesting releases
$shippingWindow_es:=$allOpenFirm.query("ediASNmsgID = :1 and Sched_Date <= :2"; $params).orderBy($sortOrder)

//if ui list is wanted by "logonly" start an es to use at the end
$ready_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()


If (True:C214)  // Added by: Mel Bohince (6/26/20) progress indicators
	C_LONGINT:C283($innerBar; $innerLoop; $in)  //this could also be called repeativly inside the loop if the quit is also moved inside
	$innerLoop:=$shippingWindow_es.length
	$innerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($innerBar; True:C214)  // no stop button
	Progress SET TITLE($innerBar; "Finding ready releases...")
End if 

For each ($relObj; $shippingWindow_es)
	If (True:C214)  // Added by: Mel Bohince (6/26/20) progress indicators
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
				$sendASN:=False:C215
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
	//Display a list of the updated Releases
	$0:=$ready_es
End if 

Progress QUIT($innerBar)  //remove the thermometer  // Added by: Mel Bohince (6/26/20) progress indicators


