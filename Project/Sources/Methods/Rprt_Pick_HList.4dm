//%attributes = {}
//Method:  Rprt_Pick_HList
//Description:  This method will 

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=FORM Event:C1606.code
	
End if   //Done initialize

Case of   //Folder or item
		
	: (Core_HList_IsFolderB(->CorenHList1))  //Folder
		
		Rprt_Pick_Initialize(CorektPhaseClear)
		
		Rprt_Pick_Manager(CorektPhaseInitialize)
		
	Else   //Item
		
		Rprt_Pick_Initialize(CorektPhaseAssignVariable)
		
		If ((Current user:C182="Designer") & ($nFormEvent=On Double Clicked:K2:5))  //Can edit
			
			Rprt_Dialog_Entry(Form:C1466.tReport_Key)
			
			Rprt_Pick_Initialize(CorektPhaseInitialize)
			
		End if   //Done can edit
		
End case   //Done folder or item