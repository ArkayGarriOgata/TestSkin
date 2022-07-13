xNotes:=[Finished_Goods:26]Notes:20
$winRef:=Open form window:C675([Finished_Goods:26]; "Notesdialog")
DIALOG:C40([Finished_Goods:26]; "Notesdialog")
CLOSE WINDOW:C154($winRef)
If (ok=1)
	[Finished_Goods:26]Notes:20:=xNotes
End if 