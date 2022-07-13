//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/17/10, 22:00:00
// ----------------------------------------------------
// Method: x_fix_releases
// Description
// set the shipped status of releases from an exported file
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($cr)
$r:=Char:C90(13)
C_TIME:C306($docRef)
$docRef:=Open document:C264("")
If ($docRef#?00:00:00?)
	
	RECEIVE PACKET:C104($docRef; $row; $r)
	While (ok=1)
		util_TextParser(7; $row)
		$relnum:=Num:C11(util_TextParser(1))
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$relnum)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
			
			[Customers_ReleaseSchedules:46]Actual_Date:7:=Date:C102(util_TextParser(2))
			[Customers_ReleaseSchedules:46]Actual_Qty:8:=Num:C11(util_TextParser(3))
			[Customers_ReleaseSchedules:46]InvoiceNumber:9:=Num:C11(util_TextParser(4))
			[Customers_ReleaseSchedules:46]B_O_L_number:17:=Num:C11(util_TextParser(5))
			[Customers_ReleaseSchedules:46]B_O_L_pending:45:=Num:C11(util_TextParser(6))
			[Customers_ReleaseSchedules:46]OpenQty:16:=Num:C11(util_TextParser(7))
			
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		End if 
		
		RECEIVE PACKET:C104($docRef; $row; $r)
	End while 
	
	CLOSE DOCUMENT:C267($docRef)
	util_TextParser
	
	
End if 