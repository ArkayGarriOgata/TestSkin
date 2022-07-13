//%attributes = {}

// Method: Job_WIP_Inventory ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/21/14, 15:07:34
// ----------------------------------------------------
// Description
// based on pattern_ServerFileToClient
//
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
C_DATE:C307(endDate)
//setup this instance
$filespec:="WIPinv_"
$serverMethodToRun:="Job_WIP_Inventory_Server"
$processNameOnServer:="WIP_Inventory_Report"
//$methodNameOnClient:=$processNameOnServer

Case of 
	: (Count parameters:C259<2)  //register and call server, do open when done
		If (Count parameters:C259=0)
			endDate:=Date:C102(Request:C163("Enter end date:"; String:C10(Current date:C33)))
		Else 
			endDate:=Date:C102($1)
		End if 
		$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
		Repeat   //wait your turn
			DELAY PROCESS:C323(Current process:C322; 30)
			$bizy:=util_RegisteredClient($client_call_back)
		Until ($bizy<1)
		
		$serverDocument:=$filespec+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		
		UNREGISTER CLIENT:C649  //belt and suspenders?
		REGISTER CLIENT:C648($client_call_back)
		zwStatusMsg("Waiting"; "Calling server "+String:C10(Current time:C178; HH MM SS:K7:1))
		$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $processNameOnServer; $client_call_back; Current method name:C684; $serverDocument; endDate)
		
		$path:=util_DocumentPath("get")+$serverDocument
		DELAY PROCESS:C323(Current process:C322; 60*5)
		//Repeat 
		//DELAY PROCESS(Current process;120)
		//zwStatusMsg ("Waiting";"Looking for "+$path+" "+String(Current time;HH MM SS))
		//Until (Test path name($path)=Is a document)
		$0:=$path
		
	: (Count parameters:C259=2)  //save called from server
		$serverDocument:=$1
		$docRef:=util_putFileName(->$serverDocument)
		CLOSE DOCUMENT:C267($docRef)
		BLOB TO DOCUMENT:C526($serverDocument; $2)
		UNREGISTER CLIENT:C649
		zwStatusMsg("Waiting"; "Saving "+$serverDocument+" "+String:C10(Current time:C178; HH MM SS:K7:1))
		$0:=""
		
	Else   //bad usage
		//TRACE
		$0:="arg usage error"
End case 
///end client side
