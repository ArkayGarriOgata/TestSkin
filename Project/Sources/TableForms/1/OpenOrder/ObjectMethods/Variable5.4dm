If (rInclDies=1)
	If (rInclPnD=1)
		rInclPnD:=0
		rInclPlates:=1
	End if 
	//OBJECT SET ENABLED(rInclPnD;False)
	//Else 
	//OBJECT SET ENABLED(rInclPnD;True)
Else 
	If (rInclPlates=1)
		rInclPnD:=1
		rInclPlates:=0
	End if 
End if 