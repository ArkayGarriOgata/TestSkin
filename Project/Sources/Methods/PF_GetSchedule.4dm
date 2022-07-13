//%attributes = {}
// -------
// Method: PF_GetSchedule   ( ) ->
// By: Mel Bohince @ 12/19/17, 07:45:10
// Description
// read in the published schedule from PF and overlay existing aMs schedule after backing up the current data
// ----------------------------------------------------
// assuming that they are a prioritized ordered list grouped by costcenter

READ WRITE:C146([ProductionSchedules:110])

C_TEXT:C284($printflow_volumn; $printflow_outbox_path; $path; $processed_folder; $printflow_export_fn; $print_flow_docpath; $newDocName; $tLine)
C_TIME:C306($docRef)
C_BOOLEAN:C305($err)

ARRAY TEXT:C222($aDocPaths; 0)


ARRAY TEXT:C222($aJobSequence; 0)
ARRAY TEXT:C222($aCostCtr; 0)
ARRAY TEXT:C222($aStart; 0)
ARRAY TEXT:C222($aFinish; 0)
C_TEXT:C284($runCode)

$err:=util_MountNetworkDrive("PrintFlow")

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
If (Find in array:C230($aVolumes; "PrintFlow")>-1)
	$printflow_volumn:="PrintFlow:"
	$printflow_outbox_path:=$printflow_volumn+"XmlOutbox:"  //this is what PF_connector expects
	If (Test path name:C476($printflow_outbox_path)#Is a folder:K24:2)
		CREATE FOLDER:C475($printflow_outbox_path)
	Else 
		ok:=1
	End if 
	
	If (OK=1)
		$processed_folder:=$printflow_outbox_path+"processed:"
		If (Test path name:C476($processed_folder)#Is a folder:K24:2)
			CREATE FOLDER:C475($processed_folder)
		Else 
			ok:=1
		End if 
		
		If (OK=1)
			$printflow_export_fn:="Schedule.txt"
			$print_flow_docpath:=$printflow_outbox_path+$printflow_export_fn
			If (Test path name:C476($print_flow_docpath)=Is a document:K24:1)  //lets go to work
				$newDocName:="Schedule_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".txt"
				MOVE DOCUMENT:C540($print_flow_docpath; $processed_folder+$newDocName)  //make room for the next one and be somewhat atomic
				If (Test path name:C476($processed_folder+$newDocName)=Is a document:K24:1)
					ok:=1
				Else 
					ok:=0
				End if 
				
			Else   //try later
				ok:=0
			End if 
			
		End if   //processed folder 
	End if   //outbox folder
	
	
Else 
	$printflow_export_path:=util_DocumentPath("get")
	$printflow_export_path:=Request:C163("Path (like-> PrintFlow:)"; $printflow_export_path; "Export"; "Cancel")
	$print_flow_doc:=Select document:C905($printflow_export_path; ".txt"; "Please open the latest PrintFlow schedule export:"; Use sheet window:K24:11; $aDocPaths)
	$newDocName:=$aDocPaths{1}
End if 



If (OK=1)
	
	$docRef:=Open document:C264($processed_folder+$newDocName; Read mode:K24:5)
	
	If ($docRef#?00:00:00?)
		
		RECEIVE PACKET:C104($docRef; $tLine; Char:C90(Line feed:K15:40))  //Get the first row.
		While (Length:C16($tLine)>0)
			util_TextParser(10; $tLine; Tab:K15:37; Carriage return:K15:38)
			$runCode:=util_TextParser(5)
			If (Position:C15("pt 1"; $runCode)>0)
				APPEND TO ARRAY:C911($aJobSequence; util_TextParser(1)+"."+util_TextParser(3))
				APPEND TO ARRAY:C911($aCostCtr; util_TextParser(4))
				APPEND TO ARRAY:C911($aStart; util_TextParser(6))
				APPEND TO ARRAY:C911($aFinish; util_TextParser(8))
			End if 
			
			RECEIVE PACKET:C104($docRef; $tLine; Char:C90(Line feed:K15:40))
		End while 
		
		CLOSE DOCUMENT:C267($docRef)
		
		//if import was successful, backup existing schedule, then overlay, retaining exisiting records if posible
		//backup
		C_LONGINT:C283($field; $table_number)
		C_TEXT:C284($xml_ref; $docName)
		$xml_ref:=DOM Create XML Ref:C861("settings-import-export")  //create a 'project' definition
		$table_number:=Table:C252(->[ProductionSchedules:110])
		DOM SET XML ATTRIBUTE:C866($xml_ref; "table_no"; $table_number; "format"; "4D"; "all_records"; True:C214)
		// Definition of fields to export
		For ($field; 1; Get last field number:C255($table_number))
			If (Is field number valid:C1000($table_number; $field))
				$elt:=DOM Create XML element:C865($xml_ref; "field"; "table_no"; $table_number; "field_no"; $field)
			End if 
		End for 
		
		$docName:="Prod_Schd_Bku_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".4ie"
		$path:=util_DocumentPath("get")
		ALL RECORDS:C47([ProductionSchedules:110])
		EXPORT DATA:C666(($path+$docName); $xml_ref)
		If (Ok=0)
			ALERT:C41("Error during export of table "+Table name:C256(110))
		End if 
		DOM CLOSE XML:C722($xml_ref)
		
		
		//mask the priortiy field to a touch can be detected
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([ProductionSchedules:110])
		Else 
			
			//you have all record on line 112
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		
		APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3:=999999)
		
		If (<>PF_SAVE_GLUE_SCHEDULE)  //optional
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Priority:48>0; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; PF_prepGlueSchedule("save"))
		End if 
		//make the changes
		
		C_LONGINT:C283($task; $numElements)
		$numElements:=Size of array:C274($aJobSequence)
		uThermoInit($numElements; "Processing Array")
		
		$currentCostCtr:=""
		For ($task; 2; $numElements)
			
			If ($currentCostCtr#$aCostCtr{$task})
				$priority:=10
				$currentCostCtr:=$aCostCtr{$task}
			Else 
				$priority:=$priority+10
			End if 
			
			If (Position:C15($aCostCtr{$task}; <>GLUERS)=0)
				
			Else   //handle gluing dif
				If (Length:C16($aJobSequence{$task})>12)
					//TRACE
				End if 
			End if 
			
			//If (Position($aCostCtr{$task};<>GLUERS)=0)//|(true)
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$aJobSequence{$task})
			If (Records in selection:C76([ProductionSchedules:110])=0)
				//sCriterion9:=$aJobSequence{$task}
				//NewJobSeq_sCriterion9
				CREATE RECORD:C68([ProductionSchedules:110])
				[ProductionSchedules:110]JobSequence:8:=$aJobSequence{$task}
				
				QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=Substring:C12($aJobSequence{$task}; 1; 12))
				RELATE ONE:C42([Job_Forms_Machines:43]JobForm:1)
				RELATE ONE:C42([Job_Forms:42]JobNo:2)
				[ProductionSchedules:110]Customer:11:=[Jobs:15]CustomerName:5
				[ProductionSchedules:110]Line:10:=[Jobs:15]Line:3
				[ProductionSchedules:110]Planned_MR:52:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
				[ProductionSchedules:110]Planned_Run:53:=[Job_Forms_Machines:43]Planned_RunHrs:37
				[ProductionSchedules:110]Planned_RunRate:54:=[Job_Forms_Machines:43]Planned_RunRate:36
				[ProductionSchedules:110]Planned_QtyGood:56:=[Job_Forms_Machines:43]Planned_Qty:10
				[ProductionSchedules:110]Planned_QtyWaste:55:=[Job_Forms_Machines:43]Planned_Waste:11
				$hrs:=[ProductionSchedules:110]Planned_MR:52+[ProductionSchedules:110]Planned_Run:53
				//[ProductionSchedules]Duration:=Time(Time string(($hrs*3600)))
				[ProductionSchedules:110]Info:13:=String:C10(Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15; 0))+"+"+String:C10(Round:C94([Job_Forms_Machines:43]Planned_RunHrs:37; 0))
				//$err:=Job_getPrevNextOperation ($aJobSequence{$task};->[ProductionSchedules]AllOperations)
				
			End if 
			[ProductionSchedules:110]CostCenter:1:=$aCostCtr{$task}
			//If ((Position([ProductionSchedules]CostCenter;<>EMBOSSERS)>0) | (Position([ProductionSchedules]CostCenter;<>STAMPERS)>0))
			//[ProductionSchedules]Name:=CostCtr_Description_Tweak (->[Job_Forms_Machines]Flex_field1)
			//Else 
			//[ProductionSchedules]Name:=[Cost_Centers]Description
			//End if 
			[ProductionSchedules:110]Priority:3:=$priority
			[ProductionSchedules:110]StartDate:4:=Date:C102(Substring:C12($aStart{$task}; 1; 10))
			[ProductionSchedules:110]StartTime:5:=Time:C179(Substring:C12($aStart{$task}; 12))
			[ProductionSchedules:110]EndDate:6:=Date:C102(Substring:C12($aFinish{$task}; 1; 10))
			[ProductionSchedules:110]EndTime:7:=Time:C179(Substring:C12($aFinish{$task}; 12))
			$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			$end:=TSTimeStamp([ProductionSchedules:110]EndDate:6; [ProductionSchedules:110]EndTime:7)
			[ProductionSchedules:110]DurationSeconds:9:=Time:C179(Time string:C180(($end-$start)))
			
			
			SAVE RECORD:C53([ProductionSchedules:110])
			
			If (<>PF_SAVE_GLUE_SCHEDULE)  //optional
				If (Position:C15($aCostCtr{$task}; <>GLUERS)>0)  //handle gluing dif
					If (Length:C16($aJobSequence{$task})>12)
						//TRACE
						$jobit:=Delete string:C232($aJobSequence{$task}; 9; 4)  //remove sequence number
						$jobit:=Substring:C12($jobit; 1; 11)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit)
						[Job_Forms_Items:44]Gluer:47:=$aCostCtr{$task}
						[Job_Forms_Items:44]Priority:48:=$priority
						[Job_Forms_Items:44]GlueEstimatedEnd:53:=TSTimeStamp(Date:C102(Substring:C12($aFinish{$task}; 1; 10)); Time:C179(Substring:C12($aFinish{$task}; 12)))
						SAVE RECORD:C53([Job_Forms_Items:44])
					End if   //good looking job seq
				End if   //gluer
			End if   //If (<>PF_SAVE_GLUE_SCHEDULE)  //optional
			
			uThermoUpdate($task)
		End for 
		uThermoClose
		
		//uConfirm ("The production schedule has been updated.";"Great";"Restore")
		//If (ok=0)  //restore prior state
		//ALERT("Sorry, not implemented yet, see database administrator to restore the last backup.")
		//End if 
		zwStatusMsg("PrintFlow"; "The production schedule has been updated.")
		utl_Logfile("PrintFlow"; "The production schedule has been updated.")
		
		
	Else 
		//ALERT("Schedule document couldn't be opened.")
		zwStatusMsg("PrintFlow"; "Schedule document couldn't be opened.")
		utl_Logfile("PrintFlow"; "Schedule document couldn't be opened.")
	End if 
	
End if   //selected file