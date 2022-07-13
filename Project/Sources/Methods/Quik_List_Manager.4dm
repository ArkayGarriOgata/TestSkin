//%attributes = {}
//Method:  Quik_List_Manager
//Description:  This method will manage buttons

OBJECT SET ENABLED:C1123(Quik_nList_Excel; (Quik_tList_QuickKey#CorektBlank))

If (Current user:C182="Designer")
	
	OBJECT SET VISIBLE:C603(Quik_nList_Entry; True:C214)
	
End if 
