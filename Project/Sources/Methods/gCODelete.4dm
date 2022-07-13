//%attributes = {"publishedWeb":true}
//(P) gCODelete: Delete Customer Order - post negative entries to Bookings.
//BAK 6/10/94
//upr 1326 2/14/95
//2/15/95
//upr 1447 3/6/96  
//upr 1326 03/09/95 chip
//4/27/95 upr 1252
//• 8/20/97 cs remove reference to booking, procedures that are
//  left do nothing

C_LONGINT:C283($qtyCosted; $denom)

Case of 
	: ([Customers_Orders:40]Status:10="Cancel")  //upr 1326 2/14/95
		If ((Old:C35([Customers_Orders:40]Status:10)="Accepted") | (Old:C35([Customers_Orders:40]Status:10)="Hold Change Pending") | (Old:C35([Customers_Orders:40]Status:10)="Budgeted"))  //upr 1326 2/14/95
			FIRST RECORD:C50([Customers_Order_Lines:41])
			READ ONLY:C145([Finished_Goods:26])
			dAppDate:=4D_Current_date  //2/15/95
			
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For (i; 1; Records in selection:C76([Customers_Order_Lines:41]))
					//gAddBookings   `search & maybe add a book rec
					$Denom:=nlGetFGDenom  //4/27/95
					
					//If (Records in selection([Bookings])=1) & ([OrderLines
					//«]OrderType#"SpecialFrieght")
					//• 8/20/97 cs changed above if - removed reference to bookings
					If ([Customers_Order_Lines:41]OrderType:22#"SpecialFrieght")
						rQtyChg:=[Customers_Order_Lines:41]Quantity:6  //upr 1447 3/6/96
						$qtyCosted:=([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)  //upr 1447 3/6/96
						rSaleChg:=([Customers_Order_Lines:41]Price_Per_M:8*rQtyChg/$denom)  //upr 1326 03/09/95 chip
						rTTCost:=([Customers_Order_Lines:41]Cost_Per_M:7*$qtyCosted/$denom)
						rTTMatlCost:=([Customers_Order_Lines:41]CostMatl_Per_M:32*$qtyCosted/$denom)
						rTTLbrCost:=([Customers_Order_Lines:41]CostOH_Per_M:31*$qtyCosted/$denom)
						rTTOHCost:=([Customers_Order_Lines:41]CostLabor_Per_M:30*$qtyCosted/$denom)
						rTTScCost:=([Customers_Order_Lines:41]CostScrap_Per_M:33*$qtyCosted/$denom)
						// •gRemoveBookings• ("Deletion, gCoDelete")  `upr 1326 03/09/95
						//« chip, `4/27/95
					End if   //1 booking record selected
					NEXT RECORD:C51([Customers_Order_Lines:41])
				End for 
				
			Else 
				//laghzaoui see methode nlGetFGDenom
				ARRAY BOOLEAN:C223($_SpecialBilling; 0)
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY TEXT:C222($_OrderType; 0)
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY LONGINT:C221($_ExcessQtySold; 0)
				ARRAY REAL:C219($_Price_Per_M; 0)
				ARRAY REAL:C219($_Cost_Per_M; 0)
				ARRAY REAL:C219($_CostMatl_Per_M; 0)
				ARRAY REAL:C219($_CostOH_Per_M; 0)
				ARRAY REAL:C219($_CostLabor_Per_M; 0)
				ARRAY REAL:C219($_CostScrap_Per_M; 0)
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]SpecialBilling:37; $_SpecialBilling; \
					[Customers_Order_Lines:41]ProductCode:5; $_ProductCode; \
					[Customers_Order_Lines:41]CustID:4; $_CustID; \
					[Customers_Order_Lines:41]OrderType:22; $_OrderType; \
					[Customers_Order_Lines:41]Quantity:6; $_Quantity; \
					[Customers_Order_Lines:41]ExcessQtySold:40; $_ExcessQtySold; \
					[Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; \
					[Customers_Order_Lines:41]Cost_Per_M:7; $_Cost_Per_M; \
					[Customers_Order_Lines:41]CostMatl_Per_M:32; $_CostMatl_Per_M; \
					[Customers_Order_Lines:41]CostOH_Per_M:31; $_CostOH_Per_M; \
					[Customers_Order_Lines:41]CostLabor_Per_M:30; $_CostLabor_Per_M; \
					[Customers_Order_Lines:41]CostScrap_Per_M:33; $_CostScrap_Per_M)
				
				For ($i; 1; Size of array:C274($_SpecialBilling); 1)
					
					If ($_SpecialBilling{$i})
						QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$_ProductCode{$i})
						
					Else 
						qryFinishedGood($_CustID{$i}; $_ProductCode{$i})  //5/8/95
					End if 
					
					Case of 
						: (Records in selection:C76([Finished_Goods:26])=0)
							$Denom:=1
						: ([Finished_Goods:26]Acctg_UOM:29="M")
							$Denom:=1000
						Else 
							$Denom:=1
					End case 
					
					If ($_OrderType{$i}#"SpecialFrieght")
						
						rQtyChg:=$_Quantity{$i}  //upr 1447 3/6/96
						$qtyCosted:=($_Quantity{$i}-$_ExcessQtySold{$i})  //upr 1447 3/6/96
						rSaleChg:=($_Price_Per_M{$i}*rQtyChg/$denom)  //upr 1326 03/09/95 chip
						rTTCost:=($_Cost_Per_M{$i}*$qtyCosted/$denom)
						rTTMatlCost:=($_CostMatl_Per_M{$i}*$qtyCosted/$denom)
						rTTLbrCost:=($_CostOH_Per_M{$i}*$qtyCosted/$denom)
						rTTOHCost:=($_CostLabor_Per_M{$i}*$qtyCosted/$denom)
						rTTScCost:=($_CostScrap_Per_M{$i}*$qtyCosted/$denom)
						
					End if 
				End for 
				
			End if   // END 4D Professional Services : January 2019 
			
			UNLOAD RECORD:C212([Finished_Goods:26])
		End if 
		
	: ([Customers_Orders:40]Status:10="Kill")
		If ((Old:C35([Customers_Orders:40]Status:10)="Accepted") | (Old:C35([Customers_Orders:40]Status:10)="Hold Change Pending") | (Old:C35([Customers_Orders:40]Status:10)="Budgeted"))  //upr 1326 2/14/95
			FIRST RECORD:C50([Customers_Order_Lines:41])
			READ ONLY:C145([Finished_Goods:26])
			dAppDate:=4D_Current_date  //2/15/95
			//uConfirm ("Killing this Order will Remove All Traces of the Order
			//« from Bookings."+◊sCr+"Are You SURE that You Want to 'Kill' this Order?";
			//«"Stop";"Kill")
			
			//If (OK=0)  `user wants to kill order.
			//
			//If (False)  `• 8/20/97 cs remove bookings     
			//SEARCH([old_BookingTran];[old_BookingTran]OrderNum=
			//«[CustomerOrder]OrderNumber)
			//READ WRITE([old_Bookings])
			//  ` •gKillBookings• ("Killed")
			//End if 
			//End if 
		End if   //first time in Delete status  
End case 