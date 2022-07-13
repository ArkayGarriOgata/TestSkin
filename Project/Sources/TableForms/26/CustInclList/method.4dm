Case of 
	: ((Form event code:C388=On Display Detail:K2:22) & (bCalcInv=1))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)
			CREATE SET:C116([Finished_Goods_Locations:35]; "fgs")
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@")
			r1:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			USE SET:C118("fgs")
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="EX@")
			r3:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			USE SET:C118("fgs")
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC@")
			r2:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			USE SET:C118("fgs")
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="RC@")
			r4:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			CLEAR SET:C117("fgs")
			
		Else 
			
			//step 1
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="EX@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="RC@"; *)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)
			SELECTION TO ARRAY:C260(\
				[Finished_Goods_Locations:35]Location:2; $_location; \
				[Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
			
			r1:=0
			r2:=0
			r3:=0
			r4:=0
			For ($i; 1; Size of array:C274($_location); 1)
				Case of 
					: ($_location{$i}="FG@")
						r1:=r1+$_QtyOH{$i}
					: ($_location{$i}="CC@")
						r2:=r2+$_QtyOH{$i}
					: ($_location{$i}="EX@")
						r3:=r3+$_QtyOH{$i}
					: ($_location{$i}="RC@")
						r4:=r4+$_QtyOH{$i}
				End case 
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
End case 