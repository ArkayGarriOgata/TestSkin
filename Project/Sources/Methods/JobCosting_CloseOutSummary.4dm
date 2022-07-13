//%attributes = {}

// Method: JobCosting_CloseOutSummary ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/11/14, 15:51:18
// ----------------------------------------------------
// Description
// based on pattern_ServerFileToClient
//
// ----------------------------------------------------
// Modified by: Mel Bohince (9/9/15) delay was 60, see if 120 helps


//begin on client side with:
C_TEXT:C284($1; $client_call_back; $0; $serverDocument)
C_LONGINT:C283($bizy)
C_BLOB:C604($2)

//setup this instance
$filespec:="JobSummaryRpt_"
$serverMethodToRun:="JOB_CloseoutSummary"
$processNameOnServer:="Job Close Out Summary"

Case of 
	: (Count parameters:C259=0)  //register and call server, do open when done
		dDateBegin:=UtilGetDate(Current date:C33; "ThisMonth")
		dDateEnd:=!00-00-00!
		$to:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)
		$customer:="@"
		DIALOG:C40([zz_control:1]; "DateRange2")
		CLOSE WINDOW:C154
		
		If (ok=1)
			SET WINDOW TITLE:C213("JOB CLOSEOUT SUMMARY REPORT (by Cost Center)")
			
			$client_call_back:=Replace string:C233(Current system user:C484; " "; "_")+"_Registered"
			Repeat   //wait your turn
				$bizy:=util_RegisteredClient($client_call_back)
				zwStatusMsg("Waiting"; "Registering client "+String:C10(Current time:C178; HH MM SS:K7:1))
			Until ($bizy<1)
			
			$serverDocument:=$filespec+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			
			UNREGISTER CLIENT:C649  //belt and suspenders?
			REGISTER CLIENT:C648($client_call_back)
			zwStatusMsg("Waiting"; "Calling server "+String:C10(Current time:C178; HH MM SS:K7:1))
			$id:=Execute on server:C373($serverMethodToRun; <>lMinMemPart; $processNameOnServer; $client_call_back; Current method name:C684; $serverDocument; dDateBegin; dDateEnd)
			
			$path:=util_DocumentPath("get")+$serverDocument
			DELAY PROCESS:C323(Current process:C322; 60*10)
			//Repeat 
			//DELAY PROCESS(Current process;120)  // Modified by: Mel Bohince (9/9/15) was 60, see if that helps
			//zwStatusMsg ("Waiting";"Looking for "+$path+" "+String(Current time;HH MM SS))
			//Until (Test path name($path)=Is a document)
			$0:=$path
			
		Else 
			$0:=""
		End if 
		
		
	: (Count parameters:C259=2)  //save called from server
		zwStatusMsg("Waiting"; "Server sending file "+String:C10(Current time:C178; HH MM SS:K7:1))
		$serverDocument:=$1
		$docRef:=util_putFileName(->$serverDocument)
		CLOSE DOCUMENT:C267($docRef)
		BLOB TO DOCUMENT:C526($serverDocument; $2)
		UNREGISTER CLIENT:C649
		zwStatusMsg("Saving"; $serverDocument+" at "+String:C10(Current time:C178; HH MM SS:K7:1))
		$0:=""
		
	Else   //bad usage
		//TRACE
		$0:="arg usage error"
End case 
///end client side