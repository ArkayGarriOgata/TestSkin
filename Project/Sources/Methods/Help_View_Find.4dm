//%attributes = {}
//Method:  Help_View_Find
//Description:  This method handles the find for the select form
//  The only event for this object is on after keystroke

If (True:C214)  // Intialization
	
	C_TEXT:C284($tFind)
	
End if   // Done initialization

$tFind:=Get edited text:C655

Case of   // Find
		
	: (Form event code:C388=-1)
		
		C_TEXT:C284(Help_View_tFind)
		SearchPicker SET HELP TEXT("Help_View_tFind"; "Find in help")  //widget that 4d uses to sets text for search bar
		
	: ($tFind=CorektBlank)
	: (Length:C16($tFind)<4)
		
	Else 
		
		Form:C1466.tKeyword:=$tFind
		
		OB REMOVE:C1226(Form:C1466; "tHelp_Key")
		
		Help_View_Initialize(CorektPhaseInitialize)
		
End case   // Done find