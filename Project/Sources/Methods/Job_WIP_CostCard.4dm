//%attributes = {}

// Method: Job_WIP_CostCard ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/22/14, 08:29:00
// Rewrite: MelvinBohince (4/6/22) rewrite, call an method with Execute on Server ticked
// ----------------------------------------------------
// Description
// file manager for Job_WIP_CostCard_EOS
// ----------------------------------------------------

C_TEXT:C284($docName; $csvText; $1; $jobForm; $0)

$jobForm:=$1

$csvText:=Job_WIP_CostCard_EOS($jobForm)

$CCPath:=uCreateFolder("Cost_Cards")

$docName:=$CCPath+"CostCard_"+$jobform+"_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"

//$docName:=$CCPath+$docName
C_TIME:C306($docRef)
util_deleteDocument($docName)
$docRef:=Create document:C266($docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237($docName; $csvText)

$0:=$docName
