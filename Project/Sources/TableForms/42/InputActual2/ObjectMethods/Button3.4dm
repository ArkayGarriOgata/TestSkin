xNotes:=[Job_Forms:42]Notes:32
wWindowTitle("push"; "Job Form "+[Job_Forms:42]JobFormID:5+"'s Job Bag Notes")
OpenSheetWindow(->[Finished_Goods:26]; "Notesdialog")
DIALOG:C40([Finished_Goods:26]; "Notesdialog")
CLOSE WINDOW:C154
If (ok=1)
	[Job_Forms:42]Notes:32:=xNotes
End if 
wWindowTitle("pop")