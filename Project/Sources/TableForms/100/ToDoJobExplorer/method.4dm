//FM: ToDoJobExplorer() -> 
//@author mlb - 5/10/02  11:02

Case of 
	: (Form event code:C388=On Load:K2:1)
		ToDo_viaJob
		ToDo_viaPjt
		ToDo_viaUserLogin
		
	: (Form event code:C388=On Outside Call:K2:11)
		ToDo_viaJob
		ToDo_viaPjt
		ToDo_viaUserLogin
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270  //wCloseHide 
End case 