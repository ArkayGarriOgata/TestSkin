//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/21/13, 16:38:25
// ----------------------------------------------------
// Method: trigger_CustomerOrderLines
// Description
// 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (1/16/19) remove excess sold qty from costing
// Modified by: Mel Bohince (11/17/21) refactor to OL_ExtendPriceAndCost

C_LONGINT:C283($0)
C_OBJECT:C1216($dollar_o)
$0:=0  //assume granted

Case of 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Customers_Order_Lines:41]CustomerName:24:=CUST_getName([Customers_Order_Lines:41]CustID:4)  // Modified by: Mel Bohince (8/21/13)
		$dollar_o:=OL_ExtendPriceAndCost
		
		
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Customers_Order_Lines:41]CustomerName:24:=CUST_getName([Customers_Order_Lines:41]CustID:4)  // Modified by: Mel Bohince (8/21/13)
		$dollar_o:=OL_ExtendPriceAndCost
		
		
End case 