$temp:=[Customers_Order_Lines:41]Price_Per_M:8
[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33)
If ($temp#[Customers_Order_Lines:41]Price_Per_M:8)
	[Customers_Order_Lines:41]chgd_price:27:=True:C214
End if 