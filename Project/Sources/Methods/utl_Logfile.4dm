//%attributes = {"publishedWeb":true}
//PM: utl_Logfile($logName;$logEntry) -> 
//@author mlb - 6/28/02  11:08
// • mel (8/27/04, 09:29:39) put in ams_documents folder
// Modified by Mel Bohince on 2/8/07 use <LF> so tail -f can be used to watch log
// Modified by: Mel Bohince (5/4/17) trap for file io error

//$pid:=Execute on server("utl_Logfile";0;"rpc:utl_Logfile";"wiretap.log";$msg)
//see utl_LogfileServer(<>zResp;

C_TIME:C306($docRef)
C_TEXT:C284($1; $logEntry; $2; logName; $path; $methCurrent)
C_BOOLEAN:C305($locked; $invisible)
C_DATE:C307($createdon; $modifiedon)
C_TIME:C306($createdat; $modifiedat)

If (Count parameters:C259=2)
	logName:=$1
	$logEntry:=$2
	$path:=<>PATH_TO_LOG_FILE+logName  //util_DocumentPath ("get")+logName
	
	If (Test path name:C476($path)#Is a document:K24:1)
		$docRef:=Create document:C266($path)  //util_putFileName (->logName)
		CLOSE DOCUMENT:C267($docRef)
	End if 
	
	// Modified by: Mel Bohince (5/4/17) try again without loop
	$methCurrent:=Method called on error:C704
	ON ERR CALL:C155("e_file_io_error")
	
	$docRef:=Append document:C265($path)
	If (ok=1)
		SEND PACKET:C103($docRef; TS_ISO_String_TimeStamp+" * "+$logEntry+Char:C90(Line feed:K15:40))
	End if 
	CLOSE DOCUMENT:C267($docRef)
	
	ON ERR CALL:C155($methCurrent)  // Modified by: Mel Bohince (5/4/17)
	//
Else 
	BEEP:C151
	zwStatusMsg("utl_Logfile"; "invalid parameter list")
End if 