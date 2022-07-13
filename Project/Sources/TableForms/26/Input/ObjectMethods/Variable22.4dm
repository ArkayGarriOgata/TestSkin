$hold_window_title:=Get window title:C450
xNotes:=[Finished_Goods:26]Notes:20
$winRef:=OpenSheetWindow(->[Finished_Goods:26]; "Notesdialog")
DIALOG:C40([Finished_Goods:26]; "Notesdialog")

If (ok=1) & (iMode<3)
	[Finished_Goods:26]Notes:20:=xNotes
End if 
CLOSE WINDOW:C154
SET WINDOW TITLE:C213($hold_window_title)
