uConfirm("Are you sure you want to remove the contents of the bin and clear the tags?"; "Empty"; "Cancel")
If (ok=1)
	Form:C1466.ent.Contents:="AVAILABLE"
	Form:C1466.ent.Tags:=""
End if 