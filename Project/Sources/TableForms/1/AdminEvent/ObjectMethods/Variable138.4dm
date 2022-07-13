//Script: bChgCoord()  051596  MLB
//replace initials in the WhoseContact subfile
C_LONGINT:C283($i; $contacts)
C_TEXT:C284($oldInits; $newInits)
$oldInits:=Substring:C12(Request:C163("What are the OLD initials:"; "OLD"); 1; 4)
If (ok=1)
	QUERY:C277([Contacts_Tags:183]; [Contacts_Tags:183]UserID:1=$oldInits)
	$contacts:=Records in selection:C76([Contacts_Tags:183])
	If ($contacts>0)
		$newInits:=Substring:C12(Request:C163("What are the NEW initials:"; "NEW"); 1; 4)
		If (ok=1)
			CONFIRM:C162("Are you sure you want to change "+$oldInits+" to "+$newInits)
			If (ok=1)
				APPLY TO SELECTION:C70([Contacts_Tags:183]; [Contacts_Tags:183]UserID:1:=$newInits)
			End if   //confirmed   
		End if   //ok new inits
	Else 
		BEEP:C151
		ALERT:C41("No contacts have "+$oldInits+" marking them.")
	End if   //no contacts    
End if   //ok=1  
//