//%attributes = {}

// Method: wmss_scannedSSCC ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/06/15, 19:21:41
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
C_BOOLEAN:C305($0)
$0:=False:C215

QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=rft_response)
If (Records in selection:C76([WMS_SerializedShippingLabels:96])>0)
	
	$numFound:=qryJMI([WMS_SerializedShippingLabels:96]Jobit:3)
	If ($numFound>0)
		
		sJobit:=[WMS_SerializedShippingLabels:96]Jobit:3
		rft_skid_label_id:=rft_response
		rft_log:="LOT:"+sJobit+" CPN:"+[Job_Forms_Items:44]ProductCode:3
		
		std_skid_count:=PK_getSkidCount(FG_getOutline([Job_Forms_Items:44]ProductCode:3))
		std_case_count:=PK_getCaseCount(FG_getOutline([Job_Forms_Items:44]ProductCode:3))
		std_cases_skid:=PK_getCasesPerSkid(FG_getOutline([Job_Forms_Items:44]ProductCode:3))
		
		If (std_cases_skid>0)
			rft_log:=String:C10(std_cases_skid)+"@"+String:C10(std_case_count)+"="+String:C10(std_skid_count)+<>cr+rft_log
			rft_log:="SCAN "+String:C10(std_cases_skid)+" CASES on skid\r"+rft_skid_label_id+"\r"+rft_log
			
		Else 
			std_cases_skid:=100
			rft_log:="WARNING NO PACKING SPEC!"+<>cr+rft_log
			rft_log:="SCAN 'DONE' WHEN COMPLETE"+<>cr+rft_log
			rft_error_log:="WARNING NO PACKING SPEC!"
		End if 
		
		ARRAY TEXT:C222(rft_scanNumber; 0)  //these will be appended by each case scanned
		ARRAY TEXT:C222(rft_caseNumber; 0)
		ARRAY TEXT:C222(rft_scansSoFar; 0)
		
		rft_state:="CASE"
		rft_prompt:="Scan Case Label:"
		$0:=True:C214
		
	Else   //ERROR
		wmss_throwError("Jobit not found.\rCheck the label.\r"+[WMS_SerializedShippingLabels:96]Jobit:3)
	End if 
	
Else   //invalid sscc format
	wmss_throwError(rft_response+" not valid.\rCheck the label.\r")
End if   //found sscc record