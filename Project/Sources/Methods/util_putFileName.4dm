//%attributes = {"publishedWeb":true}
//PM: util_putFileName(->shortname) -> 
//@author mlb - 4/24/03  11:54
//sample usage
//see pattern_SaveDocument 

If (False:C215)  //sample usage
	//docName:="AgeFGinventory_"+fYYMMDD (Current date)+"_"+Replace string(String(4d_Current_time;◊HHMM);":";"")
	//$docRef:=util_putFileName (->docName)
	//  `...
	//CLOSE DOCUMENT($docRef)
	//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	//$err:=util_Launch_External_App (docName)
End if 
C_POINTER:C301($1)
C_TEXT:C284($fileName; $path; $fullPath; $2)
C_TIME:C306($0)
If (Count parameters:C259>0)
	$fileName:=$1->
Else 
	$fileName:="temp.txt"
End if 

If (Count parameters:C259=1)
	$path:=util_DocumentPath("get")
Else   //already inline
	$path:=""
End if 

$fullPath:=$path+$fileName

util_deleteDocument($fullPath)

$0:=Create document:C266($fullPath)
If (ok=1)
	$1->:=$fullPath
Else 
	$1->:=""
End if 


//zwStatusMsg ("PUT FILE";$fullPath)

//C_TEXT($path)
//$path:=util_DocumentPath +"pk_ids.csv"
//$path:=Select document($path;"CSV";"Save the Primary Keys as:";File name entry)
//$docRef:=Create document(document)  //name the export file
//If (ok=1)
//CLOSE DOCUMENT($docRef)
//End if 
