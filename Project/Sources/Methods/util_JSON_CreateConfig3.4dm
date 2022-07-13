//%attributes = {}
// _______
// Method: util_JSON_CreateConfig3   ( ) ->
// By: Mel Bohince @ 07/13/21, 12:34:43
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($paths_o)
C_BOOLEAN:C305($success)

$paths_o:=New object:C1471
$paths_o.journalOriginal:=Select folder:C670("Select the local folder that holds the aMs .journal file")
$paths_o.journalMirror:=Select folder:C670("Select the local folder for a mirrors journal")
$paths_o.journalArchive:=Select folder:C670("Select the DropBox folder to receive the journal")
$paths_o.delayInMinutes:=5  //minutes
$paths_o.journalFullName:="aMs-data.journal"

$success:=util_JSON_ObjToResourceFolder($paths_o; "config_Logfile")  //set up config file, needs to be set in the server's Resource folder

If ($success)  //display what was saved
	$paths_o:=util_JSON_ObjFromResourceFolder("config_Logfile")  //back test, this would normally be all that is needed for a run on the server
	ALERT:C41(Get 4D folder:C485(Current resources folder:K5:16)+":\r\r"+JSON Stringify:C1217($paths_o; *))
	
Else 
	ALERT:C41("Problem saving "+"config_Logfile.json")
End if 

