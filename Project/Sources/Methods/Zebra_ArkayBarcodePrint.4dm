//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/19/08, 16:47:18
// ----------------------------------------------------
// Method: Zebra_ArkayBarcodePrint
// Description:
// New case Modified by: Mel Bohince (6/11/13)
// ----------------------------------------------------

If (wmsCaseNumber1>0)  //sometimes want to print without case number
	$firstCaseNumber:=wmsCaseNumber1  //this is the normal way to increment case number
	$lastCaseNumber:=$firstCaseNumber+iCnt-1
	wmsCaseNumber1:=$lastCaseNumber  //were going backwards
Else   //leave case# zero and don't print
	$firstCaseNumber:=iCnt*-1  //start negative towards zero
End if 
$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
//wmsCaseId1:=WMS_CaseId ($caseID;"barcode")
wmsHumanReadable1:=WMS_CaseId($caseID; "human")
wmsZebra128:=WMS_CaseId($caseID; "zebra")
zwStatusMsg("PRINTING"; "Press the <esc> key to cancel.")
ON EVENT CALL:C190("eCancelProc")
<>fContinue:=True:C214
While (wmsCaseNumber1>=$firstCaseNumber) & (<>fContinue)
	Case of 
		: ($1=1)
			$buffer:=Zebra_Print_MH10_Arkay
		: ($1=4)
			$buffer:=Zebra_Print_PnG_Arkay
		: ($1=5)
			$buffer:=Zebra_Print_Arkay
		: ($1=6)
			$buffer:=Zebra_Print_Lauder08012000
		: ($1=7)  // new case Modified by: Mel Bohince (6/11/13)
			$buffer:=Zebra_Print_Lauder_SAP_Lot
		: ($1=8)
			$buffer:=Zebra_Print_LOreal
		: ($1=9)
			$buffer:=Zebra_Print_MH10_Loreal
		: ($1=10)
			$buffer:=Zebra_Print_Shiseido
		: ($1=11)
			$buffer:=Zebra_Print_ELCv4  //this one will slow down the printer pref
		: ($1=12)
			$buffer:=Zebra_Print_Revlon
		: ($1=13)
			$buffer:=Zebra_Print_LVMH
		: ($1=14)
			$buffer:=Zebra_Print_Nest
	End case 
	
	
	Case of 
		: (rb1=1)  //to serial port
			SEND PACKET:C103($buffer)
		: (rb2=1)  //to file
			SEND PACKET:C103(docRef; $buffer)
		: (rb3=1)  //to ip address
			$error:=TCP_Send(tcpID; $buffer)
			If ($error#0)
				ALERT:C41("Error: "+String:C10($error)+" on TCP_Send")
			End if 
	End case 
	DELAY PROCESS:C323(Current process:C322; 40)  //not sure if a delay is required to prvnt overflow [was 30 ticks]
	If (wmsCaseNumber1>0)
		wmsCaseNumber1:=wmsCaseNumber1-1
	Else 
		$firstCaseNumber:=$firstCaseNumber+1  //counting forward
	End if 
	$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
	wmsHumanReadable1:=WMS_CaseId($caseID; "human")
	wmsZebra128:=WMS_CaseId($caseID; "zebra")
End while 

If (<>fContinue)
	zwStatusMsg("PRINTING"; "Done.")
Else 
	zwStatusMsg("PRINTING"; "Cancelled.")
	uConfirm("Printing cancelled."; "OK"; "Help")
End if 
ON EVENT CALL:C190("")