uConfirm("Remember to put it back!"; "Mark as Out"; "Cancel")
If (ok=1)
	Form:C1466.ent.Bin:=Form:C1466.ent.Bin+" - OUT"
End if 