//%attributes = {"publishedWeb":true}
//prPI2Front

If (User in group:C338(Current user:C182; "Physical Inv"))
	If (<>PIProcess#0)
		BRING TO FRONT:C326(<>PIProcess)
	Else 
		StartPhyInv
	End if 
	
Else 
	uNotAuthorized
End if 