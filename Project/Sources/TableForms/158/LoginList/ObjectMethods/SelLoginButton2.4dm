// _______
// Method: [Customer_Portal_Extracts].LoginList.SelLoginButton4   ( ) ->
// Description
// delete cust from login
// ----------------------------------------------------


C_TEXT:C284($custid)
If (esSelUsers.length>0)
	uConfirm("Delete the highlighted row(s)?"; "Delete"; "Cancel")
	If (ok=1)
		esUsers:=esUsers.minus(esSelUsers)
		esSelUsers.drop()
	End if 
	
Else 
	BEEP:C151
End if 