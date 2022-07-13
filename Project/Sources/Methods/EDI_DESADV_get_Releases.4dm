//%attributes = {}
// OBSOLETE_______
// OBSOLETE_______
// OBSOLETE_______
// OBSOLETE_______
// Method: EDI_DESADV_get_Releases   ( ) ->
// By: Mel Bohince @ 02/13/20, 08:04:24
// Description
// get a selection of release which should send ASN, and possible RFM email
// ----------------------------------------------------
C_BOOLEAN:C305($sendASN; $sendRFM)
C_DATE:C307($dateBegin; $dateEnd)
ARRAY TEXT:C222($aRFM; 0)  //not really needed, will be obsolete after cutover
C_TEXT:C284($d; $r)
$d:=","  //csv delimiter
$r:="\r"

C_LONGINT:C283($numberOfCases; $qtyPerCase; $look_ahead_days; $weight)
C_OBJECT:C1216($relEntSel; $params; $relObj; $result)
C_COLLECTION:C1488($criteria; $sortOrder)
//build the query
$params:=New object:C1471
$criteria:=New collection:C1472

$look_ahead_days:=5
$dateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
$dateBegin:=Add to date:C393($dateBegin; 0; -1; 0)
$dateEnd:=Add to date:C393(4D_Current_date; 0; 0; $look_ahead_days)

$criteria.push(0)  //:1 release is still open
$criteria.push($dateBegin)  //:2 from date
$criteria.push($dateEnd)  //:3 to date
$criteria.push("<@")  //:4 not a forecast
$criteria.push("N/A")  //:5 shipto is specified
$criteria.push("00000")  //:6 shipto is specified
$criteria.push(0)  //:7 not already processed, ediASNmsgID 
$criteria.push("Estée Lauder Companies")  //:8 parentCorp

$params.parameters:=$criteria

$sortOrder:=New collection:C1472
$sortOrder.push(New object:C1471("propertyPath"; "Shipto"; "descending"; False:C215))
$sortOrder.push(New object:C1471("propertyPath"; "Sched_Date"; "descending"; False:C215))

//get the interesting releases
$relEntSel:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty > :1 and Sched_Date >= :2 and Sched_Date <= :3 and CustomerRefer # :4 and Shipto # :5  and Shipto # :6 and ediASNmsgID = :7  and  CUSTOMER.ParentCorp = :8 "\
; $params).orderBy($sortOrder)

$log:="Shipto"+$d+"Date"+$d+"Releases"+$d+"Product"+$d+"Qty"+$d+"Cases"+$d+"Volume"+$d+\
"OrderlineStat"+$d+"LAUNCH_OK"+$d+"Outside_Inventory"+$d+"THC_Inventory"+$d\
+"RFM_Requested"+$d+"RFM_Sent"+$d+"ASN_Requested"+$d+"ASN_Previous_Sent"+$d+"SendASN"+$d\
+"SendRFM"+$d+"PO_ref"+$r  //keep track of what was found

