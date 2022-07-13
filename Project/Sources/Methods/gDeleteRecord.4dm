//%attributes = {"publishedWeb":true}
//gDeleteRecord:

$0:=False:C215

If (fLockNLoad($1))
	BEEP:C151
	uConfirm("Are you sure you want to DELETE this "+Table name:C256($1)+" record!"; "Delete"; "Cancel")
	If (OK=1)
		$0:=True:C214
		app_Log_Usage("log"; "Delete Record"; Table name:C256($1); Table:C252($1); Record number:C243($1->))
		
		DELETE RECORD:C58($1->)
		
		
	End if 
End if 