//%attributes = {}
// _______
// Method: util_JSON_CreateConfig   ( ) ->
// By: Mel Bohince @ 04/08/21, 09:40:48
// Description
// set up a config file for the util_ZipAndMoveWithDitto_EOS ($paths_o) 
// call on the server
// ----------------------------------------------------
// Modified by: Mel Bohince (6/30/21) add some extra properties
// Modified by: Mel Bohince (7/6/21) add moving the journal file to dbx

C_OBJECT:C1216($paths_o)
C_BOOLEAN:C305($success)

$paths_o:=New object:C1471
$paths_o.from:=Select folder:C670("Select the local folder that holds the aMs backup files")
$paths_o.sent:=Select folder:C670("Select the local folder to keep what was sent")
$paths_o.to:=Select folder:C670("Select the DropBox folder to receive backup")
$paths_o.journalOriginal:=Select folder:C670("Select the location where journal is saved")
$paths_o.journalDropbox:=Select folder:C670("Select the DropBox folder to receive the journal file")
$paths_o.expectedSize:=500*1000000  //Mb
$paths_o.delayInMinutes:=5  //minutes
$paths_o.ignore:="backupHistory.json"  // could be a collection

$success:=util_JSON_ObjToResourceFolder($paths_o; "config_archive")  //set up config file, needs to be set in the server's Resource folder

If ($success)  //display what was saved
	$paths_o:=util_JSON_ObjFromResourceFolder("config_archive")  //back test, this would normally be all that is needed for a run on the server
	ALERT:C41(Get 4D folder:C485(Current resources folder:K5:16)+":\r\r"+JSON Stringify:C1217($paths_o; *))
	
Else 
	ALERT:C41("Problem saving "+"config_archive.json")
End if 