For each ($relObj; $relEntSel)
	//test if on launch hold, inventory not in-house, and if rfm email should be sent
	$sendASN:=True:C214
	$sendRFM:=True:C214
	$log:=$log+$relObj.Shipto+$d+String:C10($relObj.Sched_Date; Internal date short special:K1:4)+$d+String:C10($relObj.ReleaseNumber)+$d+$relObj.ProductCode+$d+String:C10($relObj.Sched_Qty)+$d
	If ($relObj.ProductCode="P52P-01-9113")
		
	End if 
	
	//log some shipping metrics
	$packingSpecID:=FG_getOutline($relObj.ProductCode)
	If ($relObj.FINISHED_GOOD#Null:C1517)
		If ($relObj.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
			$qtyPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.CaseCount  //PK_getCaseCount ($packingSpecID)PK_getCaseCount ($packingSpecID)
			$numberOfCases:=Int:C8($relObj.Sched_Qty/$qtyPerCase)
			If (($numberOfCases*$qtyPerCase)<$relObj.Sched_Qty)  //round up?
				$numberOfCases:=$numberOfCases+1
			End if 
		Else 
			$qtyPerCase:=1
			$numberOfCases:=1
		End if 
	Else 
		$qtyPerCase:=1
		$numberOfCases:=1
	End if 
	
	$volumePerCase:=PK_getVolumePerCase($packingSpecID)
	$log:=$log+String:C10($numberOfCases)+$d+String:C10($numberOfCases*$volumePerCase)+$d
	
	//Next section is to evaluate whether this candidate release should be acted on
	//. testing or orderline status, launch status, o/s inventory, adequit inventory, RFM requested, ASN requested
	//test if order has been booked
	If ($relObj.ORDER_LINE#Null:C1517)
		$log:=$log+$relObj.ORDER_LINE.Status+$d
		If ($relObj.ORDER_LINE.Status="CONTRACT")
			$sendASN:=False:C215
			$sendRFM:=False:C215
		End if 
	Else 
		$log:=$log+"NO ORDERLINE"+$d
		$sendASN:=False:C215
		$sendRFM:=False:C215
	End if 
	
	//test the related f/g record for launch status
	If ($relObj.FINISHED_GOOD#Null:C1517)
		If (($relObj.FINISHED_GOOD.DateLaunchReceived#!00-00-00!) & \
			($relObj.FINISHED_GOOD.DateLaunchApproved=!00-00-00!) & \
			($relObj.FINISHED_GOOD.OriginalOrRepeat="Original"))  //unapproved launch, don't send, see FG_LaunchItem and qryLaunch
			$sendASN:=False:C215
			$sendRFM:=False:C215
			$log:=$log+"LAUNCH"+$d
		Else 
			$log:=$log+""+$d
		End if 
		
		If ($relObj.FINISHED_GOOD.LOCATIONS#Null:C1517)
			If ($relObj.FINISHED_GOOD.LOCATIONS.query("Location = :1"; "@:OS@").length>0)  // outside service inventory, don't send, this needs to be handled with phone calls
				$sendASN:=False:C215
				$sendRFM:=False:C215
				$log:=$log+"O/S"+$d
			Else 
				$log:=$log+""+$d
			End if 
			
		Else   //no location
			$log:=$log+"NO LOCATIONS"+$d
		End if 
		
	Else   //no fg
		$sendASN:=False:C215
		$sendRFM:=False:C215
		$log:=$log+"FG NOT FOUND"+$d
		$log:=$log+""+$d
	End if 
	
	
	
	$log:=$log+String:C10($relObj.THC_State)+$d
	If ($relObj.THC_State#0)
		$sendRFM:=False:C215
		$sendASN:=False:C215
	End if 
	
	If ($relObj.SHIPTO_ADDR#Null:C1517)
		If (Length:C16($relObj.SHIPTO_ADDR.RequestForModeEmailTo)<6)  //somewhere to send was entered
			$sendRFM:=False:C215
			$log:=$log+"EMail N/A"+$d
			
		Else 
			$log:=$log+Substring:C12($relObj.SHIPTO_ADDR.RequestForModeEmailTo; 1; 6)+"..."+$d
		End if 
		
		$log:=$log+String:C10($relObj.user_date_1)+$d
		If ($relObj.user_date_1#!00-00-00!)  //already sent
			$sendRFM:=False:C215
		End if 
		
		$log:=$log+String:C10($relObj.SHIPTO_ADDR.edi_Send_ASN)+$d
		If (Not:C34($relObj.SHIPTO_ADDR.edi_Send_ASN))
			$sendASN:=False:C215
		End if 
		
	Else 
		$sendRFM:=False:C215
		$log:=$log+"EMail N/A"+$d
		$sendASN:=False:C215
	End if 
	
	$log:=$log+String:C10($relObj.ediASNmsgID)+$d
	If ($relObj.ediASNmsgID#0)  //already sent
		$sendASN:=False:C215
	End if 
	
	$log:=$log+String:C10($sendASN)+$d+String:C10($sendRFM)+$d+$relObj.CustomerRefer+$r
	
	If ($sendASN) & (False:C215)  //see EDI_DESADV_get_PO_Calloffs
		$edi_Outbox_id:=EDI_DESADV_By_Release($relObj)
		If ($edi_Outbox_id>0)  //mark this release so that we know that the asn has been sent
			$relObj.ediASNmsgID:=$edi_Outbox_id
			$result:=$relObj.save()
			If (Not:C34($result.success))
				$log:=$log+"EDI Msg ID Not Saved to release "+String:C10($relObj.ReleaseNumber)+$r
			End if 
		End if 
	End if 
	
	If ($sendRFM)
		$packing:=String:C10($numberOfCases)+" cases @ "+String:C10($qtyPerCase)+" /case"
		$weightPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.WeightPerCase  //PK_getWeightPerCase ($packingSpecID)
		If ($weightPerCase=0)  //default 30 pounds
			$weightPerCase:=30
		End if 
		$weight:=$numberOfCases*$weightPerCase
		
		C_TEXT:C284($rfmItem)
		$rfmItem:=$relObj.Shipto+$d+$relObj.ProductCode+$d+$relObj.CustomerRefer+$d+String:C10($relObj.Sched_Qty)+$d+$packing+$d+String:C10($weight)+$r
		
		utl_Logfile("ASN.log"; "RFM: "+$rfmItem)
		
		APPEND TO ARRAY:C911($aRFM; $rfmItem)
		
		//$relObj.user_date_1:=Current date
		//$result:=$relObj.save()
		//If (Not($result.success))
		//$log:=$log+"RFM Not Saved to release "+String($relObj.ReleaseNumber)+$r
		//End if 
		
	End if 
	
End for each   //each release

C_TEXT:C284($title; $text; $docName; $millidiff)
C_LONGINT:C283($millinow; $millithen)
C_TIME:C306($docRef)

$title:=""
$text:=""
$docName:="ASN_Log_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $log)
	SEND PACKET:C103($docRef; "\r\r")
	For ($i; 1; Size of array:C274($aRFM))
		SEND PACKET:C103($docRef; $aRFM{$i})
	End for 
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$subject:="ASN/RFM Log for "+String:C10(4D_Current_date; Internal date short special:K1:4)
	$preheader:="ASN/RFM Log. Open attached with Excel.\rReport run each morning at 6:40am. See EDI_DESADV_get_Releases."
	$body:="Open firm ELC Releases between "+String:C10($dateBegin; Internal date short special:K1:4)+" and "+String:C10($dateEnd; Internal date short special:K1:4)+" with a specified Shipto that haven't already generated an ASN.\r"
	$body:=$body+" The purpose is to reveal reasons why an ASN or RFM was not sent, such as order status, launch status, inventory available, O/S inventory, email address for RFM, ASN requested by shipto."
	$distributionList:="mel.bohince@arkay.com"  //Batch_GetDistributionList ("ASN/RFM Report")
	EMAIL_Transporter($subject; $preheader; $body; $distributionList; $docName)
	//$err:=util_Launch_External_App ($docName)
	util_deleteDocument($docName)
End if 
