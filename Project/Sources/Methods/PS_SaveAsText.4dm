//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/17/07, 13:57:30
// ----------------------------------------------------
// Method: PS_SaveAsText()  --> 
// Description
// create a snapshot to send to Flex
// ----------------------------------------------------

C_TEXT:C284($path; <>PATH_FLEX_INBOX; $filename; $fullpath; $volumeRequired)
C_TEXT:C284($t; $r)
C_LONGINT:C283($i; $delimAt)
C_BOOLEAN:C305($continue)

$t:=Char:C90(9)
$r:=Char:C90(13)

ON ERR CALL:C155("e_file_io_error")  // was getting a hanging error dialog periodically about file not existing
//◊PATH_FLEX_INBOX:="Data_Collection:flex_inbox:"  `smb://192.168.3.30 set on Connection tab of DBA
//If (Length(◊PATH_FLEX_INBOX)=0)
//◊PATH_FLEX_INBOX:=Select folder("Select a destination folder")
//End if 
$path:=<>PATH_FLEX_INBOX
//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"START PS_SaveAsText")
If (Length:C16($path)>0)  //test if path specified
	$volumeRequired:=$path
	$delimAt:=Position:C15(<>DELIMITOR; $volumeRequired)
	$volumeRequired:=Substring:C12($volumeRequired; 1; ($delimAt-1))  //=Data_Collection
	
	$continue:=util_MountNetworkDrive($volumeRequired)
	
	If ($continue)
		$filename:="ams-production-schedule.txt"
		$fullpath:=$path+$filename
		util_deleteDocument($fullpath)
		
		$docRef:=Create document:C266($fullpath)
		If (ok=1)
			CUT NAMED SELECTION:C334([ProductionSchedules:110]; "whileSaving")
			$readonly_state:=Read only state:C362([ProductionSchedules:110])
			READ ONLY:C145([ProductionSchedules:110])
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8#"Blocked"; *)  //do we want the completed items?
			QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]JobSequence:8#"")
			$numRecs:=Records in selection:C76([ProductionSchedules:110])
			
			tText:=String:C10(4D_Current_date; Internal date short:K1:7)+$t+String:C10(4d_Current_time; HH MM SS:K7:1)+$t+String:C10($numRecs)+$t+"records to follow excluding 1st row as control header and 2nd row as column names"+$r
			tText:=tText+"PS.JobSequence"+$t+"JL.PART"+$t+"JL.NAME"+$t+"PS.Line"+$t+"PS.Customer"+$t+"PR.SEQ"+$t+"PR.CLASS"+$t+"PR.ASSET"+$t+"PS.Good+Waste"+$t+"PS.Planned_QtyGood"+$t+"PS.Planned_MR"+$t+"PS.Planned_QtyWaste"+$t+"PS.Planned_Run"+$t+"PS.Planned_QtyGood"+$t+"PR.TDWNDUR"+$t+"PR.TDWNQTY"+$r
			//uThermoInit ($numRecs;"Exporting to "+$fullpath)
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For ($i; 1; $numRecs)
					If (Length:C16(tText)>24000)  //empty my buffer
						SEND PACKET:C103($docRef; tText)
						tText:=""
					End if 
					tText:=tText+[ProductionSchedules:110]JobSequence:8+$t+"1"+$t+""+$t+[ProductionSchedules:110]Line:10+$t+[ProductionSchedules:110]Customer:11+$t+""+$t+"Area"+$t+"Press Area"+$t+String:C10(([ProductionSchedules:110]Planned_QtyWaste:55+[ProductionSchedules:110]Planned_QtyGood:56))+$t+String:C10([ProductionSchedules:110]Planned_QtyGood:56)+$t+String:C10([ProductionSchedules:110]Planned_MR:52)+$t+String:C10([ProductionSchedules:110]Planned_QtyWaste:55)+$t+String:C10([ProductionSchedules:110]Planned_Run:53)+$t+String:C10([ProductionSchedules:110]Planned_QtyGood:56)+$t+""+$t+""+$r
					NEXT RECORD:C51([ProductionSchedules:110])
					//uThermoUpdate ($i)
				End for 
				
				
			Else 
				
				ARRAY TEXT:C222($_JobSequence; 0)
				ARRAY TEXT:C222($_Line; 0)
				ARRAY TEXT:C222($_Customer; 0)
				ARRAY LONGINT:C221($_Planned_QtyWaste; 0)
				ARRAY LONGINT:C221($_Planned_QtyGood; 0)
				ARRAY REAL:C219($_Planned_MR; 0)
				ARRAY REAL:C219($_Planned_Run; 0)
				
				SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $_JobSequence; \
					[ProductionSchedules:110]Line:10; $_Line; \
					[ProductionSchedules:110]Customer:11; $_Customer; \
					[ProductionSchedules:110]Planned_QtyWaste:55; $_Planned_QtyWaste; \
					[ProductionSchedules:110]Planned_QtyGood:56; $_Planned_QtyGood; \
					[ProductionSchedules:110]Planned_MR:52; $_Planned_MR; \
					[ProductionSchedules:110]Planned_Run:53; $_Planned_Run)
				
				For ($i; 1; $numRecs)
					If (Length:C16(tText)>24000)  //empty my buffer
						SEND PACKET:C103($docRef; tText)
						tText:=""
					End if 
					tText:=tText+$_JobSequence{$i}+$t+"1"+$t+""+$t+\
						$_Line{$i}+$t+\
						$_Customer{$i}+$t+""+$t+"Area"+$t+"Press Area"+$t+\
						String:C10(($_Planned_QtyWaste{$i}+$_Planned_QtyGood{$i}))+$t+\
						String:C10($_Planned_QtyGood{$i})+$t+\
						String:C10($_Planned_MR{$i})+$t+\
						String:C10($_Planned_QtyWaste{$i})+$t+\
						String:C10($_Planned_Run{$i})+$t+\
						String:C10($_Planned_QtyGood{$i})+$t+""+$t+""+$r
					
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 
			//uThermoClose 
			SEND PACKET:C103($docRef; tText)
			tText:=""
			
			CLOSE DOCUMENT:C267($docRef)
			If (Not:C34($readonly_state))
				READ WRITE:C146([ProductionSchedules:110])
			End if 
			USE NAMED SELECTION:C332("whileSaving")
			utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "PS_SaveAsText sent "+String:C10($numRecs)+" records")
			
			$i:=Get document size:C479($fullpath)
			If ($i<50)
				utl_Logfile("PS_Exchange_Data_with_Flex.Log"; $fullpath+" appears to be empty")
			End if 
			
		Else   //failed to create file, write to logfile
			BEEP:C151
			utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "PS_SaveAsText failed to create file")
		End if 
		
	Else   //failed to find mounted volume
		BEEP:C151
		utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "PS_SaveAsText failed to find mounted volume")
	End if 
	
Else   //failed to find path to save at
	BEEP:C151
End if 
//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"END PS_SaveAsText")
ON ERR CALL:C155("")