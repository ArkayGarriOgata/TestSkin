//%attributes = {}

//  // Method: FiFo_Inventory_Report ( )  -> 
//  // ----------------------------------------------------
//  // Author: Mel Bohince
//  // Created: 04/03/14, 14:29:52
//  // ----------------------------------------------------
//  // Description
//  // see pattern_ServerFileToClient
//  // run a slow method on the server and return the report in a blob
//  // ----------------------------------------------------


//  //begin on client side with:
//C_TEXT($1;$client_call_back;$0;$serverDocument;$filespec;$serverMethodToRun;$processNameOnServer)
//C_LONGINT($bizy)
//C_BLOB($2)

//  //setup this instance
//$filespec:="INVEN@FIFO_"
//$serverMethodToRun:="JIC_inventoryRpt"
//$processNameOnServer:="FiFo_Inventory_Report"

//Case of 
//: (Count parameters=0)  //register and call server, do open when done
//$client_call_back:=Replace string(Current system user;" ";"_")+"_Registered"
//Repeat   //wait your turn
//$bizy:=util_RegisteredClient ($client_call_back)
//Until ($bizy<1)

//$serverDocument:=$filespec+fYYMMDD (4D_Current_date )+"_"+Replace string(String(4d_Current_time ;<>HHMM);":";"")+".xls"

//UNREGISTER CLIENT  //belt and suspenders?
//REGISTER CLIENT($client_call_back)
//$id:=Execute on server($serverMethodToRun;<>lMinMemPart;$processNameOnServer;$client_call_back;$serverDocument)


//$path:=util_DocumentPath ("get")+$serverDocument
//Repeat 
//DELAY PROCESS(Current process;30)

//Until (Test path name($path)=Is a document)

//$0:=$path

//: (Count parameters=2)  //save called from server
//$serverDocument:=$1
//$docRef:=util_putFileName (->$serverDocument)
//CLOSE DOCUMENT($docRef)
//BLOB TO DOCUMENT($serverDocument;$2)
//UNREGISTER CLIENT
//$0:=""

//Else   //bad usage
//  //TRACE
//$0:="arg usage error"
//End case 



