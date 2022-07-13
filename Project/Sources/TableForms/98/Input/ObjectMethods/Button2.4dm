//OM: bShowOL() -> 
//@author mlb - 9/18/02  15:04
// Modified by: Garri Ogata (9/21/21) added FG_ArtiosCADMultiVol

If (Length:C16([Finished_Goods_Specifications:98]OutLine_Num:65)#0)
	
	If (Shift down:C543)  //Run old way
		
		FG_ArtiosCAD([Finished_Goods_Specifications:98]OutLine_Num:65)  // Modified by: Mel Bohince (7/15/16) 
		
	Else   //Check multiple volumes
		
		FG_ArtiosCADMultiVol([Finished_Goods_Specifications:98]OutLine_Num:65)
		
	End if   //Done run old way
	
Else 
	BEEP:C151
	ALERT:C41("Enter a Size&Style File# first.")
End if 
