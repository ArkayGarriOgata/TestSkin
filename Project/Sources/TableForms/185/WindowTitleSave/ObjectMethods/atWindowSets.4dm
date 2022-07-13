<>tWindowSetName:=atWindowSets{bWindowNames}

If (Find in array:C230(bWindowNames; True:C214)>0)
	OBJECT SET ENABLED:C1123(bRemove; True:C214)
	OBJECT SET ENABLED:C1123(bOK; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bRemove; False:C215)
	OBJECT SET ENABLED:C1123(bOK; False:C215)
End if 