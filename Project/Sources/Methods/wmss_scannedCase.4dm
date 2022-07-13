//%attributes = {}

// Method: wmss_scannedCase ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/11/15, 10:03:35
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_BOOLEAN:C305($0)
$0:=False:C215

If (rft_response=rft_skid_label_id)  //done with skid
	If (scan_number<std_cases_skid)
		$note:="MAKE PALLET AS PARTIAL\r"+rft_log
	Else 
		$note:=""
	End if 
	
	$scannedQty:=0
	$scannedCases:=0
	$numberOfCases:=Size of array:C274(rft_scansSoFar)
	For ($case; 1; $numberOfCases)
		If (Length:C16(rft_scansSoFar{$case})>0)
			$scannedCases:=$scannedCases+1
			$scannedQty:=$scannedQty+Num:C11(WMS_CaseId(rft_scansSoFar{$case}; "qty"))
		End if 
	End for 
	
	$numFound:=qryJMI(sJobit)
	If ($numFound>0)
		wms_api_SendJobits
	End if 
	
	$success:=wms_api_Send_Skid(->rft_scansSoFar; rft_skid_label_id; $scannedQty; $scannedCases)
	If ($success)
		$note:="SAVED: "+String:C10($scannedCases)+" CASES = "+String:C10($scannedQty)+" TTL\r"+$note
	Else 
		$note:="PALLET "+rft_skid_label_id+" NOT SAVED\r"
		wmss_throwError("PALLET "+rft_skid_label_id+" NOT SAVED\rYou'll need to redo.")
	End if 
	
	wmss_init($note+"Scan the next skid.")
	$0:=True:C214
	
Else   //not done
	$scanned_jobit:=WMS_CaseId(rft_response; "jobit")
	If ($scanned_jobit=sJobit)
		
		
		If ((scan_number+1)<=std_cases_skid)  //it will fit
			
			If (Find in array:C230(rft_scansSoFar; rft_response)=-1)
				scan_number:=scan_number+1
				APPEND TO ARRAY:C911(rft_scansSoFar; rft_response)
				APPEND TO ARRAY:C911(rft_scanNumber; String:C10(scan_number))
				APPEND TO ARRAY:C911(rft_caseNumber; String:C10(Num:C11(WMS_CaseId(rft_response; "serial"))))
				
				If (scan_number<std_cases_skid)
					rft_prompt:="Scan case "+String:C10(scan_number+1)+" of "+String:C10(std_cases_skid)+": "
				Else 
					rft_prompt:="Scan Pallet to END"
					BEEP:C151
				End if   //not done with skid
				$0:=True:C214
				
			Else 
				wmss_throwError("Duplicate scan.\rLast scan ignored.\r"+rft_response)
			End if   //dup
			
		Else 
			wmss_throwError("Skid Over Packed.\rScan Ignored REMOVE:\r"+rft_response)
		End if   //too many cases
		
	Else 
		wmss_throwError("MIXED LOT! "+$scanned_jobit+" does not belong on this skid\rRemove it.\r")
	End if   //wrong jobit
	
End if   //are we done with skid
