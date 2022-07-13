//%attributes = {}
// -------
// Method: FG_getStock   ( ) ->
// By: Mel Bohince @ 04/21/18, 09:40:05
// Description
// 
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_Specifications:98])

QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1="@"+$1)

If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
	SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]DatePrepDone:6; $aDate; [Finished_Goods_Specifications:98]StockCaliper:23; $aCaliper; [Finished_Goods_Specifications:98]StockType:21; $aType; [Finished_Goods_Specifications:98]StockColor:22; $aColor)
	SORT ARRAY:C229($aDate; $aCaliper; $aType; $aColor; <)
	$0:=String:C10((1000*$aCaliper{1}))+"-"+$aType{1}+" "+$aColor{1}
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Finished_Goods_Specifications:98])
		
	Else 
		
		// you have read only with selection to array
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	$0:="n/f"
End if 
