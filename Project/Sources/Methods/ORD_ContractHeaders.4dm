//%attributes = {}

// Method: ORD_ContractHeaders ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/29/15, 16:34:39
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="CONTRACT")
For ($i; 1; Records in selection:C76([Customers_Orders:40]))  //each order, if it doesn't have a line in contract status then its not contract
	$numOLinContract:=0
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numOLinContract)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="CONTRACT")
	If ($numOLinContract=0)  //promote or kill
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Status:9; $aOL_status)
			SORT ARRAY:C229($aOL_status; >)
			[Customers_Orders:40]Status:10:=$aOL_status{1}
			SAVE RECORD:C53([Customers_Orders:40])
		End if 
	End if 
	NEXT RECORD:C51([Customers_Orders:40])
End for 

SET QUERY DESTINATION:C396(Into current selection:K19:1)
REDUCE SELECTION:C351([Customers_Orders:40]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
