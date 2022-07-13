USE SET:C118("threeLoaded")
If (allinventory=0)
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:@"; *)
	QUERY SELECTION:C341([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="BH:@")  //• 1/9/98 cs Lena wants to see B&H too\
		
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
End if 
sAskMeTotals