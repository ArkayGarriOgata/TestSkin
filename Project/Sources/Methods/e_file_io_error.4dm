//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 02/22/11, 14:52:44
// ----------------------------------------------------
// Method: e_file_io_error
// Description
// log error when doing system documents
// ----------------------------------------------------
$errDoc:="on_error_call_"+fYYMMDD(4D_Current_date)+"_"+String:C10(Milliseconds:C459)+".log"
utl_Logfile($errDoc; "FILE I/O ERROR CODE "+String:C10(error)+" ENCOUNTERED by aMs")
ABORT:C156

//TEST:
//$path:=<>PATH_TO_LOG_FILE+"aatest.log"  //util_DocumentPath ("get")+logName
//If (Test path name($path)#Is a document)
//$docRef:=Create document($path)  //util_putFileName (->logName)
//CLOSE DOCUMENT($docRef)
//End if 

//$docRef:=Append document($path)

//utl_Logfile ("aatest.log";"here is my message that locks")

//CLOSE DOCUMENT($docRef)