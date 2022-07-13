//%attributes = {"publishedWeb":true}
//(P) uConfirm
//$1 - text string to disaplay
//$2,$3 accept/Cancel button text (optional)
// Modified by: Mel Bohince (6/9/21) problem encountered when sheetwindow opens while incluced form is drawing

C_TEXT:C284(MyText; $1)
C_TEXT:C284($2; $3)

If (Count parameters:C259>=1)
	MyText:=$1
Else 
	MyText:="Confirm or deny?"
End if 

If (Count parameters:C259>=2)
	sOKText:=$2
Else 
	sOKText:="Yes"
End if 

If (Count parameters:C259=3)
	sCancelText:=$3
Else 
	sCancelText:="No"
End if 

BEEP:C151


If (Not:C34(<>v18_PROBLEM))
	//OK:=Core_Dialog_PromptN (New object("tMessage";MyText;"tDefault";sOKText;"tCancel";sCancelText))
	CONFIRM:C162(MyText; sOKText; sCancelText)
	
Else 
	$winRef:=OpenSheetWindow(->[zz_control:1]; "Confirm")
	DIALOG:C40([zz_control:1]; "Confirm")
	CLOSE WINDOW:C154
End if 

If (sCancelText="Help") & (ok=0)
	//If (filePtr#<>NIL)
	//helpContext:=Table name(filePtr)
	//Else 
	//helpContext:="???"
	//End if 
	BEEP:C151
	//ALERT("Sorry, help is not available yet. ["+helpContext+"]")
	ALERT:C41("Sorry, help is not available here.")  // Modified by: Mel Bohince (7/16/21) 
	
End if 

$0:=OK