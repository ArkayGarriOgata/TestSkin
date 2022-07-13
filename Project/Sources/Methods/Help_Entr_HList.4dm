//%attributes = {}
//Method:  Help_Entr_HList
//Description:  This method is executed when someone click on the HList

Case of   //Folder or item
		
	: (Core_HList_IsFolderB(->CorenHList99))  //Folder
		
		Help_Entr_Initialize(Current method name:C684)
		
	Else   //Item
		
		Help_Entr_Initialize(CorektPhaseAssignVariable)
		
End case   //Done folder or item