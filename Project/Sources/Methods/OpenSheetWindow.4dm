//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/12/06, 15:18:48
// ----------------------------------------------------
// Method: winRef:= OpenSheetWindow(->file;"form";"windowtitle")
// ----------------------------------------------------

C_POINTER:C301($1)
C_TEXT:C284($form; $2; $3)
C_LONGINT:C283($0)

If (Length:C16($2)>0)
	$form:=$2
Else 
	$form:="Input"
End if 
If (Count parameters:C259=3)
	SET WINDOW TITLE:C213($3)
End if 

$0:=Open form window:C675($1->; $form; Sheet form window:K39:12)