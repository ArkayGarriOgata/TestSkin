//%attributes = {}
//Method:  Help_View_HList
//Description:  This method is executed when someone click on the HList

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bExpanded)
	
	C_LONGINT:C283($nItemReference; $nSubListReference)
	
	C_OBJECT:C1216($oView)
	
	C_POINTER:C301($patHListKey)
	
	C_TEXT:C284($tHelp_Key; $tItem; $tViewHelp_Key)
	
	$oView:=New object:C1471()
	
End if   //Done initialize

Case of   //Folder or item
		
	: (Core_HList_IsFolderB(->CorenHList1))  //Folder
		
		Help_View_Initialize(CorektPhaseInitialize)
		
	Else   //Item
		
		Help_View_Initialize(CorektPhaseAssignVariable)
		
		If ((Current user:C182="Designer") & (Form event code:C388=On Double Clicked:K2:5))  //Can edit
			
			GET LIST ITEM:C378(CorenHList1; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)  // grab everything in the list
			
			$patHListKey:=Get pointer:C304("CoreatHListKey1")
			
			$tHelp_Key:=$patHListKey->{$nItemReference}
			
			$oView.tViewHelpKey:=$tHelp_Key
			
			Help_Dialog_Entr($oView)
			
		End if   //Done can edit
		
End case   //Done folder or item