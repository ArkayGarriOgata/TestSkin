C_TEXT:C284($candidateName)
C_LONGINT:C283($isUnique)

$candidateName:=Substring:C12(fStripSpace("B"; [Raw_Materials:21]Raw_Matl_Code:1); 1; 20)
SET QUERY DESTINATION:C396(Into variable:K19:4; $isUnique)
SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$candidateName)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
SET QUERY LIMIT:C395(0)

If ($isUnique=0)
	[Raw_Materials:21]Raw_Matl_Code:1:=$candidateName
	GOTO OBJECT:C206([Raw_Materials:21]VendorPartNum:3)
	
Else 
	[Raw_Materials:21]Raw_Matl_Code:1:=""
	uConfirm($candidateName+" has already been used."; "Try Again"; "Cancel")
	If (ok=1)
		GOTO OBJECT:C206([Raw_Materials:21]Raw_Matl_Code:1)
	Else 
		CANCEL:C270
	End if 
End if 