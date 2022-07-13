//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/28/08, 14:33:40
// ----------------------------------------------------
// Method: Zebra_Print_Skid_SSCC
// ----------------------------------------------------

If (wmsSkidNumber>0)  //sometimes want to print without case number
	$firstSkidNumber:=wmsSkidNumber  //this is the normal way to increment case number
	$lastSkidNumber:=$firstSkidNumber+iCnt-1
	wmsSkidNumber:=$lastSkidNumber  //were going backwards
Else   //leave case# zero and don't print
	$firstSkidNumber:=iCnt*-1  //start negative towards zero
End if 
$barcodeValue:=WMS_SkidId(""; "set"; "2"; wmsSkidNumber)  //start with the last
SSCC_HumanReadable:=WMS_SkidId($barcodeValue; "human")
SSCC_Barcode:=$barcodeValue  //WMS_SkidId (SSCC_HumanReadable;"barcode")

zwStatusMsg("PRINTING"; "Press the <esc> key to cancel.")
ON EVENT CALL:C190("eCancelProc")
<>fContinue:=True:C214
C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data
$printQty:="^PQ"+String:C10(iNumberUp)
C_TEXT:C284($labelDef)

While (wmsSkidNumber>=$firstSkidNumber) & (<>fContinue)
	$labelDef:=""
	$labelDef:=$labelDef+"^XA"+$cr
	//$labelDef:=$labelDef+"^PRA"+$cr
	$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
	$labelDef:=$labelDef+"^XFR:SSCC.ZPL"+$cr
	$labelDef:=$labelDef+"^FN1"+"^FD"+SSCC_Barcode+$e
	$labelDef:=$labelDef+"^FN2"+"^FD"+SSCC_HumanReadable+$e
	$labelDef:=$labelDef+$printQty
	$labelDef:=$labelDef+"^XZ"+$cr
	$buffer:=$labelDef  //SEND PACKET($labelDef)
	
	Case of 
		: (rb1=1)  //to serial port
			SEND PACKET:C103($buffer)
		: (rb2=1)  //to file
			SEND PACKET:C103($buffer)
		: (rb3=1)  //to ip address
			$error:=TCP_Send(tcpID; $buffer)
			If ($error#0)
				ALERT:C41("Error: "+String:C10($error)+" on TCP_Send")
			End if 
	End case 
	
	DELAY PROCESS:C323(Current process:C322; 30)  //not sure if a delay is required to prvnt overflow
	
	If (wmsSkidNumber>0)
		wmsSkidNumber:=wmsSkidNumber-1
	Else 
		$firstSkidNumber:=$firstSkidNumber+1  //counting forward
	End if 
	
	If (wmsSkidNumber>0)  //wms_skidid will change a 0 to 1, forget why
		$barcodeValue:=WMS_SkidId(""; "set"; "2"; wmsSkidNumber)  //start with the last
		SSCC_HumanReadable:=WMS_SkidId($barcodeValue; "human")
		SSCC_Barcode:=$barcodeValue  //WMS_SkidId (SSCC_HumanReadable;"barcode")
	End if 
	
End while 

If (<>fContinue)
	zwStatusMsg("PRINTING"; "Done.")
Else 
	zwStatusMsg("PRINTING"; "Cancelled.")
	uConfirm("Printing cancelled."; "OK"; "Help")
End if 

ON EVENT CALL:C190("")