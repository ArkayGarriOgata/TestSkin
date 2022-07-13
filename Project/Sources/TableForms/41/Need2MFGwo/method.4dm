//(LP)Need2MFGwo adapted from [releaseSchedule].Need2MFG 11/11/94
Case of 
	: (Form event code:C388=On Header:K2:17)
		If (Level:C101=1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
				FIRST RECORD:C50([Finished_Goods_Locations:35])
				r2:=0
				r3:=0
				r5:=0  //qty consumed by prior release
				While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
					If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)="FG")
						r2:=r2+[Finished_Goods_Locations:35]QtyOH:9
					Else 
						r3:=r3+[Finished_Goods_Locations:35]QtyOH:9
					End if 
					NEXT RECORD:C51([Finished_Goods_Locations:35])
				End while 
				
			Else 
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
				
				r2:=0
				r3:=0
				r5:=0
				
				ARRAY TEXT:C222($_Location; 0)
				ARRAY LONGINT:C221($_QtyOH; 0)
				
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
				
				$numrec:=Size of array:C274($_QtyOH)
				
				For ($iter; 1; $numrec; 1)
					If (Substring:C12($_Location{$iter}; 1; 2)="FG")
						r2:=r2+$_QtyOH{$iter}
					Else 
						r3:=r3+$_QtyOH{$iter}
					End if 
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 First record
			
			// r4:=[ReleaseSchedule]Sched_Qty-(r2+r3)
		End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		If (r2>=r5)
			r2:=r2-r5  //take it all prior sched qty out of fg
			r3:=r3-0
			
		Else 
			
			If ((r3-(r5-r2))>=0)
				r3:=r3-(r5-r2)  //take remainder out of exam
				r2:=0  // (cant go negative) all remaining fg would have been consumed, 
			Else 
				r2:=0
				r3:=0  //need to mfg entire release
			End if 
			
		End if 
		r4:=[Customers_Order_Lines:41]Qty_Open:11-(r2+r3)
		r5:=r5+[Customers_Order_Lines:41]Qty_Open:11  //set up for next during phase of same cpn
		
		// RELATE ONE([ReleaseSchedule]OrderLine)
		RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Customers_Order_Lines:41]ProductCode:5)
		RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
		
End case 
//