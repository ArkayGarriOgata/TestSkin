//bGantt 12/13/01 Systems G4

If (aGlueListBox>0)
	<>jobform:=Substring:C12(aJobit{aGlueListBox}; 1; 8)
	If (Length:C16(<>jobform)=8)
		PS_showScheduleForJob(<>jobform)
	End if 
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 