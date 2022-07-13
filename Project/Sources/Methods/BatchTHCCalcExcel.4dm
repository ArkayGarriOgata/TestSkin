//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/14/12, 13:04:07
// ----------------------------------------------------
// Method: BatchTHCCalcExcel
// Description:
// Used to launch the data generated on the server in Excel on the client.
// $1 = Text var sent by the server. It contains the Excel data.
// ----------------------------------------------------

C_TEXT:C284($tdocName; $1)
C_TIME:C306($docRef)

$tdocName:="TimeHorizonCalc-"+fYYMMDD($today)+".xls"
$docRef:=util_putFileName(->$tdocName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $1)
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType ($tdocName)
	$err:=util_Launch_External_App($tdocName)
End if 

UNREGISTER CLIENT:C649