[Customers_Order_Lines:41]NeedDateOld:51:=[Customers_Order_Lines:41]NeedDate:14
[Customers_Order_Lines:41]NeedDate:14:=[Customers_Order_Lines:41]edi_dock_date:64

//uConfirm ("Suggest shipping on "+String($shipOn;Long )+". Apply to Releases?";"Apply";"Ignore")
//If (ok=1)

If (sDateLimitor(->[Customers_Order_Lines:41]NeedDate:14; 730)=0)  // Modified by: Mel Bohince (5/2/16) 
	
	edi_use_their_date
	
	
Else 
	[Customers_Order_Lines:41]NeedDate:14:=[Customers_Order_Lines:41]NeedDateOld:51
	
End if 