$findThis:=Request:C163("What Tag (customer or brand)?"; ""; "Find"; "Cancel")
If (ok=1)
	CUT NAMED SELECTION:C334([Tool_Drawers:151]; "doingfind")
	QUERY:C277([Tool_Drawers:151]; [Tool_Drawers:151]Tags:3=("@"+$findThis+"@"))
	If (Records in selection:C76([Tool_Drawers:151])=0)
		BEEP:C151
		uConfirm($findThis+" not found."; "Try Again"; "Help")
		USE NAMED SELECTION:C332("doingfind")
	End if 
	ORDER BY:C49([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1; >)
	SET WINDOW TITLE:C213("Showing Tag "+$findThis)
End if 