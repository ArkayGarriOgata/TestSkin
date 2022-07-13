//%attributes = {}
// -------
// -------
// ------- NOT USED see PF_SendTimeAndImpressions
// -------
// -------
// ------- // -------

// Method: PF_DataCollectionToXML   ( ) ->
// By: Mel Bohince @ 12/12/17, 08:26:21
// Description
// send updates or completes based on MachineTicket entries
// ----------------------------------------------------
// <Run Action="Update" Status="In Setup" Code="1" CostCenterCode="210" StartSetupDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//<Run Action="Update" Status="Complete" Code="1" CostCenterCode="210" EndRunDate="2018-02-21T08:38-05:00" SetupMinutes="15" EmployeeID="Dirk " SplitNumber="1" />
//  <Run Action="Update" Status="Running" Code="1" CostCenterCode="210" StartRunDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//<Run Action="Update" Status="Complete" Code="1" CostCenterCode="210" RunMinutes="60" CompletedQuantity="123" EndRunDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//to complete task, no 'run' node, just
//<Task Action="Update" Status="Complete" Code="Task 1" CostCenterCode="210" />

C_BOOLEAN:C305($err; $sendProperties)
C_TEXT:C284($printflow_volumn; $printflow_inbox_path; $path; $processed_folder; $printflow_export_fn; $print_flow_docpath; $newDocName; $tLine; $path)

C_TEXT:C284($jobform; $xmltext; $note; $2; $messageStatus)
C_LONGINT:C283($mtRecNum; $1)
C_DATE:C307($currentDate)
C_TIME:C306($currentTime)
$sendProperties:=True:C214

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


If (Count parameters:C259>0)
	$mtRecNum:=$1
	GOTO RECORD:C242([Job_Forms_Machine_Tickets:61]; $mtRecNum)
	$messageStatus:=$2
Else 
	QUERY:C277([Job_Forms_Machine_Tickets:61])
	$messageStatus:=Request:C163("Status= "; "In Setup"; "Ok"; "Cancel")
End if 

$jobform:=[Job_Forms_Machine_Tickets:61]JobForm:1
$jobseq:=[Job_Forms_Machine_Tickets:61]JobFormSeq:16
$job:=$jobform  //Substring($jobform;1;5)
$form:=$job+"-0"
$currentTime:=Current time:C178
$currentDate:=Current date:C33
//$now:=Change string($now;"T";11)
$now:=PF_util_FormatDate(->$currentDate; $currentTime)
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="DC_"+Replace string:C233($jobseq; "."; "_")+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xml"
$printflow_export_fn:=$printflow_inbox_path+$docName

C_TEXT:C284($elementRef)
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
	APPEND TO ARRAY:C911($AttrVal; "Completing a task")
	
	APPEND TO ARRAY:C911($AttrName; "Version")
	APPEND TO ARRAY:C911($AttrVal; "Prism version 123")
	
	APPEND TO ARRAY:C911($AttrName; "ChangeDate")
	APPEND TO ARRAY:C911($AttrVal; $now)
	
	DOM SET XML ATTRIBUTE:C866($elementRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})
End if   //root

If (True:C214)  //jobs-job-form
	$jobsref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<Jobs></Jobs>")
	DOM SET XML ATTRIBUTE:C866($jobsref; "Code"; "Jobs")
	
	$jobref:=DOM Append XML child node:C1080($jobsref; XML ELEMENT:K45:20; "<Job></Job>")
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	APPEND TO ARRAY:C911($AttrName; "Code")
	APPEND TO ARRAY:C911($AttrVal; $job)
	APPEND TO ARRAY:C911($AttrName; "Action")
	APPEND TO ARRAY:C911($AttrVal; "None")
	DOM SET XML ATTRIBUTE:C866($jobref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
End if   //jobs

If (True:C214)  //form
	$formref:=DOM Append XML child node:C1080($jobref; XML ELEMENT:K45:20; "<Form></Form>")
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	APPEND TO ARRAY:C911($AttrName; "Code")
	APPEND TO ARRAY:C911($AttrVal; $form)
	APPEND TO ARRAY:C911($AttrName; "Action")
	APPEND TO ARRAY:C911($AttrVal; "None")
	DOM SET XML ATTRIBUTE:C866($formref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
End if   //form

If (True:C214)  //task
	$taskref:=DOM Append XML child node:C1080($formref; XML ELEMENT:K45:20; "<Task></Task>")
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	APPEND TO ARRAY:C911($AttrName; "Code")
	If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>GLUERS)=0)
		APPEND TO ARRAY:C911($AttrVal; Substring:C12([Job_Forms_Machine_Tickets:61]JobFormSeq:16; 10))
	Else 
		$jobformSeqItem:=Substring:C12([Job_Forms_Machine_Tickets:61]JobFormSeq:16; 10)+"."+String:C10([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; "00")  //+"."+string([Job_Forms_Machine_Tickets]Subform)
		APPEND TO ARRAY:C911($AttrVal; $jobformSeqItem)
	End if 
	APPEND TO ARRAY:C911($AttrName; "Action")
	APPEND TO ARRAY:C911($AttrVal; "None")
	DOM SET XML ATTRIBUTE:C866($taskref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
End if   //task

If (True:C214)  //run
	$runref:=DOM Append XML child node:C1080($taskref; XML ELEMENT:K45:20; "<Run></Run>")
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	APPEND TO ARRAY:C911($AttrName; "Code")
	APPEND TO ARRAY:C911($AttrVal; "1")
	APPEND TO ARRAY:C911($AttrName; "Action")
	APPEND TO ARRAY:C911($AttrVal; "Update")
	APPEND TO ARRAY:C911($AttrName; "Status")
	APPEND TO ARRAY:C911($AttrVal; $messageStatus)
	//If (Position("C";[Job_Forms_Machine_Tickets]P_C)>0)
	//APPEND TO ARRAY($AttrVal;"Complete")
	//Else 
	//APPEND TO ARRAY($AttrVal;"Running")
	//End if 
	APPEND TO ARRAY:C911($AttrName; "CostCenterCode")
	APPEND TO ARRAY:C911($AttrVal; [Job_Forms_Machine_Tickets:61]CostCenterID:2)
	
	APPEND TO ARRAY:C911($AttrName; "RunMinutes")
	APPEND TO ARRAY:C911($AttrVal; String:C10(Round:C94(([Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]MR_Act:6)*60; 0)))
	APPEND TO ARRAY:C911($AttrName; "CompletedQuantity")
	APPEND TO ARRAY:C911($AttrVal; String:C10([Job_Forms_Machine_Tickets:61]Good_Units:8))
	
	APPEND TO ARRAY:C911($AttrName; "StartRunDate")  // StartRunDate   EndRunDate
	APPEND TO ARRAY:C911($AttrVal; TS2iso([Job_Forms_Machine_Tickets:61]TimeStampEntered:17; "T"))
	APPEND TO ARRAY:C911($AttrName; "EmployeeID")
	APPEND TO ARRAY:C911($AttrVal; [Job_Forms_Machine_Tickets:61]Operator:27)
	
	DOM SET XML ATTRIBUTE:C866($runref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7}; $AttrName{8}; $AttrVal{8})
End if   //run


C_TEXT:C284($xmlvar)
DOM EXPORT TO VAR:C863($elementRef; $xmlvar)
//DOM EXPORT TO FILE($elementRef;$printflow_export_fn)

DOM CLOSE XML:C722($elementRef)
BEEP:C151
