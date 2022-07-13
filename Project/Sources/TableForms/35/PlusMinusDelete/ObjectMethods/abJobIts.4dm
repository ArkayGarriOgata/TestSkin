// ----------------------------------------------------
// Method: [Finished_Goods_Locations].PlusMinusDelete.abJobIts   ( ) ->
// By: Mel Bohince @ 04/06/16, 13:27:11
// Description
// 
// ----------------------------------------------------



If (abDelete{abJobits})
	abDelete{abJobits}:=False:C215
Else 
	abDelete{abJobits}:=True:C214
End if 

If (Count in array:C907(abDelete; True:C214)>0)
	OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
Else 
	OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
End if 