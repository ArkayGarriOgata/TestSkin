//%attributes = {}
// Method: FGL_getInventory (cpn{;fg only}) -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 10:13:41
// ----------------------------------------------------
// Description:
// return qty onhand


// ----------------------------------------------------
C_LONGINT:C283($0)
C_TEXT:C284($1; $2)
READ ONLY:C145([Finished_Goods_Locations:35])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1)
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"BH@")
	
	If (Count parameters:C259>1)
		QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@")
	End if 
	
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$0:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		$0:=0
	End if 
	
Else 
	
	
	If (Count parameters:C259>1)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	End if 
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1)
	
	$0:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	
	
End if   // END 4D Professional Services : January 2019 query selection
