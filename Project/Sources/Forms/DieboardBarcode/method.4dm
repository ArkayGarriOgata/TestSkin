
If (Form event code:C388=On Printing Detail:K2:18)
	sPOIcode39:="*"+[Job_DieBoard_Inv:168]OutlineNumber:4+"-"+String:C10([Job_DieBoard_Inv:168]UpNumber:5)+"*"
	
End if 