//(s) bGenimport [control]adminevent.page'export'
//• 5/30/97 cs created
uSpawnProcess("doImportRecs"; 500000; "Import Records"; True:C214; False:C215)
If (False:C215)
	doImportRecs
End if 

//