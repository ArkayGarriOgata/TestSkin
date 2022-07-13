//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/23/07, 11:02:32
// ----------------------------------------------------
// Method: MT_import_data_collected()  --> 
// Description
// import and load data from file deposited by Flex datacollection system
// ----------------------------------------------------

C_TEXT:C284($path; <>PATH_AMS_INBOX; $filename; $fullpath; $volumeRequired; $processedFolder)
C_TEXT:C284($t; $r)
C_BOOLEAN:C305($continue)
C_LONGINT:C283($i; $delimAt; $hit; $field_in_focus; $jobseq; $cc; $shift; $jobit; $date; $mr; $run; $good; $waste; $pc; $down; $downCat; $downCodeLength; $referid)
C_BLOB:C604($import)
ARRAY TEXT:C222($aJobforms; 0)

$t:=Char:C90(9)
$r:=Char:C90(13)
// ////uncomment next 4 to test
//◊PATH_AMS_INBOX:=""  `"Data_Collection:ams_inbox:"  `smb://192.168.3.30 set on Connection tab of DBA
//If (Length(◊PATH_AMS_INBOX)=0)
//◊PATH_AMS_INBOX:=Select folder("Select a source folder")
//End if 
// ////
$path:=<>PATH_AMS_INBOX

If (Length:C16($path)>0)  //test if path specified
	$volumeRequired:=$path
	$delimAt:=Position:C15(<>DELIMITOR; $volumeRequired)
	$volumeRequired:=Substring:C12($volumeRequired; 1; ($delimAt-1))  //=Data_Collection
	
	$continue:=util_MountNetworkDrive($volumeRequired)
	
	If ($continue)
		$processedFolder:=$path+"processed_files"
		If (Test path name:C476($processedFolder)#Is a folder:K24:2)
			CREATE FOLDER:C475($processedFolder)
		End if 
		$processedFolder:=$processedFolder+<>DELIMITOR
		
		DOCUMENT LIST:C474($path; $aDocuments)
		SORT ARRAY:C229($aDocuments; >)
		//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"START MT_import_data_collected, candidates = "+String(Size of array($aDocuments)))
		For ($i; 1; Size of array:C274($aDocuments))  //try to load each document that was found
			$filename:=$path+$aDocuments{$i}
			
			If (Position:C15("MachineTicket-"; $filename)>0)  //eligiable filenames will end in .txt
				//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"MT_import_data_collected processing "+$filename)
				//move the doc
				MOVE DOCUMENT:C540($filename; ($processedFolder+$aDocuments{$i}))
				//read the doc
				$filename:=$processedFolder+$aDocuments{$i}
				SET BLOB SIZE:C606($import; 0)
				DOCUMENT TO BLOB:C525($filename; $import)
				$numBytes:=BLOB size:C605($import)
				
				$field_in_focus:=1  //use this to move thru the buffer array
				
				$jobseq:=1  //ie $field_in_focus=1
				$cc:=2
				$shift:=3
				$jobit:=4
				$date:=5
				$mr:=6
				$run:=7
				$good:=8
				$waste:=9
				$pc:=10
				$down:=11
				$downCat:=12
				$downCodeLength:=2
				//$rate:=13
				//$mradj:=14
				//$runadj:=15
				//$formseq:=16
				//$timestamp:=17
				//$mr_code:=18
				//$sync:=19
				$referid:=13
				
				LIST TO ARRAY:C288("Downtime"; $aDTcode)
				COPY ARRAY:C226($aDTcode; $aDTdesc)
				For ($dt; 1; Size of array:C274($aDTcode))
					$aDTcode{$dt}:=Substring:C12($aDTcode{$dt}; 1; $downCodeLength)
				End for 
				
				ARRAY TEXT:C222($buffer; 20)
				For ($j; 1; Size of array:C274($buffer))
					$buffer{$j}:=""
				End for 
				$numReceived:=0
				$numExpected:=0
				
				For ($byte; 0; $numBytes)  //read the blob
					$ascii_code:=$import{$byte}
					
					Case of 
						: ($ascii_code=Tab:K15:37)  //end of field
							$field_in_focus:=$field_in_focus+1
							
						: ($ascii_code=Line feed:K15:40)  //dos ending
							//ignor
							
						: ($ascii_code=Carriage return:K15:38)  //end of row
							Case of 
								: ($buffer{1}="JobID")
									//skip the column headers row
									
								: (Length:C16($buffer{$mr})>0)  //this column is blank on first line of the file
									$numReceived:=$numReceived+1
									QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Reference_id:22=$buffer{$referid})
									If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
										CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])
									Else 
										utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "MT_import_data_collected updating "+$buffer{$referid})
									End if 
									
									[Job_Forms_Machine_Tickets:61]JobForm:1:=Substring:C12($buffer{$jobseq}; 1; 8)
									[Job_Forms_Machine_Tickets:61]CostCenterID:2:=Substring:C12($buffer{$cc}; 1; 4)
									[Job_Forms_Machine_Tickets:61]Shift:18:=Num:C11($buffer{$shift})
									[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=Num:C11($buffer{$jobit})
									[Job_Forms_Machine_Tickets:61]Sequence:3:=Num:C11(Substring:C12($buffer{$jobseq}; 10))
									[Job_Forms_Machine_Tickets:61]DateEntered:5:=Date:C102(Substring:C12($buffer{$date}; 6; 2)+"/"+Substring:C12($buffer{$date}; 9; 2)+"/"+Substring:C12($buffer{$date}; 1; 4))
									[Job_Forms_Machine_Tickets:61]MR_Act:6:=Num:C11($buffer{$mr})
									[Job_Forms_Machine_Tickets:61]Run_Act:7:=Num:C11($buffer{$run})
									[Job_Forms_Machine_Tickets:61]Good_Units:8:=Num:C11($buffer{$good})
									[Job_Forms_Machine_Tickets:61]Waste_Units:9:=Num:C11($buffer{$waste})
									[Job_Forms_Machine_Tickets:61]P_C:10:=Substring:C12($buffer{$pc}; 1; 1)+"!"
									[Job_Forms_Machine_Tickets:61]DownHrs:11:=Num:C11($buffer{$down})
									If (Substring:C12($buffer{$downCat}; 1; 2)#"0")
										$hit:=Find in array:C230($aDTcode; (Substring:C12($buffer{$downCat}; 1; 2)))
										If ($hit>-1)
											[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=$aDTdesc{$hit}
										Else 
											[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=Substring:C12($buffer{$downCat}; 1; 20)
										End if 
									End if 
									
									[Job_Forms_Machine_Tickets:61]Reference_id:22:=$buffer{$referid}
									
									[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=TSTimeStamp
									[Job_Forms_Machine_Tickets:61]MRcode:19:="flex"
									
									JobSeq_setAdjHours($buffer{$jobseq}; [Job_Forms_Machine_Tickets:61]CostCenterID:2)
									
									SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
									
									JML_setOperationDone([Job_Forms_Machine_Tickets:61]JobForm:1; [Job_Forms_Machine_Tickets:61]CostCenterID:2)  //• mlb - 7/30/02  16:18
									
									If (Find in array:C230($aJobforms; [Job_Forms_Machine_Tickets:61]JobForm:1)=-1)
										APPEND TO ARRAY:C911($aJobforms; [Job_Forms_Machine_Tickets:61]JobForm:1)
									End if 
									
									UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
									
								Else 
									//must be first row with content info
									$fileDate:=$buffer{1}
									$fileTime:=$buffer{2}
									$numExpected:=Num:C11($buffer{3})
									$firstRef:=$buffer{4}
									$lastRef:=$buffer{5}
									//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"MT_import_data_collected expects "+String($numExpected)+" records in "+$filename)
							End case 
							
							//setup for next row
							For ($j; 1; Size of array:C274($buffer))
								$buffer{$j}:=""
							End for 
							$field_in_focus:=1
							
						Else 
							$buffer{$field_in_focus}:=$buffer{$field_in_focus}+Char:C90($ascii_code)
					End case 
					
				End for 
				
				//If ($numExpected=$numReceived)  `2 for the header row and chk data
				utl_Logfile("PS_Exchange_Data_with_Flex.Log"; String:C10($numReceived)+" of "+String:C10($numExpected)+" from "+$filename)
				//Else 
				//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"MT_import_data_collected MISSING "+String($numExpected-$numReceived)+" RECORDS")
				//End if 
			End if   //ending with .txt
		End for 
		
		For ($i; 1; Size of array:C274($aJobforms))  //post process any jobs that where hit
			//do a rollup
			//similar to JOB_RollupActuals
			//set startdate
			//similar to Jobform_setStart_Date
			READ WRITE:C146([Job_Forms:42])
			READ ONLY:C145([Jobs:15])
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$aJobforms{$i})
			If (Records in selection:C76([Job_Forms:42])>0)
				If (Not:C34(Locked:C147([Job_Forms:42])))
					Case of 
						: ([Job_Forms:42]Status:6="Closed")
						: ([Job_Forms:42]Status:6="Complete")
						Else 
							[Job_Forms:42]Status:6:="WIP"
					End case 
					
					If ([Job_Forms:42]StartDate:10=!00-00-00!)  //• 8/4/98 cs insure that start date is set
						[Job_Forms:42]StartDate:10:=4D_Current_date
					Else   //•121498  Systems G3  make sure its earlier
						If ([Job_Forms:42]StartDate:10>4D_Current_date)
							[Job_Forms:42]StartDate:10:=4D_Current_date
						End if 
					End if 
					SAVE RECORD:C53([Job_Forms:42])
					UNLOAD RECORD:C212([Job_Forms:42])
				End if 
			End if 
		End for   //post processing
		
		//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"END MT_import_data_collected")
		
	Else   //failed to find mounted volume
		BEEP:C151
		utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "MT_import_data_collected failed to mount volume")
	End if 
	
Else   //failed to find path to save at
	BEEP:C151
	utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "MT_import_data_collected failed to find path")
End if 