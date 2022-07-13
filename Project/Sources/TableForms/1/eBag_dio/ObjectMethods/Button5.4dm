//OM: bShowOL() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"
If (aOutlineNum#0)
	
	If (Shift down:C543)  //Run old way
		
		FG_ArtiosCAD(aOutlineNum{aOutlineNum})  // Modified by: Mel Bohince (7/15/16) 
		
	Else   //Check multiple volumes
		
		FG_ArtiosCADMultiVol(aOutlineNum{aOutlineNum})
		
	End if   //Done run old way
	
Else 
	BEEP:C151
	ALERT:C41("Select an Size&Style File# first.")
End if 
