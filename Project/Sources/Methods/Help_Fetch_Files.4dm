//%attributes = {}
// Method: Help_Fetch_Files ($tPathName)  -> 
// ----------------------------------------------------
// Author: Logan Richards
// Created: 06/30/14, 10:44:30
// ----------------------------------------------------
// Description
// call a method that gets a document from the server
// and then send that document to the client
// ----------------------------------------------------

If (True:C214)
	
	//begin on client side with:
	C_TEXT:C284($client_call_back)
	//C_TEXT($serverDocument)
	C_OBJECT:C1216($serverDocument)
	C_LONGINT:C283($bizy)
	C_TEXT:C284($1; $tFilePath)
	C_OBJECT:C1216($tFile; $tDestination)
	C_COLLECTION:C1488($cParsePath)
	$cParsePath:=New collection:C1472()
	
End if 

//setup this instance
$filespec:=$tPath
$serverMethodToRun:="Help_Zip_SrvFiles"
$processNameOnServer:="Help_Doc_Present"
$methodNameOnClient:=$processNameOnServer

$tFilePath:=$1
$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
Repeat   //wait your turn
	$bizy:=util_RegisteredClient($client_call_back)
Until ($bizy<1)

$cParsePath:=Split string:C1554($tFilePath; CorektColon)

$serverDocument:=Folder:C1567(Database folder:K5:14)

$localFolder:=Get 4D folder:C485(4D Client database folder:K5:13)

For each ($lvl; $cParsePath)
	Case of 
		: (Substring:C12($lvl; Length:C16($lvl)-3; Length:C16($lvl))=".txt")
			$serverDocument:=$serverDocument.file($lvl)
		: (Substring:C12($lvl; Length:C16($lvl)-3; Length:C16($lvl))=".pdf")
			$serverDocument:=$serverDocument.file($lvl)
		Else 
			$serverDocument:=$serverDocument.folder($lvl)
	End case 
End for each 

UNREGISTER CLIENT:C649  //belt and suspenders?
REGISTER CLIENT:C648($client_call_back)
$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $tFilePath; $localFolder; $oResult)

$0:=$localFolder

//////////////////////////////////////////////////////////////////////////////////////////
//$tFile:=Folder(Database folder).folder($tPath)
//$tDestination:=Folder(fk documents folder).folder("amshelp").folder($tPath)

//ZIP Create archive($tFile; $tDestination)

//$archive:=ZIP Read archive($tDestination)

//$folders:=archive.root.folders()

//$files:=$archive.root.files()

//$cFolders:=New collection($folders)

//ZIP Read archive($tDestination)