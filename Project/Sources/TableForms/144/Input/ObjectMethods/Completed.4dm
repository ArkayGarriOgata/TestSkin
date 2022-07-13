If (Self:C308->=True:C214)
	[QA_Corrective_Actions_ToDos:144]DateDone:6:=4D_Current_date
	[QA_Corrective_Actions_ToDos:144]CompletedAuthor:7:=<>zResp
Else 
	[QA_Corrective_Actions_ToDos:144]DateDone:6:=!00-00-00!
	[QA_Corrective_Actions_ToDos:144]CompletedAuthor:7:=""
End if 

