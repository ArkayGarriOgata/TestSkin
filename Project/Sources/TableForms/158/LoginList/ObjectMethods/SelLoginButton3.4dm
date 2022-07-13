// _______
// Method: [Customer_Portal_Extracts].LoginList.SelLoginButton3   ( ) ->
//add customer to login

$custid:=Request:C163("Customer's id?"; "00000"; "Save"; "Cancel")
If (ok=1) & (Length:C16($custid)=5) & ($custid#"00000")
	
	$hit:=coCustomers.indexOf($custid)
	
	If ($hit=-1)  //not a dup
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$custid)
		If (Records in selection:C76([Customers:16])=1)
			
			coCustomers.push($custid)
			coCustomers:=coCustomers  // Refresh list
			OB SET:C1220(enLogin.Customers; "List"; coCustomers)
			enLogin.save()
			UNLOAD RECORD:C212([Customers:16])
			
		Else 
			uConfirm($custid+" is not a valid Customer ID"; "OK"; "Help")
		End if 
		
	Else 
		uConfirm($custid+" has already been included"; "OK"; "Help")
	End if 
	
Else 
	BEEP:C151
End if 