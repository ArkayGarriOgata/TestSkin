CUT NAMED SELECTION:C334([Tool_Drawers:151]; "doingfind")
$findThis:=Request:C163("Find what?"; ""; "Find"; "Cancel")
If (ok=1)
	QUERY:C277([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1=$findThis)
	If (Records in selection:C76([Tool_Drawers:151])=0)
		
		QUERY:C277([Tool_Drawers:151]; [Tool_Drawers:151]Contents:2=("@"+$findThis+"@"))
		If (Records in selection:C76([Tool_Drawers:151])=0)
			
			QUERY:C277([Tool_Drawers:151]; [Tool_Drawers:151]Tags:3=("@"+$findThis+"@"))
			If (Records in selection:C76([Tool_Drawers:151])=0)
				uConfirm("Not found."; "Query"; "Cancel")
				If (ok=1)
					QUERY:C277([Tool_Drawers:151])
				Else 
					USE NAMED SELECTION:C332("doingfind")
				End if 
				
			End if 
			
			
		End if 
		
	End if 
	
Else 
	USE NAMED SELECTION:C332("doingfind")
End if 
