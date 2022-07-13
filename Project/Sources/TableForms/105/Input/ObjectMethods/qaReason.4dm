//OM: Reason() -> 
//@author mlb - 7/18/01  15:01
$hyfAt:=Position:C15("-"; [QA_Corrective_Actions:105]Reason:16)
$category:=Substring:C12([QA_Corrective_Actions:105]Reason:16; 1; $hyfAt-1)
$reason:=Substring:C12([QA_Corrective_Actions:105]Reason:16; $hyfAt+1)
If (Length:C16($category)>0) & (Length:C16($reason)>0) & ($hyfAt>0)
	QUERY:C277([QA_Corrective_ActionsReason:106]; [QA_Corrective_ActionsReason:106]Category:2=$category; *)
	QUERY:C277([QA_Corrective_ActionsReason:106];  & ; [QA_Corrective_ActionsReason:106]Reason:3=$reason)
	If (Records in selection:C76([QA_Corrective_ActionsReason:106])#1)
		BEEP:C151
		CONFIRM:C162("Create a new [CorrectiveActionReason] with"+Char:C90(13)+"Category= "+$category+Char:C90(13)+"Reason= "+$reason; "Create"; "Try Again")
		If (ok=1)
			CREATE RECORD:C68([QA_Corrective_ActionsReason:106])
			[QA_Corrective_ActionsReason:106]id:1:=String:C10(app_AutoIncrement(->[QA_Corrective_ActionsReason:106]); "00000")
			[QA_Corrective_ActionsReason:106]Category:2:=$category
			[QA_Corrective_ActionsReason:106]Reason:3:=$reason
			SAVE RECORD:C53([QA_Corrective_ActionsReason:106])
			UNLOAD RECORD:C212([QA_Corrective_ActionsReason:106])
		Else 
			[QA_Corrective_Actions:105]Reason:16:=""
			GOTO OBJECT:C206([QA_Corrective_Actions:105]Reason:16)
		End if 
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Enter a category and reason separated by a hyphen like"+Char:C90(13)+"Printing-Color variations")
	[QA_Corrective_Actions:105]Reason:16:=""
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Reason:16)
End if 