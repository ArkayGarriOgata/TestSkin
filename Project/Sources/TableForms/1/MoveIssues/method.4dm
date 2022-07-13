//(lop) [control]MoveIssues
Case of 
	: (Form event code:C388=On Load:K2:1)
		READ WRITE:C146([Raw_Materials_Transactions:23])
		RM_MoveIssues("*")
End case 
//