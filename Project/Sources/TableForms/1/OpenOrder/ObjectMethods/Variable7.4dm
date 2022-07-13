If (rInclPnD=1)
	rInclPlates:=0
	rInclDies:=0
	OBJECT SET ENABLED:C1123(rInclPlates; True:C214)
	OBJECT SET ENABLED:C1123(rInclDies; True:C214)
Else 
	rInclPlates:=1
	rInclDies:=1
	OBJECT SET ENABLED:C1123(rInclDies; False:C215)
	OBJECT SET ENABLED:C1123(rInclPlates; False:C215)
End if 
//