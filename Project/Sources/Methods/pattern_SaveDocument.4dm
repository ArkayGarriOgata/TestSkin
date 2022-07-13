//%attributes = {}
// Method: pattern_SaveDocument () -> 
// ----------------------------------------------------
// by: mel: 11/25/03, 09:12:50
// ----------------------------------------------------

C_TEXT:C284($title; $text; $docName; $millidiff)
C_LONGINT:C283($millinow; $millithen)
C_TIME:C306($docRef)

$title:=""
$text:=""
$docName:="NameOfDocument"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"

If (False:C215)  //more likely unique this way
	$millinow:=Milliseconds:C459  //don't want all the time since boot
	$millithen:=Round:C94($millinow; -4)
	$millidiff:=String:C10($millinow-$millithen; "0000")
	$docName:="NameOfDocument"+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+"_"+$millidiff+".xml"
	DELAY PROCESS:C323(Current process:C322; 1)  //belt and suspenders
End if 

$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	
	If (Length:C16($text)>25000)
		SEND PACKET:C103($docRef; $text)
		$text:=""
	End if 
	
	$text:=$text+"something"+"\t"+"more"+"\r"
	
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	//// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
	$err:=util_Launch_External_App($docName)
End if 