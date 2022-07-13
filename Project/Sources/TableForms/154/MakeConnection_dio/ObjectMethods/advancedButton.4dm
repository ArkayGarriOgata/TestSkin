ARRAY TEXT:C222($aVolumes; 0)
ARRAY TEXT:C222($aDocuments; 0)

VOLUME LIST:C471($aVolumes)
$hit:=Find in array:C230($aVolumes; "van-ftp.nubridges.net")
If ($hit>-1)
	$path:=$aVolumes{$hit}+<>DELIMITOR+"outbox"
	DOCUMENT LIST:C474($path; $aDocuments; Absolute path:K24:14+Ignore invisible:K24:16)
	$numMail:=Size of array:C274($aDocuments)
	If ($numMail>0)
		
		CONFIRM:C162("Attempt to delete the "+String:C10($numMail)+" documents in van-ftp.nubridges.net?"; "Delete"; "Cancel")
		If (ok=1)
			For ($i; 1; $numMail)
				$filename:=$aDocuments{$i}
				util_deleteDocument($fileName)
			End for 
		End if 
		
	Else 
		ALERT:C41("Nothing in volume:"+"van-ftp.nubridges.net")
	End if 
	
Else 
	ALERT:C41("Couldn't find volume:"+"van-ftp.nubridges.net")
End if 
