//(s) bGetRm - [operational seq]input 

If (Records in set:C195("clickedMaterial")=1)
	CUT NAMED SELECTION:C334([Estimates_Materials:29]; "holdWhilePick")
	USE SET:C118("clickedMaterial")
	sGetRmList(->[Estimates_Materials:29]Commodity_Key:6; ->[Estimates_Materials:29]Raw_Matl_Code:4; ->[Estimates_Materials:29]Sequence:12)
	If (Length:C16([Estimates_Materials:29]Raw_Matl_Code:4)>0)
		SAVE RECORD:C53([Estimates_Materials:29])
	End if 
	USE NAMED SELECTION:C332("holdWhilePick")
	CLEAR SET:C117("clickedMaterial")
	
Else 
	uConfirm("Select one Material below first."; "OK"; "Help")
End if 