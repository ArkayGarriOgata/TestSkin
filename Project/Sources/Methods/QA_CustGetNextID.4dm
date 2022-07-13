//%attributes = {}
// Method: QA_CustGetNextID () -> 
// ----------------------------------------------------
// by: mel: 11/11/04, 15:30:17
// ----------------------------------------------------

C_TEXT:C284($0)  //Key No:=fGetInvoiceNum
C_LONGINT:C283($fileNum)

$fileNum:=Table:C252(->[QA_CustomerTestStandards:135])
READ WRITE:C146([x_id_numbers:3])
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$fileNum)

If (Records in selection:C76([x_id_numbers:3])#1)
	CREATE RECORD:C68([x_id_numbers:3])
	[x_id_numbers:3]Table_Number:1:=$fileNum
	[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting Test number: "; "1"))
	SAVE RECORD:C53([x_id_numbers:3])
End if 
If (fLockNLoad(->[x_id_numbers:3]))
	$0:=String:C10([x_id_numbers:3]ID_No:2; "00000")
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1
	SAVE RECORD:C53([x_id_numbers:3])
Else 
	BEEP:C151
	ALERT:C41("Next ID_NUMBER process stopped by user")
	CANCEL:C270
	$0:="error"
End if 

UNLOAD RECORD:C212([x_id_numbers:3])
READ ONLY:C145([x_id_numbers:3])