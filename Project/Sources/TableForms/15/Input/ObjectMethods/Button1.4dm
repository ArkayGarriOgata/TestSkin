xNotes:=[Jobs:15]ChangeLog:19
wWindowTitle("push"; "Job "+String:C10([Jobs:15]JobNo:1)+"'s Change Log")
OpenSheetWindow(->[Finished_Goods:26]; "Notesdialog")
DIALOG:C40([Finished_Goods:26]; "Notesdialog")
CLOSE WINDOW:C154
If (ok=1)
	[Jobs:15]ChangeLog:19:=xNotes
End if 
wWindowTitle("pop")