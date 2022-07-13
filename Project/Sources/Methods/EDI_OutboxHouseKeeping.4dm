//%attributes = {}
// _______
// Method: EDI_OutboxHouseKeeping   ( ) ->
// By: MelvinBohince @ 03/31/22, 13:51:48
// Description
// move files from the EDI_Outbox to the EDI_Archive folder
// see [zz_control].EDIevent   ( ) for the creation of the folders
// which happens when EDI palette is opened
// this method should be evoked before a Connect "Local Disk" is run
// ----------------------------------------------------

C_OBJECT:C1216($outboxFolder_o; $status_o; $archiveFolder_o; $file_o)

//these paths should already be created by the palette's onload
$path:=util_DocumentPath("get")  //this should be ~/Documents/AMS_Documents
If (Length:C16(<>outboxFolderPath)=0) | (True:C214)
	<>outboxFolderPath:=$path+"EDI_Outbox"+<>DELIMITOR
End if 

If (Length:C16(<>tempFolderPath)=0)
	<>tempFolderPath:=$path+"EDI_Archive"+<>DELIMITOR
End if 

//Make sure subject folders exist
$outboxFolder_o:=Folder:C1567(Convert path system to POSIX:C1106(<>outboxFolderPath))
If (Not:C34($outboxFolder_o.exists))
	$outboxFolder_o.create()
End if 

$archiveFolder_o:=Folder:C1567(Convert path system to POSIX:C1106(<>tempFolderPath))
If (Not:C34($archiveFolder_o.exists))
	$archiveFolder_o.create()
End if 

//get the contents of the outbox folder
C_COLLECTION:C1488($outboxContent_c)
$outboxContent_c:=$outboxFolder_o.files(fk ignore invisible:K87:22)

If ($outboxContent_c.length>0)  //Move any documents in the EDI_Outbox to the EDI_Archive
	
	For each ($file_o; $outboxContent_c)
		$status_o:=$file_o.moveTo($archiveFolder_o)
	End for each 
	
End if 
