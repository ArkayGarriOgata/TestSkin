//(s) Sched_Date [releaSe schedule]PickList7
//4/27/95
//• 5/20/98 cs Michelle needs a jobform even if there is NO bin
If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
End if 
If ([Addresses:30]ID:1#[Customers_ReleaseSchedules:46]Shipto:10)
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_ReleaseSchedules:46]Shipto:10)
End if 
If ([Customers_Order_Lines:41]OrderLine:3#[Customers_ReleaseSchedules:46]OrderLine:4)
	RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
End if 
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_ReleaseSchedules:46]CustID:12; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")

If ([Finished_Goods:26]FG_KEY:47#([Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11))
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11)
End if 
r2:=0
r3:=0  //• 3/23/98 cs payuse
r4:=0  //• 3/23/98 cs total

Case of 
	: ([Finished_Goods_Locations:35]Location:2="FG:R@")  //this item lives in Roanoke
		sLoc:="Roanoke"
	: ([Finished_Goods_Locations:35]Location:2="FG:@")
		sLoc:="Haupp"
	Else 
		sLoc:="No QTY"
End case 
sJobForm:=[Finished_Goods_Locations:35]JobForm:19  //• 5/20/98 cs if no bin, no jobform

If (sJobForm="")  //`• 5/20/98 cs there is no bin
	
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "Hold")  //• 5/20/98 cs done to insure I do not lose other data
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
		sJobForm:=[Job_Forms_Items:44]JobForm:1
		USE NAMED SELECTION:C332("Hold")
		CLEAR NAMED SELECTION:C333("Hold")
		
	Else 
		CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "Hold")  //• 5/20/98 cs done to insure I do not lose other data
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
		sJobForm:=[Job_Forms_Items:44]JobForm:1
		USE NAMED SELECTION:C332("Hold")
		
	End if   // END 4D Professional Services : January 2019 
	
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		
		If (Position:C15("AV"; [Finished_Goods_Locations:35]Location:2)>0)  //payuse
			r3:=r3+[Finished_Goods_Locations:35]QtyOH:9
		Else 
			r2:=r2+[Finished_Goods_Locations:35]QtyOH:9
		End if 
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End while 
	
Else 
	
	ARRAY TEXT:C222($_Location; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
	
	For ($Iter; 1; Size of array:C274($_Location); 1)
		If (Position:C15("AV"; $_Location{$Iter})>0)  //payuse
			r3:=r3+$_QtyOH{$Iter}
		Else 
			r2:=r2+$_QtyOH{$Iter}
		End if 
	End for 
End if   // END 4D Professional Services : January 2019 First record

r4:=r3+r2
//