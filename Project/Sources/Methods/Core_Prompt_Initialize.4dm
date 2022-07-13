//%attributes = {}
//Method:  Core_Prompt_Initialize(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Core_Prompt_Initialize(CorektPhaseClear)
		
		Form:C1466.gIcon:=Core_Picture_LoadG(Form:C1466.tIcon)
		
		//Need to do this because Carriage returns with Form.tValuewithCarriageReturns just displays /R
		Core_tPrompt_Message:=OB Get:C1224(Form:C1466; "tMessage"; Is text:K8:3)
		
		OBJECT SET VISIBLE:C603(Core_nPrompt_PopUp; False:C215)
		
		If (OB Is defined:C1231(Form:C1466; "tPopUp"))  //Popup
			
			OBJECT SET VISIBLE:C603(Core_nPrompt_PopUp; True:C214)
			
			OBJECT GET COORDINATES:C663(*; "Core_tPrompt_Hint"; $nLeft; $nTop; $nRight; $nBottom)
			
			OBJECT SET COORDINATES:C1248(*; "Core_tPrompt_Hint"; $nLeft+13; $nTop; $nRight; $nBottom)
			
		End if   //Done popup
		
		Core_Window_FitObject
		
		Core_Prompt_ButtonManager
		
	: ($tPhase=CorektPhaseClear)
		
		Core_tPrompt_Message:=CorektBlank
		Core_tPrompt_Hint:=CorektBlank
		
		Core_nPrompt_PopUp:=0
		
		Core_nPrompt_Default:=0
		Core_nPrompt_NonDefault:=0
		Core_nPrompt_Cancel:=0
		
End case   //Done phase