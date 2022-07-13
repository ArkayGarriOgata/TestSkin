//%attributes = {}

// Method: JobCosting_CostCenterAnalysis ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/11/14, 11:51:02
// ----------------------------------------------------
// Description
// based on pattern_ServerFileToClient
//
// ----------------------------------------------------
//OBSOLETE, rarely worked with race condition, see line 32 of doJobRptRecords

//begin on client side with:
C_TEXT:C284($1; $client_call_back; $0; $serverDocument)
C_LONGINT:C283($bizy; cb1)
C_BLOB:C604($2)

//setup this instance
$filespec:="Prod_AnalysisByCC_"
$serverMethodToRun:="JOB_ProductionAnalysisByCostCen"
$processNameOnServer:="Job Costing By C/C"

Case of 
	: (Count parameters:C259=0)  //register and call server, do open when done
		C_TEXT:C284(xText; xTitle)
		C_DATE:C307(dFrom; dTo; $To)
		SET MENU BAR:C67(4)
		DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
		DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select4.5A")
		ERASE WINDOW:C160
		
		//---------------------------------------------------------
		If (OK=1)
			SET WINDOW TITLE:C213("PRODUCTION ANALYSIS REPORT (by Cost Center)")
			
			$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
			Repeat   //wait your turn
				DELAY PROCESS:C323(Current process:C322; 30)
				$bizy:=util_RegisteredClient($client_call_back)
			Until ($bizy<1)
			
			$serverDocument:=$filespec+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			
			UNREGISTER CLIENT:C649  //belt and suspenders?
			REGISTER CLIENT:C648($client_call_back)
			$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $processNameOnServer; $client_call_back; Current method name:C684; $serverDocument; dFrom; dTo; cb1)
			
			$path:=util_DocumentPath("get")+$serverDocument
			DELAY PROCESS:C323(Current process:C322; 60*5)
			//Repeat 
			//DELAY PROCESS(Current process;120)
			//zwStatusMsg ("Waiting";"Looking for "+$path+" "+String(Current time;HH MM SS))
			//Until (Test path name($path)=Is a document)
			$0:=$path
			
		Else 
			$0:=""
		End if 
		CLOSE WINDOW:C154
		
	: (Count parameters:C259=2)  //save called from server
		$serverDocument:=$1
		$docRef:=util_putFileName(->$serverDocument)
		utl_Logfile("benchmark.log"; Current method name:C684+": Receiving "+docName+" at client")
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