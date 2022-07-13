Pjt_setReferId(pjtId)
//$est:=Request("Enter the Color Master Spec to be included in this project:";"00000";"Include";"Cancel")
READ WRITE:C146([Finished_Goods_Color_SpecMaster:128])
QUERY:C277([Finished_Goods_Color_SpecMaster:128])
If (ok=1)
	
	If (Pjt_AddToProjectLimitor(->[Finished_Goods_Color_SpecMaster:128]))
		$oldPjt:=[Finished_Goods_Color_SpecMaster:128]projectId:4
		//[ColorSpecMaster]projectId:=pjtId
		uConfirm("Change "+String:C10(Records in selection:C76([Finished_Goods_Color_SpecMaster:128]))+" records to project number "+pjtId)
		If (ok=1)
			APPLY TO SELECTION:C70([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4:=pjtId)
			FIRST RECORD:C50([Finished_Goods_Color_SpecMaster:128])
			APPLY TO SELECTION:C70([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]custId:3:=pjtCustid)
		End if 
		
		zwStatusMsg("ADD TO PJT"; "Color Master Spec "+[Finished_Goods_Color_SpecMaster:128]id:1+" moved from project "+$oldPjt+" to "+pjtId)
		
	End if 
	
Else 
	zwStatusMsg("ADD TO PJT"; "invalid id")
End if 

QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
ORDER BY:C49([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]name:2; >)

//