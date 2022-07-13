//%attributes = {}
// _______
// Method: util_JSON_CreateConfig2   ( ) ->
// By: Mel Bohince @ 07/13/21, 12:34:43
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($paths_o)
C_BOOLEAN:C305($success)

$paths_o:=New object:C1471
$paths_o.backupOriginals:=Select folder:C670("Select the local folder that holds the aMs backup files")
$paths_o.backupMirrors:=Select folder:C670("Select the local folder to Mirrors")
$paths_o.dropBoxArchive:=Select folder:C670("Select the DropBox folder to receive backup")

$paths_o.expectedSize:=500*1000000  //Mb
$paths_o.ignore:="backupHistory.json"  // could be a collection

$success:=util_JSON_ObjToResourceFolder($paths_o; "config_Backup")  //set up config file, needs to be set in the server's Resource folder

If ($success)  //display what was saved
	$paths_o:=util_JSON_ObjFromResourceFolder("config_Backup")  //back test, this would normally be all that is needed for a run on the server
	ALERT:C41(Get 4D folder:C485(Current resources folder:K5:16)+":\r\r"+JSON Stringify:C1217($paths_o; *))
	
Else 
	ALERT:C41("Problem saving "+"config_archive.json")
End if 

