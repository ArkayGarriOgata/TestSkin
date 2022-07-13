//%attributes = {}

// Method: util_PrintScreenShot ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/28/14, 13:56:17
// ----------------------------------------------------
// Description
// 
// see also PSG_PrintListBox
// ----------------------------------------------------
// Modified by: Mel Bohince (9/13/15) v14 fix

//get the screenshot
C_PICTURE:C286($image)
C_TEXT:C284($table; $form; $1; $2)
If (Count parameters:C259=0)
	FORM SCREENSHOT:C940($image)
Else 
	//$table:=$1
	//$form:=$2
	//FORM SCREENSHOT($table;$form;$image;1)
End if 
//do something with it
docName:=Get window title:C450
docName:=Replace string:C233(docName; " "; "_")
docName:=Replace string:C233(docName; ":"; "")
docName:=docName+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".jpg"  //fYYMMDD (4D_Current_date)  //
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	CLOSE DOCUMENT:C267($docRef)  // Modified by: Mel Bohince (9/13/15) v14 fix
	WRITE PICTURE FILE:C680(docName; $image)
	$err:=util_Launch_External_App(docName)
End if 