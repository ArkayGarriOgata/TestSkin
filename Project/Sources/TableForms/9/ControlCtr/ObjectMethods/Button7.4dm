Pjt_setReferId(pjtId)
$est:=Request:C163("Enter the Control Nº to be included in this project:"; "C654321"; "Include"; "Cancel")
READ WRITE:C146([Finished_Goods_Specifications:98])
QUERY:C277([Finished_Goods_Specifications:98])
If (OK=1)
	$numRecs:=Records in selection:C76([Finished_Goods_Specifications:98])
	If (Pjt_AddToProjectLimitor(->[Finished_Goods_Specifications:98]))
		uConfirm("Change "+String:C10($numRecs)+" [Finished_Goods_Specifications] records to project number "+pjtId+"?")
		If (OK=1)
			For ($i; 1; $numRecs)
				$oldPjt:=[Finished_Goods_Specifications:98]ProjectNumber:4
				[Finished_Goods_Specifications:98]ProjectNumber:4:=pjtId
				If (Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)#pjtCustid)
					[Finished_Goods_Specifications:98]FG_Key:1:=pjtCustid+Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 6)
				End if 
				SAVE RECORD:C53([Finished_Goods_Specifications:98])
				zwStatusMsg("ADD TO PJT"; "Control Nº "+[Finished_Goods_Specifications:98]ControlNumber:2+" moved from project "+$oldPjt+" to "+pjtId)
			End for 
		End if 
		
	Else 
		uConfirm("No [Finished_Goods_Specifications] were found with your criterion.")
	End if 
End if 

READ ONLY:C145([Finished_Goods_Specifications:98])
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProjectNumber:4=pjtId)
ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1; >; [Finished_Goods_Specifications:98]ControlNumber:2; <)