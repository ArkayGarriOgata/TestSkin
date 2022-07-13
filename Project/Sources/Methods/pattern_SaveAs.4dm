//%attributes = {}
// _______
// Method: pattern_SaveAs   ("pk_ids.csv" ) ->
// By: Mel Bohince @ 05/05/21, 10:25:37
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($suggestedName; $1; $path; $type; $message; $filename)
C_TIME:C306($docRef; $0)
If (Count parameters:C259=1)
	$suggestedName:=$1
Else 
	$suggestedName:="pk_ids.csv"
End if 
$type:="CSV"
$message:="Save the Primary Keys as:"

$path:=util_DocumentPath+$suggestedName

$filename:=Select document:C905($path; $type; $message; File name entry:K24:17)
If (ok=1)
	
	$docRef:=Create document:C266(Document)  //name the export file
	If (ok=1)
		
		CLOSE DOCUMENT:C267($docRef)
		
	End if 
	
End if 

$0:=$docRef

