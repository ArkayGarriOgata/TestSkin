//%attributes = {}
//Method: Core_Prompt_ButtonOrder(tCancel;tNonDefault)
//Description: This method sets the buttons in different locations based on 
//.  Operating System. All buttons are set by default for MacOS and then changed
//.  if its for windows. It also handles hiding value and moving the buttons
//.  if value is hidden

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCancel)
	C_TEXT:C284($2; $tNonDefault)
	
	C_BOOLEAN:C305($bVisible)
	
	C_LONGINT:C283($nDefaultLeft; $nDefaultTop; $nDefaultRight; $nDefaultBottom)
	C_LONGINT:C283($nCancelLeft; $nCancelTop; $nCancelRight; $nCancelBottom)
	C_LONGINT:C283($nNonDefaultLeft; $nNonDefaultTop; $nNonDefaultRight; $nNonDefaultBottom)
	
	C_LONGINT:C283($nValueLeft; $nValueTop; $nValueRight; $nValueBottom)
	
	C_LONGINT:C283($nWindowLeft; $nWindowTop; $nWindowRight; $nWindowBottom)
	
	C_LONGINT:C283($nTop; $nBottom)
	
	$tCancel:=$1
	$tNonDefault:=$2
	
	OBJECT GET COORDINATES:C663(Core_nPrompt_Default; $nDefaultLeft; $nDefaultTop; $nDefaultRight; $nDefaultBottom)
	OBJECT GET COORDINATES:C663(Core_nPrompt_Cancel; $nCancelLeft; $nCancelTop; $nCancelRight; $nCancelBottom)
	OBJECT GET COORDINATES:C663(Core_nPrompt_NonDefault; $nNonDefaultLeft; $nNonDefaultTop; $nNonDefaultRight; $nNonDefaultBottom)
	
	OBJECT GET COORDINATES:C663(*; "Form.tValue"; $nValueLeft; $nValueTop; $nValueRight; $nValueBottom)
	
	GET WINDOW RECT:C443($nWindowLeft; $nWindowTop; $nWindowRight; $nWindowBottom)
	
	$nTop:=$nDefaultTop
	$nBottom:=$nDefaultBottom
	
End if   //Done Initialize

If (Form:C1466.tPromptType#CorektRequest)  //Hide value
	
	OBJECT SET VISIBLE:C603(*; "Form.tValue"; False:C215)
	
	$nYOffSet:=($nValueTop-$nDefaultTop)
	
	$nTop:=$nDefaultTop+$nYOffSet
	$nBottom:=$nDefaultBottom+$nYOffSet
	
	SET WINDOW RECT:C444($nWindowLeft; $nWindowTop; $nWindowRight; $nWindowBottom+$nYOffSet)
	
Else   //Format value
	
	Core_Prompt_EntrySetting
	
End if   //Done hide value

Case of   //Button order based on OS
		
	: (Is Windows:C1573)
		
		OBJECT SET COORDINATES:C1248(Core_nPrompt_Cancel; $nDefaultLeft; $nTop; $nDefaultRight; $nBottom)  //Cancel move to default
		
		If ($tNonDefault#CorektBlank)  //Nondefault is used
			
			OBJECT SET COORDINATES:C1248(Core_nPrompt_Default; $nNonDefaultLeft; $nTop; $nNonDefaultRight; $nBottom)  //Default move to nondefault
			OBJECT SET COORDINATES:C1248(Core_nPrompt_NonDefault; $nCancelLeft; $nTop; $nCancelRight; $nBottom)  //Nondefault move to cancel
			
		Else   //Nondefault is blank and will be hidden
			
			OBJECT SET COORDINATES:C1248(Core_nPrompt_Default; $nCancelLeft; $nTop; $nCancelRight; $nBottom)  //Default move to cancel
			
		End if   //Done nondefault is used
		
	: (Is macOS:C1572)
		
		OBJECT SET COORDINATES:C1248(Core_nPrompt_Default; $nDefaultLeft; $nTop; $nDefaultRight; $nBottom)
		
		If ($tNonDefault#CorektBlank)  //Nondefault is used
			
			OBJECT SET COORDINATES:C1248(Core_nPrompt_NonDefault; $nCancelLeft; $nTop; $nCancelRight; $nBottom)  //Move nondefault to cancel
			OBJECT SET COORDINATES:C1248(Core_nPrompt_Cancel; $nNonDefaultLeft; $nTop; $nNonDefaultRight; $nBottom)  //Move cancel to nondefault
			
		Else 
			
			OBJECT SET COORDINATES:C1248(Core_nPrompt_NonDefault; $nNonDefaultLeft; $nTop; $nNonDefaultRight; $nBottom)
			OBJECT SET COORDINATES:C1248(Core_nPrompt_Cancel; $nCancelLeft; $nTop; $nCancelRight; $nBottom)
			
		End if   //Done nondefault is used
		
End case   //Done Button order based on OS

$bVisible:=Choose:C955(($tNonDefault=CorektBlank); False:C215; True:C214)  //Nondefault
OBJECT SET VISIBLE:C603(Core_nPrompt_NonDefault; $bVisible)

$bVisible:=Choose:C955(($tCancel=CorektBlank); False:C215; True:C214)  //Cancel
OBJECT SET VISIBLE:C603(Core_nPrompt_Cancel; $bVisible)

