
// Modified by: Garri Ogata (9/21/21) added FG_ArtiosCADMultiVol

zwStatusMsg("Artios Link"; [Customers:16]Name:2+" "+[Finished_Goods:26]Line_Brand:15+"'s "+[Finished_Goods:26]ProductCode:1)

If (Length:C16([Finished_Goods:26]OutLine_Num:4)>2)
	
	If (Shift down:C543)  //Run old way
		
		FG_ArtiosCAD([Finished_Goods:26]OutLine_Num:4)  // Modified by: Mel Bohince (7/15/16) 
		
	Else   //Check multiple volumes
		
		FG_ArtiosCADMultiVol([Finished_Goods:26]OutLine_Num:4)
		
	End if   //Done run old way
	
Else 
	BEEP:C151
	ALERT:C41("Invalid outline number.")
End if 
