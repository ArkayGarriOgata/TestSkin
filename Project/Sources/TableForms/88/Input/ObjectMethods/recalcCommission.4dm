// _______
// Method: [Customers_Invoices].Input.recalcCommission   ( ) ->
//@author mlb - 6/20/01  10:12

C_REAL:C285($newComm)

If (Position:C15("ADJUSTMENT"; [Customers_Invoices:88]Terms:18)=0)  //use normal technique
	$newComm:=fSalesCommission("Normal"; [Customers_Invoices:88]OrderLine:4; [Customers_Invoices:88]Quantity:15/1000; [Customers_Invoices:88]ExtendedPrice:19)
	
Else   //CREDIT FOR ADJUSTMENT, set by Invoice_NewReturn (via FG Return dialog) and Invoice_NewAdjustment (via cust change order)
	If ([Customers_Invoices:88]PricingUOM:17="M") | ([Customers_Invoices:88]PricingUOM:17="")  //treat as per thousand
		$units:=[Customers_Invoices:88]Quantity:15/1000
	Else 
		$units:=[Customers_Invoices:88]Quantity:15
	End if 
	$newComm:=fSalesCommissionAdj([Customers_Invoices:88]OrderLine:4; $units; [Customers_Invoices:88]ExtendedPrice:19)
End if 


//Option to apply the recalculation
$newComm:=Round:C94($newComm; 2)
If ($newComm#[Customers_Invoices:88]CommissionPayable:21)
	uConfirm("Recalculation = $ "+String:C10($newComm; "###,##0.00")+". Save the new value?"; "Save"; "Cancel")
	If (ok=1)
		[Customers_Invoices:88]CommissionPayable:21:=$newComm
	Else 
		[Customers_Invoices:88]CommissionScale:30:=Old:C35([Customers_Invoices:88]CommissionScale:30)
		[Customers_Invoices:88]CommissionPercent:31:=Old:C35([Customers_Invoices:88]CommissionPercent:31)
	End if 
	
Else 
	uConfirm("No change required."; "OK"; "Help")
	[Customers_Invoices:88]CommissionScale:30:=Old:C35([Customers_Invoices:88]CommissionScale:30)
	[Customers_Invoices:88]CommissionPercent:31:=Old:C35([Customers_Invoices:88]CommissionPercent:31)
End if 
