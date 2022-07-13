//%attributes = {}
// -------
// Method: PF_SendTimeAndImpressions   ({ $jobFormSeq;$costCtr;$jobitem;$hours;$impressions;p_c }) ->
// By: Mel Bohince @ 02/23/18, 16:22:28
// Description
// send machine ticket data collection
// ----------------------------------------------------
// Modified by: Mel Bohince (3/6/18) don't send if sequence is already marked as complete

// <Run Action="Update" Status="In Setup" Code="1" CostCenterCode="210" StartSetupDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//<Run Action="Update" Status="Complete" Code="1" CostCenterCode="210" EndRunDate="2018-02-21T08:38-05:00" SetupMinutes="15" EmployeeID="Dirk " SplitNumber="1" />
//  <Run Action="Update" Status="Running" Code="1" CostCenterCode="210" StartRunDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//<Run Action="Update" Status="Complete" Code="1" CostCenterCode="210" RunMinutes="60" CompletedQuantity="123" EndRunDate="2018-02-21T08:38-05:00" EmployeeID="Dirk " SplitNumber="1" />
//to complete task, no 'run' node, just
//<Task Action="Update" Status="Complete" Code="Task 1" CostCenterCode="210" />

If (False:C215)  // Modified by: Mel Bohince (7/9/21) disable PF
	
	C_BOOLEAN:C305($err; $sendProperties)
	C_TEXT:C284($printflow_volumn; $printflow_inbox_path; $path; $processed_folder; $printflow_export_fn; $print_flow_docpath; $newDocName; $tLine; $path)
	$messageStatus:="In Setup"
	C_TEXT:C284($jobform; $xmltext; $note; $1; $2; $jobFormSeq; $costCtr)
	
	C_DATE:C307($currentDate)
	C_TIME:C306($currentTime)
	$sendProperties:=True:C214
	
	If (Count parameters:C259>0)
		$jobFormSeq:=$1
		$costCtr:=$2
		$jobitem:=String:C10($3; "00")
		$hours:=$4
		$impressions:=$5
		If ($6)
			$status:="Complete"
		Else 
			$status:="Running"
		End if 
	Else 
		QUERY:C277([Job_Forms_Machine_Tickets:61])
		$jobFormSeq:=[Job_Forms_Machine_Tickets:61]JobFormSeq:16
		$costCtr:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
		$jobitem:=Substring:C12([Job_Forms_Machine_Tickets:61]Jobit:23; 10; 2)
		$hours:=[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
		$impressions:=[Job_Forms_Machine_Tickets:61]Good_Units:8
		If (Position:C15("C"; [Job_Forms_Machine_Tickets:61]P_C:10)>0)
			$status:="Complete"
		Else 
			$status:="Running"
		End if 
	End if 
	
	// Modified by: Mel Bohince (3/6/18) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $taskCompleted)
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobFormSeq; *)
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23>0)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($taskCompleted=0)  //not marked complete so send intermediate t & i
		
		If (($hours+$impressions)>0)
			$jobform:=Substring:C12($jobFormSeq; 1; 8)
			$jobseq:=$jobFormSeq  //12345.12.123
			$job:=$jobform  //Substring($jobform;1;5)
			$form:=$job+"-0"
			$currentTime:=Current time:C178
			$currentDate:=Current date:C33
			//$now:=Change string($now;"T";11)
			$now:=PF_util_FormatDate(->$currentDate; $currentTime)
			//C_TEXT($docName)
			//C_TIME($docRef)
			
			//$docName:="DC_"+Replace string($jobseq;".";"_")+"_"+fYYMMDD (4D_Current_date)+"_"+Replace string(String(4d_Current_time;<>HHMM);":";"")+".xml"
			//$printflow_export_fn:=$printflow_inbox_path+$docName
			
			C_TEXT:C284($elementRef)
			If (True:C214)  //root
				$elementRef:=DOM Create XML Ref:C861("PrintFlowData")
				ARRAY TEXT:C222($AttrName; 0)
				ARRAY TEXT:C222($AttrVal; 0)
				APPEND TO ARRAY:C911($AttrName; "Action")
				APPEND TO ARRAY:C911($AttrVal; "Update")
				
				APPEND TO ARRAY:C911($AttrName; "Sender")
				APPEND TO ARRAY:C911($AttrVal; "Administrator")
				
				APPEND TO ARRAY:C911($AttrName; "Machine")
				APPEND TO ARRAY:C911($AttrVal; "WIN-QAEA4RO0N0B")
				
				APPEND TO ARRAY:C911($AttrName; "ProgramName")
				APPEND TO ARRAY:C911($AttrVal; "PrintFlowXMLCsharp.exe  2.0.0.0")
				
				APPEND TO ARRAY:C911($AttrName; "Comment")
				APPEND TO ARRAY:C911($AttrVal; "Time and Impressions")
				
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
				If (Position:C15($costCtr; <>GLUERS)=0)
					APPEND TO ARRAY:C911($AttrVal; Substring:C12($jobFormSeq; 10))
				Else 
					$jobformSeqItem:=Substring:C12($jobFormSeq; 10)+"."+$jobitem
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
				APPEND TO ARRAY:C911($AttrVal; $status)
				APPEND TO ARRAY:C911($AttrName; "CostCenterCode")
				APPEND TO ARRAY:C911($AttrVal; $costCtr)
				APPEND TO ARRAY:C911($AttrName; "EndRunDate")  // StartRunDate   EndRunDate
				APPEND TO ARRAY:C911($AttrVal; $now)
				APPEND TO ARRAY:C911($AttrName; "EmployeeID")
				APPEND TO ARRAY:C911($AttrVal; <>zResp)
				APPEND TO ARRAY:C911($AttrName; "SplitNumber")
				APPEND TO ARRAY:C911($AttrVal; "1")
				//RunMinutes="60" CompletedQuantity="123"
				$numAttributes:=7
				$strMinutes:=String:C10(Int:C8($hours*60))
				If ($hours>0)
					APPEND TO ARRAY:C911($AttrName; "RunMinutes")
					APPEND TO ARRAY:C911($AttrVal; $strMinutes)
					$numAttributes:=$numAttributes+1
				End if 
				$strimpressions:=String:C10(Int:C8($impressions))
				If ($impressions>0)
					APPEND TO ARRAY:C911($AttrName; "CompletedQuantity")
					APPEND TO ARRAY:C911($AttrVal; $strimpressions)
					$numAttributes:=$numAttributes+1
				End if 
				
				
				Case of 
					: ($numAttributes=8)
						DOM SET XML ATTRIBUTE:C866($runref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7}; $AttrName{8}; $AttrVal{8})
						
					: ($numAttributes=9)
						DOM SET XML ATTRIBUTE:C866($runref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7}; $AttrName{8}; $AttrVal{8}; $AttrName{9}; $AttrVal{9})
						
					Else   //not going to be valid
						BEEP:C151
						BEEP:C151
						DOM SET XML ATTRIBUTE:C866($runref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})
						
				End case 
			End if   //run
			
			
			C_TEXT:C284($xmlvar)
			DOM EXPORT TO VAR:C863($elementRef; $xmlvar)
			CREATE RECORD:C68([PrintFlow_Msg_Queue:169])
			[PrintFlow_Msg_Queue:169]Created:2:=$now
			[PrintFlow_Msg_Queue:169]ModWho:4:=<>zResp
			[PrintFlow_Msg_Queue:169]EventSource:3:="Machine Log Btn c/c: "+$costCtr
			[PrintFlow_Msg_Queue:169]Sent:5:=0
			[PrintFlow_Msg_Queue:169]XML_text:6:=$xmlvar
			If (Position:C15($costCtr; <>GLUERS)=0)
				[PrintFlow_Msg_Queue:169]JobRef:7:=$jobFormSeq
			Else 
				[PrintFlow_Msg_Queue:169]JobRef:7:=$jobform+"."+$jobformSeqItem
			End if 
			SAVE RECORD:C53([PrintFlow_Msg_Queue:169])
			UNLOAD RECORD:C212([PrintFlow_Msg_Queue:169])
			
			//DOM EXPORT TO FILE($elementRef;$printflow_export_fn)
			DOM CLOSE XML:C722($elementRef)
			BEEP:C151
			
		End if   //something to send
		
	Else 
		zwStatusMsg("PrintFlow"; "Task has been marked as completed, MT not sent.")
	End if   //not completed task
	
End if 



