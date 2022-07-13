//%attributes = {"publishedWeb":true}
//PM: util_deleteDocument(doc) -> 
//@author Add Komoncharoensiri 5/24/2002

C_BOOLEAN:C305($Locked; $inv)
C_DATE:C307($createdon; $modon)
C_TIME:C306($createdat; $modat)
//utl_Logfile ("BatchRunner.Log";"Deleting-->"+$1)
If (Test path name:C476($1)>0)
	GET DOCUMENT PROPERTIES:C477($1; $Locked; $inv; $createdon; $createdat; $modon; $modat)
	If ($Locked)
		utl_Logfile("BatchRunner.Log"; "File Locked-->"+$1)
		SET DOCUMENT PROPERTIES:C478($1; False:C215; $inv; $createdon; $createdat; $modon; $modat)
	End if 
	DELETE DOCUMENT:C159($1)
End if 
//