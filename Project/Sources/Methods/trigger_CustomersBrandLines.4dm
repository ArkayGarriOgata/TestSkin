//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 11:58:42
// ----------------------------------------------------
// Method: trigger_CustomersBrandLines()  --> 
// ----------------------------------------------------

If ([Customers_Brand_Lines:39]ContractPctMatl:10=0)
	[Customers_Brand_Lines:39]ContractPctMatl:10:=62
	[Customers_Brand_Lines:39]ContractPctLab:8:=26
	[Customers_Brand_Lines:39]ContractPctOH:9:=12
End if 