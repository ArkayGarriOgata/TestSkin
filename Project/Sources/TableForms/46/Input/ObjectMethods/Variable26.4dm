C_TEXT:C284($custID)
$custID:=Request:C163("What is the correct CustID"; [Customers_ReleaseSchedules:46]CustID:12)
If (ok=1)
	C_OBJECT:C1216($es)  // Modified by: Mel Bohince (3/5/21) switch to ORDA
	$es:=ds:C1482.Customers.query("ID= :1"; $custID)
	If ($es.length=1)
		[Customers_ReleaseSchedules:46]CustID:12:=$custID
	Else 
		uConfirm($custID+" was not found in the Customer records."; "Shucks"; "Try Again")
	End if 
End if 
//