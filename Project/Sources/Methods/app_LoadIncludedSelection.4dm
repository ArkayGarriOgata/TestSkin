//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/29/06, 15:58:36
// ----------------------------------------------------
// Method: app_LoadIncludedSelection("msg"{;->field}) -> longint
// ----------------------------------------------------

C_LONGINT:C283($0)  // positive success, negative failure
C_TEXT:C284($1)
C_POINTER:C301($2)
C_TEXT:C284($selectionSetName)
C_TEXT:C284($3)

If (Count parameters:C259>=3)
	$selectionSetName:="clickedIncludeRecord"+$3
Else 
	$selectionSetName:="clickedIncludeRecord"
End if 

Case of 
	: ($1="init")
		$fieldPtr:=$2
		$tablePtr:=Table:C252(Table:C252($fieldPtr))
		If (Records in set:C195($selectionSetName)>0)
			CUT NAMED SELECTION:C334($tablePtr->; "beforeSubselection")
			USE SET:C118($selectionSetName)
			$0:=Records in selection:C76($tablePtr->)
			
		Else 
			uConfirm("Select something first."; "OK"; "Help")
			$0:=-1
		End if 
		
	: ($1="clear")
		$fieldPtr:=$2
		$tablePtr:=Table:C252(Table:C252($fieldPtr))
		//CLEAR SET("clickedIncludeRecord")
		USE NAMED SELECTION:C332("beforeSubselection")
		HIGHLIGHT RECORDS:C656($tablePtr->; $selectionSetName)
		$0:=Records in selection:C76($tablePtr->)
		
	: ($1="loaded")
		$0:=Records in set:C195($selectionSetName)
End case 