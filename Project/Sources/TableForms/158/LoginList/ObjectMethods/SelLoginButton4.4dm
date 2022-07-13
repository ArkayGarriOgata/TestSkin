// _______
// Method: [Customer_Portal_Extracts].LoginList.SelLoginButton4   ( ) ->
// Description
// delete cust from login
// ----------------------------------------------------


C_TEXT:C284($custid)
If (coSelCustomers.length>0)
	uConfirm("Delete the highlighted row(s)?"; "Delete"; "Cancel")
	If (ok=1)
		
		For each ($custid; coSelCustomers)
			$hit:=coCustomers.indexOf($custid)
			If ($hit>=0)
				coCustomers.remove($hit; 1)
			End if 
			
		End for each 
		coCustomers:=coCustomers
		OB SET:C1220(enLogin.Customers; "List"; coCustomers)
		enLogin.save()
		
	End if 
	
Else 
	BEEP:C151
End if 