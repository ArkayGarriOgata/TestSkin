//%attributes = {}

// Method: FiFo_Inventory_Report_Detail ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/03/14, 15:00:32
// ----------------------------------------------------
// Description
// see pattern_ServerFileToClient
// run a slow method on the server and return the report in a blob
// ----------------------------------------------------


//begin on client side with:
C_TEXT:C284($1; $client_call_back; $0; $serverDocument; $filespec; $serverMethodToRun; $processNameOnServer)
C_LONGINT:C283($bizy)
C_BLOB:C604($2)

//setup this instance
$filespec:="INVEN_DTL@FIFO_"
$serverMethodToRun:="JIC_inventoryDetailRpt"
$processNameOnServer:="FiFo_Inventory_Report_Detail"

Case of 
	: (Count parameters:C259=0)  //register and call server, do open when done
		$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
		Repeat   //wait your turn
			$bizy:=util_RegisteredClient($client_call_back)
		Until ($bizy<1)
		
		$serverDocument:=$filespec+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		
		UNREGISTER CLIENT:C649  //belt and suspenders?
		REGISTER CLIENT:C648($client_call_back)
		$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $processNameOnServer; $client_call_back; $serverDocument)
		
		
		$path:=util_DocumentPath("get")+$serverDocument
		Repeat 
			DELAY PROCESS:C323(Current process:C322; 30)
			
		Until (Test path name:C476($path)=Is a document:K24:1)
		
		$0:=$path
		
	: (Count parameters:C259=2)  //save called from server
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
