//(s) asChgStat  3/8/95
//°5/3/95 upr 1487
//•053195  MLB  UPR 1619

If (asChgStat#0)
	Case of   //old status being:
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="New")
			Case of 
				: (asChgStat{asChgStat}="New")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Open@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Customer@")
					//*Test the chk boxes on page 1
					If (fCustServAllow)  //•053195  MLB  UPR 1619
						[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
					Else 
						BEEP:C151
						ALERT:C41("This CCO must be routed thru Planning, set Status to 'Opened'.")
					End if 
					
				: (asChgStat{asChgStat}="Pricing@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Cancel@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				Else 
					BEEP:C151
					ALERT:C41("'New' change orders can be Opened, Cancelled,"+" or forwarded to Customer Service or Pricing.")
			End case 
			
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Open@")
			Case of 
				: (asChgStat{asChgStat}="New")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Open@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Customer@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Pricing@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Cancel@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				Else 
					BEEP:C151
					ALERT:C41("'Open' change orders can only be Cancelled or set to Customer Service or Pricing")
			End case 
			
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Customer@")
			Case of 
				: (asChgStat{asChgStat}="New")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Open@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Customer@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Pricing@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Cancel@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Proceed@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Advise@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Reject@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				Else 
					BEEP:C151
			End case 
			
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Pricing@")
			Case of 
				: (asChgStat{asChgStat}="New")
					// If (Old([Customers_Order_Change_Orders]ChgOrderStatus)#"New")    `°5/3/95 upr 1487
					// BEEP
					//ALERT("You cannot set the status back to 'New.'")
					// Else 
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
					//  End if 
				: (asChgStat{asChgStat}="Open@")
					//  If (Old([Customers_Order_Change_Orders]ChgOrderStatus)#"Open@")    `°5/3/95 upr 1487
					//  BEEP
					// ALERT("You cannot set the status back to 'Opened.'")
					// Else 
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
					//End if 
				: (asChgStat{asChgStat}="Customer@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Pricing@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Cancel@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Proceed@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Advise@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Reject@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				Else 
					BEEP:C151
			End case 
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Proceed@")
			//If (Old([Customers_Order_Change_Orders]ChgOrderStatus)="Proceed@")
			//BEEP
			//ALERT("This change order must stay at the current status.")
			//Else 
			[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
			//End if 
			
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Advise@")
			Case of 
				: (asChgStat{asChgStat}="Proceed@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				: (asChgStat{asChgStat}="Advise@")
					
				: (asChgStat{asChgStat}="Reject@")
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
				Else 
					BEEP:C151
					ALERT:C41("'Advise' status can go only to 'Proceed' or 'Reject'.")
			End case 
			
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Reject@")
			If (Old:C35([Customers_Order_Change_Orders:34]ChgOrderStatus:20)="Reject@")
				BEEP:C151
				ALERT:C41("This change order must stay at the current status.")
			Else 
				[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
			End if 
		: ([Customers_Order_Change_Orders:34]ChgOrderStatus:20="Cancel@")
			If (Old:C35([Customers_Order_Change_Orders:34]ChgOrderStatus:20)="Cancel@")
				BEEP:C151
				ALERT:C41("This change order must stay at the current status.")
			Else 
				[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=asChgStat{asChgStat}
			End if 
	End case 
	
	//[Customers_Order_Change_Orders]ChgOrderStatus:=asChgStat{asChgStat}
End if 