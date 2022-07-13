//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/19/07, 14:31:30
// ----------------------------------------------------
// Method: trigger_CustomerOrders
// ----------------------------------------------------
C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Customers_Orders:40]CustomerName:39:=CUST_getName([Customers_Orders:40]CustID:2)  // Modified by: Mel Bohince (8/21/13)
		
		If (Length:C16([Customers_Orders:40]FOB:25)=0)
			[Customers_Orders:40]FOB:25:="Arkay"
		End if 
		[Customers_Orders:40]PV:21:=NaNtoZero([Customers_Orders:40]PV:21)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		If (Length:C16([Customers_Orders:40]FOB:25)=0)
			[Customers_Orders:40]FOB:25:="Arkay"
		End if 
		[Customers_Orders:40]PV:21:=NaNtoZero([Customers_Orders:40]PV:21)
		[Customers_Orders:40]CustomerName:39:=CUST_getName([Customers_Orders:40]CustID:2)  // Modified by: Mel Bohince (8/21/13)
		
End case 