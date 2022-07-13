//%attributes = {}
// -------
// Method: PF_SendDataCollection   ( ) ->
// By: Mel Bohince @ 02/22/18, 17:01:31
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/7/18) make sure filename is unique if batching many quickly

C_TEXT:C284($printflow_volumn; $printflow_inbox_path; $printflow_export_fn; $tLine; $millidiff; $docName)
C_LONGINT:C283($millinow; $millithen)
C_TIME:C306($docRef)

$err:=util_MountNetworkDrive("PrintFlow")

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
If (Find in array:C230($aVolumes; "PrintFlow")>-1)
	$printflow_volumn:="PrintFlow:"
	$printflow_inbox_path:=$printflow_volumn+"XmlInbox:"  //this is what PF_connector expects
	If (Test path name:C476($printflow_inbox_path)#Is a folder:K24:2)
		CREATE FOLDER:C475($printflow_inbox_path)
	Else 
		ok:=1
	End if 
	
Else 
	$printflow_inbox_path:=util_DocumentPath("get")
	$printflow_inbox_path:=Request:C163("Path (like-> PrintFlow:)"; $printflow_inbox_path; "Export"; "Cancel")
End if 
// Modified by: Mel Bohince (3/7/18) make unique
$millinow:=Milliseconds:C459
$millithen:=Trunc:C95($millinow; -4)
$diff:=$millinow-$millithen
$millidiff:=String:C10($diff; "0000")

$docName:="DC_"+Replace string:C233([PrintFlow_Msg_Queue:169]JobRef:7; "."; "_")+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+"_"+$millidiff+".xml"
DELAY PROCESS:C323(Current process:C322; 1)  //belt and suspenders

$printflow_export_fn:=$printflow_inbox_path+$docName

$docRef:=Create document:C266($printflow_export_fn)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; [PrintFlow_Msg_Queue:169]XML_text:6)
	[PrintFlow_Msg_Queue:169]Sent:5:=TSTimeStamp
	SAVE RECORD:C53([PrintFlow_Msg_Queue:169])
	CLOSE DOCUMENT:C267($docRef)
	zwStatusMsg("PrintFlow"; $docName+" was sent to PrintFlow's Inbox.")
	utl_Logfile("PrintFlow"; $docName+" was sent to PrintFlow's Inbox.")
Else 
	BEEP:C151
	zwStatusMsg("PrintFlow"; $docName+" not sent to PrintFlow's Inbox.")
	utl_Logfile("PrintFlow"; $docName+" not sent to PrintFlow's Inbox.")
End if 

