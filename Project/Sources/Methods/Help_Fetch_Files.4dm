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
	C_OBJECT:C1216($0; $oSource; $oDestination)
	C_TEXT:C284($client_call_back)
	C_LONGINT:C283($bizy)
	C_TEXT:C284($1; $tFilePath)
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
$oSource:=Folder:C1567(Current resources folder:K5:16)
$oDestination:=Folder:C1567(4D Client database folder:K5:13)

For each ($lvl; $cParsePath)
	Case of 
		: (Substring:C12($lvl; Length:C16($lvl)-3; Length:C16($lvl))=".txt")
			$oSource:=$oSource.file($lvl)
		: (Substring:C12($lvl; Length:C16($lvl)-3; Length:C16($lvl))=".pdf")
			$oSource:=$oSource.file($lvl)
		Else 
			$oSource:=$oSource.folder($lvl)
			$oDestination:=$oDestination.folder($lvl)
	End case 
End for each 
//$oTestSource:=Folder(Current resources folder).file($tFilePath)

//create destination folder, determine whether this is the clients resource folder or servers resource folder
$tFPath:=Get 4D folder:C485(Current resources folder:K5:16)+$tFilePath
//If (Test path name($tFPath)#Is a document)
//$vhDocRef:=Create document("Journal")
CREATE FOLDER:C475($tFPath; *)
//If (OK=1)
//CLOSE DOCUMENT($vhDocRef)
//End if 
//End if

UNREGISTER CLIENT:C649  //belt and suspenders?
REGISTER CLIENT:C648($client_call_back)
$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $methodNameOnClient; $oSource; $oDestination; $oResult)

$0:=$oDestination