//%attributes = {}
// -------
// Method: PF_JobsRemoveFromPF   ( ) ->
// By: Mel Bohince @ 04/11/18, 13:58:45
// Description
// look for completed jobs that have been sent to PF, and remove if found
// ----------------------------------------------------

C_BOOLEAN:C305($err)
C_TEXT:C284($printflow_volumn; $printflow_inbox_path)
C_DATE:C307($gracePeriod; $currentDate)
C_TIME:C306($currentTime)
C_LONGINT:C283($job)
C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)
C_TEXT:C284($elementRef)

$gracePeriod:=Add to date:C393(Current date:C33; 0; 0; -6)
$currentTime:=Current time:C178
$currentDate:=Current date:C33
$now:=PF_util_FormatDate(->$currentDate; $currentTime)

$err:=util_MountNetworkDrive("PrintFlow")

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
If (Find in array:C230($aVolumes; "PrintFlow")>-1)  //&(false)
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


//Begin SQL
//select JobForm from Job_Forms_Master_Schedule 
//where DateComplete > '01/01/01'
//and  > '01/01/01'
//into :$aJobsToSend
//End SQL
READ WRITE:C146([Job_Forms_Master_Schedule:67])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15<$gracePeriod; *)  //completed a week ago
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!; *)  //not still open, null
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89#<>Magic_Date; *)  //not already removed
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89#!00-00-00!)  //sent to pf


For ($job; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
	
	$docName:="Job_rm_"+Replace string:C233([Job_Forms_Master_Schedule:67]JobForm:4; "."; "_")+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xml"
	$docName:=$printflow_inbox_path+$docName
	
	If (True:C214)  //root
		$elementRef:=DOM Create XML Ref:C861("PrintFlowData")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "Sender")
		APPEND TO ARRAY:C911($AttrVal; "Administrator")
		
		APPEND TO ARRAY:C911($AttrName; "Machine")
		APPEND TO ARRAY:C911($AttrVal; "WIN-QAEA4RO0N0B")
		
		APPEND TO ARRAY:C911($AttrName; "ProgramName")
		APPEND TO ARRAY:C911($AttrVal; "PrintFlowXMLCsharp.exe  2.0.0.0")
		
		APPEND TO ARRAY:C911($AttrName; "Comment")
		APPEND TO ARRAY:C911($AttrVal; "Removing a Job")
		
		APPEND TO ARRAY:C911($AttrName; "Version")
		APPEND TO ARRAY:C911($AttrVal; "Prism version 123")
		
		APPEND TO ARRAY:C911($AttrName; "ChangeDate")
		APPEND TO ARRAY:C911($AttrVal; $now)
		
		DOM SET XML ATTRIBUTE:C866($elementRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})
	End if   //root
	
	If (True:C214)  //jobs-job
		$jobsref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<Jobs></Jobs>")
		DOM SET XML ATTRIBUTE:C866($jobsref; "Code"; "Jobs")
		
		$jobref:=DOM Append XML child node:C1080($jobsref; XML ELEMENT:K45:20; "<Job></Job>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		
		APPEND TO ARRAY:C911($AttrName; "Code")  //1
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms_Master_Schedule:67]JobForm:4)
		
		APPEND TO ARRAY:C911($AttrName; "Action")  //2
		APPEND TO ARRAY:C911($AttrVal; "Delete")
		
		
		DOM SET XML ATTRIBUTE:C866($jobref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
	End if   //jobs
	
	DOM EXPORT TO FILE:C862($elementRef; $docName)
	If (ok=1)  // Modified by: Mel Bohince (12/18/17) 
		[Job_Forms_Master_Schedule:67]Exported_PrintFlow:89:=<>Magic_Date
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		utl_Logfile("PrintFlow"; $docName+" was sent to PrintFlow's Inbox.")
	End if 
	DOM CLOSE XML:C722($elementRef)
	
	
	NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
End for 

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	//4d Ps replace UNLOAD RECORD([Job_Forms_Master_Schedule]) REDUCE SELECTION([Job_Forms_Master_Schedule];0) 
	
	UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
Else 
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	
End if 