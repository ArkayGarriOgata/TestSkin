//%attributes = {}
// _______
// Method: OL_ExtendPriceAndCost   ( ) -> obj:$dollar_o with price and cost attributes
// By: Mel Bohince @ 11/17/21, 09:21:08
// Description
// use while sitting on an orderline to extend dollar
// respecting specialbilling
// because this is now done outside of trigger_CustomerOrderLines
// ----------------------------------------------------
C_OBJECT:C1216($0; $dollar_o)
C_TEXT:C284($1)  //orderline

If (Count parameters:C259>0)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If ([Customers_Order_Lines:41]Status:9="Cancel")
	[Customers_Order_Lines:41]Price_Extended:73:=0
	[Customers_Order_Lines:41]Cost_Extended:72:=0
	
Else 
	
	If ([Customers_Order_Lines:41]SpecialBilling:37)  // Modified by: Mel Bohince (11/20/18) 
		[Customers_Order_Lines:41]Price_Extended:73:=Round:C94([Customers_Order_Lines:41]Quantity:6*[Customers_Order_Lines:41]Price_Per_M:8; 2)
		[Customers_Order_Lines:41]Cost_Extended:72:=Round:C94(([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)*[Customers_Order_Lines:41]Cost_Per_M:7; 2)
	Else 
		[Customers_Order_Lines:41]Price_Extended:73:=Round:C94([Customers_Order_Lines:41]Quantity:6*[Customers_Order_Lines:41]Price_Per_M:8/1000; 2)
		[Customers_Order_Lines:41]Cost_Extended:72:=Round:C94(([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)*[Customers_Order_Lines:41]Cost_Per_M:7/1000; 2)
	End if 
	
End if   //cancelled order

//return values for some usecases
$dollar_o:=New object:C1471("extendedPrice"; [Customers_Order_Lines:41]Price_Extended:73; "extendedCost"; [Customers_Order_Lines:41]Cost_Extended:72)
$0:=$dollar_o

If (Count parameters:C259>0)  //restore
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
End if 
