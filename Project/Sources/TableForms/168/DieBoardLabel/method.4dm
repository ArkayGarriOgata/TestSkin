C_TEXT:C284(ttUPNum; ttDieInfo)
If (Form event code:C388=On Printing Detail:K2:18)
	ttUPNum:=[Job_DieBoard_Inv:168]OutlineNumber:4+"-"+String:C10([Job_DieBoard_Inv:168]UpNumber:5)
	sPOIcode39:="*"+ttUPNum+"*"
	
	
	
	ttDieInfo:="( "+[Job_DieBoard_Inv:168]CatelogID:10+" ) "+ttUPNum
End if 