
Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.customers:=ds:C1482.Customers.query("( Active = :1 "; True:C214).orderBy("Name asc")
		customerSelection:="ACTIVE"
		
		//: (Form event=On Selection Change)
		//Form.Customer:=Form.clickedCustomer
		
		//: (Form event=On Double Clicked)
		//Form.customer:=Form.clickedCustomer
		//FORM GOTO PAGE(3)
		
	: (Form event code:C388=On After Edit:K2:43)  //save the commission percentage, the only editable column
		C_OBJECT:C1216($customer_o; $result)
		$customer_o:=New object:C1471
		$customer_o:=Form:C1466.customers.currItem
		$customer_o.CommissionPercent:=Form:C1466.customers.currItem.CommissionPercent
		$result:=$customer_o.save()
		
		If (Not:C34($result.success))
			uConfirm("Not saved. Error: "+$result.statusText; "Darn"; "Ok")
		End if 
		
		Form:C1466.customers:=Form:C1466.customers
		
	: (Form event code:C388=On Begin Drag Over:K2:44)
		zwStatusMsg("Reassigning"; Form:C1466.clickedCustomer.Name)
		
End case 