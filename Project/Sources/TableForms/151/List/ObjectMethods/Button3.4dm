$jobform:=Request:C163("Enter jobform: "; ""; "Find"; "Cancel")
If (ok=1)
	CUT NAMED SELECTION:C334([Tool_Drawers:151]; "doingfind")
	READ ONLY:C145([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPNs)
		QUERY:C277([Tool_Drawers:151]; [Tool_Drawers:151]Contents:2=("@"+$aCPNs{1}+"@"); *)
		For ($i; 2; Size of array:C274($aCPNs))
			QUERY:C277([Tool_Drawers:151];  | ; [Tool_Drawers:151]Contents:2=("@"+$aCPNs{$i}+"@"); *)
		End for 
		QUERY:C277([Tool_Drawers:151])
		
	Else 
		BEEP:C151
		uConfirm($jobform+" not found."; "Try again"; "Help")
		USE NAMED SELECTION:C332("doingfind")
	End if 
	ORDER BY:C49([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1; >)
	SET WINDOW TITLE:C213("Showing Job "+$jobform)
End if 