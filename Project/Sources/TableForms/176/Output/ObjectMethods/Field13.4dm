Case of 
	: (Form event code:C388=On Data Change:K2:15)
		[Customers_Order_Changed_Items:176]NewProductCode:10:=fStripSpace("B"; [Customers_Order_Changed_Items:176]NewProductCode:10)  //• mlb - 3/11/02  16:11
		
		If ([Customers_Order_Change_Orders:34]NewEstimate:38#"") & ([Customers_Order_Changed_Items:176]NewProductCode:10#[Customers_Order_Changed_Items:176]OldProductCode:9)
			ALERT:C41("Cannot change Product Code when Revising Estimate Number."+Char:C90(13)+"Create new Change Order."; "Shucks")
			[Customers_Order_Changed_Items:176]NewProductCode:10:=Old:C35([Customers_Order_Changed_Items:176]NewProductCode:10)
		End if 
		
		$hit:=qryFinishedGood("#CPN"; [Customers_Order_Changed_Items:176]NewProductCode:10)
		If ($hit>0)
			gLoadHistItem
		End if 
End case   //(S) NewProductCode

//EOP
