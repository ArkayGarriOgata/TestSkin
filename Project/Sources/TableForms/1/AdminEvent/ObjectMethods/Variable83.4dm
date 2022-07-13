//(s) bGenExport [control]adminevent.page'export'
//• 5/30/97 cs created
uSpawnProcess("doExportRecs"; 750000; "Export Records"; True:C214; False:C215)
If (False:C215)
	doExportRecs
End if 

//