//Layout Proc.: Orderlines.SalesBacklog()  
//•121096  mBohince  add limits to production backlog calc.
Case of 
	: (Form event code:C388=On Display Detail:K2:22)  //each ORDER record    
		MESSAGES OFF:C175
		real1:=0
		real2:=0
		real3:=0
		real4:=0
		real5:=0
		real6:=0
		real7:=0
		
		real11:=([Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100)))  //total allowable ship
		real12:=real11-[Customers_Order_Lines:41]Qty_Open:11  //net shipments
		real1:=real1+((real11/1000)*[Customers_Order_Lines:41]Price_Per_M:8)  //accumulate total allowable
		real2:=real2+((real12/1000)*[Customers_Order_Lines:41]Price_Per_M:8)  //accumulate net shipments
		real3:=real3+(((real11-real12)/1000)*[Customers_Order_Lines:41]Price_Per_M:8)  //accumulate total open
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 ks said to include cc
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //•121495 KS said to include xc
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
				real4:=real4+Round:C94((([Finished_Goods_Locations:35]QtyOH:9/1000)*[Customers_Order_Lines:41]Price_Per_M:8); 0)
				NEXT RECORD:C51([Finished_Goods_Locations:35])
			End while 
			
		Else 
			ARRAY LONGINT:C221($_QtyOH; 0)
			C_REAL:C285($_Price_Per_M)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
			$_Price_Per_M:=[Customers_Order_Lines:41]Price_Per_M:8
			For ($Iter; 1; Size of array:C274($_QtyOH); 1)
				
				real4:=real4+Round:C94((($_QtyOH{$Iter}/1000)*$_Price_Per_M); 0)
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="Ex@")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
				real5:=real5+Round:C94((([Finished_Goods_Locations:35]QtyOH:9/1000)*[Customers_Order_Lines:41]Price_Per_M:8); 0)
				real6:=real6+Round:C94(((([Finished_Goods_Locations:35]QtyOH:9*([Finished_Goods_Locations:35]PercentYield:17/100))/1000)*[Customers_Order_Lines:41]Price_Per_M:8); 0)
				NEXT RECORD:C51([Finished_Goods_Locations:35])
			End while 
			
		Else 
			
			$_Price_Per_M:=[Customers_Order_Lines:41]Price_Per_M:8
			
			ARRAY LONGINT:C221($_QtyOH; 0)
			ARRAY REAL:C219($_PercentYield; 0)
			
			
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]PercentYield:17; $_PercentYield)
			
			For ($Iter; 1; Size of array:C274($_PercentYield); 1)
				
				real5:=real5+Round:C94((($_QtyOH{$Iter}/1000)*$_Price_Per_M); 0)
				real6:=real6+Round:C94(((($_QtyOH{$Iter}*($_PercentYield{$Iter}/100))/1000)*$_Price_Per_M); 0)
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=[Customers_Order_Lines:41]CustID:4)
		C_LONGINT:C283($openProd)  //•121096  mBohince  
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))
				$openProd:=[Job_Forms_Items:44]Qty_Yield:9-[Job_Forms_Items:44]Qty_Actual:11
				If ($openProd>0)
					If (($openProd/[Job_Forms_Items:44]Qty_Yield:9)>0.1)  //greater than 10% unproduced
						real7:=real7+Round:C94((($openProd/1000)*[Customers_Order_Lines:41]Price_Per_M:8); 0)
					Else 
						real7:=real7+0
					End if 
					
				Else 
					real7:=real7+0
				End if 
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			
		Else 
			
			$_Price_Per_M:=[Customers_Order_Lines:41]Price_Per_M:8
			
			ARRAY LONGINT:C221($_Qty_Yield; 0)
			ARRAY LONGINT:C221($_Qty_Actual; 0)
			
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $_Qty_Yield; [Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual)
			
			For ($Iter; 1; Size of array:C274($_Qty_Actual); 1)
				$openProd:=$_Qty_Yield{$Iter}-$_Qty_Actual{$Iter}
				If ($openProd>0)
					If (($openProd/$_Qty_Yield{$Iter})>0.1)  //greater than 10% unproduced
						real7:=real7+Round:C94((($openProd/1000)*$_Price_Per_M); 0)
					Else 
						real7:=real7+0
					End if 
					
				Else 
					real7:=real7+0
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		MESSAGES ON:C181
End case 
//