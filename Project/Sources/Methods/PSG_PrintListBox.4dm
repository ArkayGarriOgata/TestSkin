//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/12/14, 15:27:53
// ----------------------------------------------------
// Method: PSG_PrintListBox
// Description
// WYSWIG printing
//  see also util_PrintScreenShot
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (9/13/15) v14 fix

//get the screenshot
C_PICTURE:C286($image)
FORM SCREENSHOT:C940($image)
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
	
	//$path:="/Volumes/"+Replace string(docName;":";"/")  //"/Volumes/EngDraw/"+aOutlineNum{aOutlineNum}+".pdf"
	//$path:=Replace string($path;" ";"\\ ")  //doesn't like spaces
	//zwStatusMsg ("lpr";$path)
	//LAUNCH EXTERNAL PROCESS("lpr "+$path)
	
End if 

//End if   //ok print settings