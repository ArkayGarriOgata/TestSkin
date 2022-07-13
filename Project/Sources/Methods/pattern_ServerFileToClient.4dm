//%attributes = {}

// Method: pattern_ServerFileToClient ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/14, 10:44:30
// ----------------------------------------------------
// Description
// call a method that creates a document to run on the server 
// and then send that document to the client
// the client gets to pick the name of the doc and afterwards 
// leave it on disk or open it
// ----------------------------------------------------


//begin on client side with:
C_TEXT:C284($1; $client_call_back; $0; $serverDocument)
C_LONGINT:C283($bizy)
C_BLOB:C604($2)

//setup this instance
$filespec:="AgeFGinvenFIFO_"
$serverMethodToRun:="rptAgeFGfifo"
$processNameOnServer:="FiFo_Aged_Inventory_Report"
$methodNameOnClient:=$processNameOnServer

Case of 
	: (Count parameters:C259=0)  //register and call server, do open when done
		$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
		Repeat   //wait your turn
			$bizy:=util_RegisteredClient($client_call_back)
		Until ($bizy<1)
		
		$serverDocument:=$filespec+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		
		UNREGISTER CLIENT:C649  //belt and suspenders?
		REGISTER CLIENT:C648($client_call_back)
		$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $processNameOnServer; $client_call_back; Current method name:C684; $serverDocument)
		
		$path:=util_DocumentPath("get")+$serverDocument
		Repeat 
			DELAY PROCESS:C323(Current process:C322; 30)
		Until (Test path name:C476($path)=Is a document:K24:1)
		$0:=$path
		
	: (Count parameters:C259>=2)  //save called from server
		$serverDocument:=$1
		$docRef:=util_putFileName(->$serverDocument)
		CLOSE DOCUMENT:C267($docRef)
		BLOB TO DOCUMENT:C526($serverDocument; $2)
		UNREGISTER CLIENT:C649
		
		$0:=""
		
	Else   //bad usage
		//TRACE
		$0:="arg usage error"
End case 
///end client side

// // // // // // // // // // // // // //
//server-side
// build a docName
C_TEXT:C284($1; $client_call_back; $docShortName; docName)
If (Count parameters:C259=2)
	$client_call_back:=$1
	//$methodNameOnClient:=$2
	//docName:=$3  //************UNCOmMENT when used, just so patter can comple
	
Else 
	$client_call_back:=""
	$methodNameOnClient:=""
	docName:="AgeFGinvenFIFO_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
End if 

$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)
//
//
//then do your processing
//
//
//save to doc
$r:=Char:C90(13)
SEND PACKET:C103($docRef; xText)
SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
CLOSE DOCUMENT:C267($docRef)

If (Count parameters:C259>0)  //$client_requesting:=clientRegistered_as
	DOCUMENT TO BLOB:C525(docName; $blob)
	DELETE DOCUMENT:C159(docName)  // no reason to leave it around
	EXECUTE ON CLIENT:C651($client_call_back; $methodNameOnClient; $docShortName; $blob)
	SET BLOB SIZE:C606($blob; 0)  //clean up
	
Else   //legacy running on client
	$err:=util_Launch_External_App(docName)
End if 
//end server-side

