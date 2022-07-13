If (Form event code:C388=On Display Detail:K2:22)
	C_LONGINT:C283($i)
	MESSAGES OFF:C175
	If ([Customers_Orders:40]OrderNumber:1#[Customers_Order_Lines:41]OrderNumber:1)
		RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
	End if 
	If ([Finished_Goods:26]FG_KEY:47#([Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5))
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)
	End if 
	i1:=[Customers_Order_Lines:41]Quantity:6+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100))
	RELATE MANY:C262([Customers_Order_Lines:41]OrderLine:3)
	ARRAY LONGINT:C221($alongint1; 0)
	ARRAY LONGINT:C221($alongint2; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Qty:6; $alongint1; [Customers_ReleaseSchedules:46]Actual_Qty:8; $alongint2)
	i2:=0
	i3:=0
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7; <)
		FIRST RECORD:C50([Customers_ReleaseSchedules:46])
		
	Else 
		
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7; <)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	If ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		t1:=""
	Else 
		t1:=String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; 1)
	End if 
	
	For ($i; 1; Size of array:C274($alongint1))
		i2:=i2+$alongint1{$i}  //[ReleaseSchedule]Sched_Qty
		i3:=i3+$alongint2{$i}  //[ReleaseSchedule]Actual_Qty
	End for 
	i4:=i1-i3
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
	i5:=0
	ARRAY LONGINT:C221($alongint1; 0)
	ARRAY LONGINT:C221($alongint2; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Qty:6; $alongint1)
	For ($i; 1; Size of array:C274($alongint1))
		i5:=i5+$alongint1{$i}  //[FG_Locations]QtyOH
	End for 
	
	real1:=(i4/1000)*[Customers_Order_Lines:41]Price_Per_M:8
	MESSAGES ON:C181
End if 
//