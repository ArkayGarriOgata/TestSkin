//(s) bGetRm - [operational seq]input 

If (Records in set:C195("clickedMaterial")=1)
	CUT NAMED SELECTION:C334([Process_Specs_Materials:56]; "holdWhilePick")
	USE SET:C118("clickedMaterial")
	sGetRmList(->[Process_Specs_Materials:56]Commodity_Key:8; ->[Process_Specs_Materials:56]Raw_Matl_Code:13; ->[Process_Specs_Materials:56]Sequence:4)
	If (Length:C16([Process_Specs_Materials:56]Raw_Matl_Code:13)>0)
		SAVE RECORD:C53([Process_Specs_Materials:56])
	End if 
	USE NAMED SELECTION:C332("holdWhilePick")
	CLEAR SET:C117("clickedMaterial")
	
Else 
	uConfirm("Select one Material below first."; "OK"; "Help")
End if 