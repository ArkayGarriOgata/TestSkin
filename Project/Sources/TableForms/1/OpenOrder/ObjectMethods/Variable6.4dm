If (rInclPlates=1)
	If (rInclPnD=1)
		rInclPnD:=0
		rInclDies:=1
	End if 
	//OBJECT SET ENABLED(rInclPnD;False)
	//Else 
	//OBJECT SET ENABLED(rInclPnD;True)
Else 
	If (rInclDies=1)
		rInclPnD:=1
		rInclDies:=0
	End if 
End if 