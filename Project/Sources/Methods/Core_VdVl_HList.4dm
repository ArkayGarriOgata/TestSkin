//%attributes = {}
//Method:  Core_VdVl_HList
//Description:  This method will 

Case of   //Folder or item
		
	: (Core_HList_IsFolderB(->CorenHList1))  //Folder
		
		Core_VdVl_Initialize(CorektPhaseClear)
		
		Core_VdVl_Manager(Current method name:C684)
		
	Else   //Item
		
		Core_VdVl_Initialize(CorektPhaseAssignVariable)
		
End case   //Done folder or item