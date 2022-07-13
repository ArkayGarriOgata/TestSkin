
$was:=[Customers_Invoices:88]Status:22

[Customers_Invoices:88]Status:22:=util_ComboBoxAction(->aInvoStatus)

//Object Method: Status()  042099  MLB
//control invoice status


Case of 
	: ($was=[Customers_Invoices:88]Status:22)
		//cool
	: ($was="Pending") & ([Customers_Invoices:88]Status:22="Approved")
	: ($was="Pending") & ([Customers_Invoices:88]Status:22="Hold")
		//cool
	: ($was="Posted") & ([Customers_Invoices:88]Status:22="Paid")
		//cool  
	: ($was="Approved") & ([Customers_Invoices:88]Status:22="Pending")
	: ($was="Approved") & ([Customers_Invoices:88]Status:22="Hold")
		
	: ($was="Hold") & ([Customers_Invoices:88]Status:22="Pending")
	: ($was="Hold") & ([Customers_Invoices:88]Status:22="Approved")
		
	: ($was="") & ([Customers_Invoices:88]Status:22="Pending")
	: ($was="") & ([Customers_Invoices:88]Status:22="Hold")
		//cool    
	Else 
		uConfirm("Are you sure you want to change the Status to '"+[Customers_Invoices:88]Status:22+"'?"; "Yes"; "No")
		If (ok=0)
			[Customers_Invoices:88]Status:22:=$was
			util_ComboBoxSetup(->aInvoStatus; [Customers_Invoices:88]Status:22)
		End if 
End case 

If ([Customers_Invoices:88]Status:22#$was)
	GOTO OBJECT:C206([Customers_Invoices:88]AmountPaid:24)
End if 