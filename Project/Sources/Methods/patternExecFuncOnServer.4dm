//%attributes = {}
// _______
// Method: patternExecFuncOnServer   ( ) -> context_o
// By: Mel Bohince @ 11/05/20, 16:16:01
// Description
// make a synchronis call to a method that executes on the server 
// that will behave as a function and return a json
// these two lines demonstrate the pattern, the rest is for an example:
//     $result_json:=patternMethodWithEOSattribute ($context)
//     $result_o:=JSON Parse($result_json)
// ----------------------------------------------------

//passing the context_o is OPTIONAL, use it if you need to pass in arguments
C_OBJECT:C1216($context_o)
$context:=New object:C1471("status"; "start")
$context.contextId:=Generate UUID:C1066
$context.dateBegin:=Add to date:C393(Current date:C33; 0; -1; 0)
$context.dateEnd:=Add to date:C393(Current date:C33; 0; -1; 15)

////////////////////////////
//expect the server "function" to return an object that has been Stringify'd
//then re-bake into and object to use its results attribute
C_TEXT:C284($result_json)
C_OBJECT:C1216($result_o)
$result_json:=patternExecFuncWith_EOS($context)
$result_o:=JSON Parse:C1218($result_json)

////////////////////////////use the sample "work"
//now you can use the results of the method that was executed on the server:
//in this example a text varible was created in csv format to make an Excel report


//save the text to a document in the users aMs_Documents folder
C_TEXT:C284($docName)
C_TIME:C306($docRef)
$docName:="CSV_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $result_o.result)  //USE THE RESULTS OF THE SERVER "FUNCTION"
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("Just trying to help.")
End if 
$err:=util_Launch_External_App($docName)
//
