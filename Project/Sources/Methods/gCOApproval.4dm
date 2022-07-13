//%attributes = {"publishedWeb":true}
//(P)gCOApproval: Approve Customer Order
//BAK 6/9/94 - Added material costs to calculate Average Value Added.
//2/15/95 test for Hold change pending added
//upr 1447 3/6/96
//upr 1326 03/09/95 chip
//4/27/95 chip upr 1252
//•100496  MLB  make sure the orderlines are all selected
//• 8/20/97 cs remove reference to booking, procedures that are
//  left do nothing
//•112697  MLB  set the DateBooked at the orderline level
//• 3/6/98 cs make sure that closed date is set

C_REAL:C285($denom)
C_LONGINT:C283($k; $qtyCosted)

If ([Customers_Orders:40]Status:10="Accepted")
	If ((Old:C35([Customers_Orders:40]Status:10)#"Accepted") & (Old:C35([Customers_Orders:40]Status:10)#"Hold@") & (Old:C35([Customers_Orders:40]Status:10)#"Budgeted"))
		//2/15/95 test for Hold change pending & budgeted added
		
		$sFailStat:="Credit Hold"
		
		If (True:C214)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)  //•100496  MLB 
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)  //•100496  MLB  
				FIRST RECORD:C50([Customers_Order_Lines:41])
				
				
			Else 
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)  //•100496  MLB 
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)  //•100496  MLB  
				
				//
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			READ ONLY:C145([Finished_Goods:26])
			//BAK 8/26/94 - give Bob control of Accepted date for Bookings
			dAppDate:=4D_Current_date
			[Customers_Orders:40]DateApproved:45:=Date:C102(Request:C163("Order Approval and Booking Date "; String:C10(dAppDate)))
			$k:=0
			
			While ([Customers_Orders:40]DateApproved:45=!00-00-00!)
				$k:=$k+1
				ALERT:C41("Not a valid date.  Defaulting to current date.")
				dAppDate:=4D_Current_date
				[Customers_Orders:40]DateApproved:45:=Date:C102(Request:C163("Order Approval and Booking Date "; String:C10(dAppDate)))
				
				If ($k=4)
					ALERT:C41("Order will be accepted with current date."+Char:C90(13)+"Contact Administrator for assistance.")
					[Customers_Orders:40]DateApproved:45:=4D_Current_date
				End if 
			End while 
			dAppDate:=[Customers_Orders:40]DateApproved:45
			
			For (i; 1; Records in selection:C76([Customers_Order_Lines:41]))
				// gAddBookings   `search & maybe add a book rec      
				$Denom:=nlGetFGDenom
				//If (Records in selection([Bookings])=1) & ([OrderLines
				//«]OrderType#"SpecialFrieght")
				//• 8/20/97 cs changed above if - removed reference to bookings
				If ([Customers_Order_Lines:41]OrderType:22#"SpecialFrieght")
					rQtyChg:=[Customers_Order_Lines:41]Quantity:6  //upr 1447 3/6/96
					lQtyPricedO:=1  //usd in gaddtobookings
					$qtyCosted:=([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)  //upr 1447 3/6/96
					rSaleChg:=([Customers_Order_Lines:41]Price_Per_M:8*rQtyChg/$denom)  //upr 1326 03/09/95 chip
					rTTCost:=([Customers_Order_Lines:41]Cost_Per_M:7*$qtyCosted/$denom)
					rTTMatlCost:=([Customers_Order_Lines:41]CostMatl_Per_M:32*$qtyCosted/$denom)
					rTTLbrCost:=([Customers_Order_Lines:41]CostOH_Per_M:31*$qtyCosted/$denom)
					rTTOHCost:=([Customers_Order_Lines:41]CostLabor_Per_M:30*$qtyCosted/$denom)
					rTTScCost:=([Customers_Order_Lines:41]CostScrap_Per_M:33*$qtyCosted/$denom)
					//gAddtoBookings ("AcceptedOrder")  `upr 1326 03/09/95 chip ,
					//« added parameter 4/27/95
				End if   //1 booking record selected
				[Customers_Order_Lines:41]DateOpened:13:=[Customers_Orders:40]DateOpened:6
				If ([Customers_Order_Lines:41]DateBooked:49=!00-00-00!)  //•112697  MLB
					[Customers_Order_Lines:41]DateBooked:49:=4D_Current_date  //•112697  MLB
				End if 
				If ([Customers_Order_Lines:41]Qty_Booked:48=0)  //•112697  MLB
					[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6  //•112697  MLB
				End if 
				SAVE RECORD:C53([Customers_Order_Lines:41])
				NEXT RECORD:C51([Customers_Order_Lines:41])
			End for 
			UNLOAD RECORD:C212([Finished_Goods:26])
			
		Else 
			[Customers_Orders:40]Status:10:=$sFailStat
			
			If ([Customers_Orders:40]Status:10="Closed")  //• 3/6/98 cs make sure that closed date is set
				[Customers_Orders:40]DateClosed:49:=4D_Current_date
			End if 
			[Customers_Orders:40]ModWho:8:=<>zResp
			[Customers_Orders:40]ModDate:9:=4D_Current_date
			SAVE RECORD:C53([Customers_Orders:40])
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9:=[Customers_Orders:40]Status:10)
			FIRST RECORD:C50([Customers_Order_Lines:41])
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13:=[Customers_Orders:40]DateOpened:6)
		End if   //first time in accepted status
	End if 
End if 