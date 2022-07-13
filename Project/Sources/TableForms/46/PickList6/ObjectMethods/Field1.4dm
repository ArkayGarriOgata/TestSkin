//4/27/95
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
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	r2:=0
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		r2:=r2+[Finished_Goods_Locations:35]QtyOH:9
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End while 
	//
Else 
	ARRAY LONGINT:C221($_QtyOH; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
	r2:=0
	
	For ($Iter; 1; Size of array:C274($_QtyOH); 1)
		
		r2:=r2+$_QtyOH{$Iter}
	End for 
	
End if   // END 4D Professional Services : January 2019 First record
