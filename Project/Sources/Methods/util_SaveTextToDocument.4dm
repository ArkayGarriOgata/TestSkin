//%attributes = {}
// _______
// Method: util_SaveTextToDocument   (docName;text ) ->
// By: MelvinBohince @ 06/17/22, 22:54:23
// Description
// 
// ----------------------------------------------------

//save the text to a document
C_POINTER:C301($textPtr; $2)
$textPtr:=$2
C_TEXT:C284($docName)
$docName:=$1  //the prefix before timestamp is added

C_TIME:C306($docRef)

$docName:=$docName+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $textPtr->)
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("Just trying to help.")
End if 
$err:=util_Launch_External_App($docName)