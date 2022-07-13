//%attributes = {}
// -------
// Method: Job_ElapseTimeAnalysis   ( ) ->
// By: Mel Bohince @ 05/05/16, 08:17:30
// Description
// Determine process vs queue time for jobs, round to 16 hr days
//assuming no overlay of sequences, tail to head
// ----------------------------------------------------
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Finished_Goods_Transactions:33])

//find the jobs completed in a month
$hours_in_day:=15  //2 x 7.5

ARRAY TEXT:C222($aJobforms; 0)
$jobsCompleteFrom:=!2017-01-01!
$jobsCompleteTo:=!2017-12-31!
$jobsCompleteFrom:=Date:C102(Request:C163("Jobforms Completed From: "; String:C10($jobsCompleteFrom; Internal date short:K1:7); "Ok"; "Cancel"))
$jobsCompleteTo:=Date:C102(Request:C163(" To: "; String:C10($jobsCompleteTo; Internal date short:K1:7); "Ok"; "Cancel"))
If (ok=1)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create set
		
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15>=$jobsCompleteFrom; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15<=$jobsCompleteTo; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Comment:22="@KILLED@")
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJMLjobform)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aJMLjobform)
		CREATE SET:C116([Job_Forms:42]; "kills")
		
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18>=$jobsCompleteFrom; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Completed:18<=$jobsCompleteTo; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]cust_id:82#"00001")
		CREATE SET:C116([Job_Forms:42]; "targets")
		DIFFERENCE:C122("targets"; "kills"; "targets")
		USE SET:C118("targets")
		
		CLEAR SET:C117("targets")
		CLEAR SET:C117("kills")
		
	Else 
		
		QUERY BY FORMULA:C48([Job_Forms:42]; \
			(\
			([Job_Forms:42]Completed:18>=$jobsCompleteFrom)\
			 & ([Job_Forms:42]Completed:18<=$jobsCompleteTo)\
			 & ([Job_Forms:42]cust_id:82#"00001")\
			)\
			 & \
			(\
			([Job_Forms_Master_Schedule:67]DateComplete:15<$jobsCompleteFrom)\
			 | ([Job_Forms_Master_Schedule:67]DateComplete:15>$jobsCompleteTo)\
			 | ([Job_Forms_Master_Schedule:67]Comment:22#"@KILLED@")\
			)\
			)
		
		
		
	End if   // END 4D Professional Services : January 2019 
	
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobforms; [Job_Forms:42]NumberUp:26; $aNumUp)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	SORT ARRAY:C229($aJobforms; $aNumUp; >)
	
	C_LONGINT:C283($job; $numElements)
	$numElements:=Size of array:C274($aJobforms)
	
	//set up the tally buckets, note that the total is in days, the departments are in quarter hours
	ARRAY REAL:C219($aBudgetDays; $numElements)
	ARRAY REAL:C219($aBudSheeting; $numElements)
	ARRAY REAL:C219($aBudPrinting; $numElements)
	ARRAY REAL:C219($aBudStamping; $numElements)
	ARRAY REAL:C219($aBudBlanking; $numElements)
	ARRAY REAL:C219($aBudGluing; $numElements)
	ARRAY REAL:C219($aBudOther; $numElements)
	
	ARRAY REAL:C219($aActualDays; $numElements)
	ARRAY REAL:C219($aActGlueReadyDays; $numElements)
	ARRAY TEXT:C222($aLeadTime; $numElements)
	ARRAY REAL:C219($aActSheeting; $numElements)
	ARRAY REAL:C219($aActPrinting; $numElements)
	ARRAY REAL:C219($aActStamping; $numElements)
	ARRAY REAL:C219($aActBlanking; $numElements)
	ARRAY REAL:C219($aActGluing; $numElements)
	ARRAY REAL:C219($aActOther; $numElements)
	
	ARRAY REAL:C219($aQtySheeting; $numElements)
	ARRAY REAL:C219($aQtyPrinting; $numElements)
	ARRAY REAL:C219($aQtyStamping; $numElements)
	ARRAY REAL:C219($aQtyBlanking; $numElements)
	ARRAY REAL:C219($aQtyGluing; $numElements)
	ARRAY REAL:C219($aQtyOther; $numElements)
	
	ARRAY REAL:C219($aQueue; $numElements)  //none process days
	ARRAY REAL:C219($aElapse; $numElements)  //start to finish in days
	
	
	uThermoInit($numElements; "Measuring Jobs...")
	For ($job; 1; $numElements)
		//add their budget
		//into these buckets
		$aBudgetDays{$job}:=0
		$aBudSheeting{$job}:=0  //quarter hours
		$aBudPrinting{$job}:=0
		$aBudStamping{$job}:=0
		$aBudBlanking{$job}:=0
		$aBudGluing{$job}:=0
		$aBudOther{$job}:=0
		
		$sheeting:=0
		$printing:=0
		$stamping:=0
		$blanking:=0
		$gluing:=0
		$other:=0
		$elapse:=0
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$aJobforms{$job})
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $cc; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $mr; [Job_Forms_Machines:43]Planned_RunHrs:37; $run)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		//see uInit_CostCenterGroups
		For ($seq; 1; Size of array:C274($cc))
			$hours:=$mr{$seq}+$run{$seq}
			$elapse:=$elapse+$hours
			Case of   //tally by cc group
				: (Position:C15($cc{$seq}; <>SHEETERS)>0)
					$sheeting:=$sheeting+$hours
					
				: (Position:C15($cc{$seq}; <>PRESSES)>0)
					$printing:=$printing+$hours
					
				: (Position:C15($cc{$seq}; <>STAMPERS)>0) | (Position:C15($cc{$seq}; <>EMBOSSERS)>0)
					$stamping:=$stamping+$hours
					
				: (Position:C15($cc{$seq}; <>BLANKERS)>0)
					$blanking:=$blanking+$hours
					
				: (Position:C15($cc{$seq}; <>GLUERS)>0)
					$gluing:=$gluing+$hours
					
				Else 
					$other:=$other+$hours
			End case 
			
		End for   //each budget sequence
		
		
		$aBudSheeting{$job}:=util_roundUp($sheeting)
		$aBudPrinting{$job}:=util_roundUp($printing)
		$aBudStamping{$job}:=util_roundUp($stamping)
		$aBudBlanking{$job}:=util_roundUp($blanking)
		$aBudGluing{$job}:=util_roundUp($gluing)
		$aBudOther{$job}:=util_roundUp($other)
		$aBudgetDays{$job}:=Round:C94((($aBudSheeting{$job}+$aBudPrinting{$job}+$aBudStamping{$job}+$aBudBlanking{$job}+$aBudGluing{$job}+$aBudOther{$job})/$hours_in_day); 1)
		
		If ($aJobforms{$job}="95601.02")
			
		End if 
		//add their machine tickets
		//into these buckets
		$aActualDays{$job}:=0
		$aActSheeting{$job}:=0  //quarter hours
		$aActPrinting{$job}:=0
		$aActStamping{$job}:=0
		$aActBlanking{$job}:=0
		$aActGluing{$job}:=0
		$aActOther{$job}:=0
		
		$aQtySheeting{$job}:=0  //quarter hours
		$aQtyPrinting{$job}:=0
		$aQtyStamping{$job}:=0
		$aQtyBlanking{$job}:=0
		$aQtyGluing{$job}:=0
		$aQtyOther{$job}:=0
		
		$sheeting:=0
		$printing:=0
		$stamping:=0
		$blanking:=0
		$gluing:=0
		$other:=0
		
		$sheetingQty:=0
		$printingQty:=0
		$stampingQty:=0
		$blankingQty:=0
		$gluingQty:=0
		$otherQty:=0
		
		$elapse:=0
		
		$dateStarted:=<>MAGIC_DATE
		$dateEnded:=!00-00-00!
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$aJobforms{$job})
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $cc; [Job_Forms_Machine_Tickets:61]MR_Act:6; $mr; [Job_Forms_Machine_Tickets:61]DownHrs:11; $dt; [Job_Forms_Machine_Tickets:61]DownHrsCat:12; $dcat; [Job_Forms_Machine_Tickets:61]Run_Act:7; $run; [Job_Forms_Machine_Tickets:61]DateEntered:5; $date; [Job_Forms_Machine_Tickets:61]Good_Units:8; $good)
		REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
		//see uInit_CostCenterGroups
		For ($seq; 1; Size of array:C274($cc))
			//get the elapse  //find the start and end
			//see below, capturing from first print to last blank
			//If ($date{$seq}>($jobsCompleteFrom-360)) & ($date{$seq}<=($jobsCompleteTo+10))  //in a reasonable range
			//If ($date{$seq}<$dateStarted)
			//$dateStarted:=$date{$seq}
			//End if 
			//If ($date{$seq}>$dateEnded)
			//$dateEnded:=$date{$seq}
			//End if 
			//End if 
			
			$hours:=$mr{$seq}+$run{$seq}
			If ($dt{$seq}>0)
				If (Position:C15("lunch"; $dcat{$seq})=0)
					$hours:=$hours+$dt{$seq}
				End if 
			End if 
			
			$elapse:=$elapse+$hours
			Case of   //tally by cc group
				: (Position:C15($cc{$seq}; <>SHEETERS)>0)
					$sheeting:=$sheeting+$hours
					$sheetingQty:=$sheetingQty+$good{$seq}
					
				: (Position:C15($cc{$seq}; <>PRESSES)>0)
					$printing:=$printing+$hours
					$printingQty:=$printingQty+$good{$seq}
					//get the elapse  //find the start
					If ($date{$seq}>($jobsCompleteFrom-360)) & ($date{$seq}<=($jobsCompleteTo+10))  //in a reasonable range
						If ($date{$seq}<$dateStarted)
							$dateStarted:=$date{$seq}
						End if 
					End if 
					
					
				: (Position:C15($cc{$seq}; <>STAMPERS)>0) | (Position:C15($cc{$seq}; <>EMBOSSERS)>0)
					$stamping:=$stamping+$hours
					$stampingQty:=$stampingQty+$good{$seq}
					
				: (Position:C15($cc{$seq}; <>BLANKERS)>0)
					$blanking:=$blanking+$hours
					$blankingQty:=$blankingQty+$good{$seq}
					//get the elapse  //find the end
					If ($date{$seq}>($jobsCompleteFrom-360)) & ($date{$seq}<=($jobsCompleteTo+10))  //in a reasonable range
						If ($date{$seq}>$dateEnded)
							$dateEnded:=$date{$seq}
						End if 
					End if 
					
				: (Position:C15($cc{$seq}; <>GLUERS)>0)
					$gluing:=$gluing+$hours
					$gluingQty:=$gluingQty+$good{$seq}
					
				Else 
					$other:=$other+$hours
					$otherQty:=$otherQty+$good{$seq}
			End case 
			
		End for   //each budget sequence
		
		
		If ($dateStarted<<>MAGIC_DATE)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$aJobforms{$job}; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="ship")
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aShippedOn)
				SORT ARRAY:C229($aShippedOn; >)
				$aLeadTime{$job}:=String:C10($aShippedOn{1}-$dateStarted)
			Else 
				$aLeadTime{$job}:="N/S"
			End if 
		Else 
			$aLeadTime{$job}:="N/A"
		End if 
		
		
		If ($dateEnded>!00-00-00!) & ($dateStarted>!00-00-00!)
			$aElapse{$job}:=$dateEnded-$dateStarted
		Else 
			$aElapse{$job}:=0
		End if 
		
		$aActSheeting{$job}:=util_roundUp($sheeting)
		$aActPrinting{$job}:=util_roundUp($printing)
		$aActStamping{$job}:=util_roundUp($stamping)
		$aActBlanking{$job}:=util_roundUp($blanking)
		$aActGluing{$job}:=util_roundUp($gluing)
		$aActOther{$job}:=util_roundUp($other)
		
		$aQtySheeting{$job}:=Round:C94(($sheetingQty); -2)
		$aQtyPrinting{$job}:=Round:C94(($printingQty); -2)
		$aQtyStamping{$job}:=Round:C94(($stampingQty); -2)
		$aQtyBlanking{$job}:=Round:C94(($blankingQty); -2)
		$aQtyGluing{$job}:=Round:C94(($gluingQty); -2)
		$aQtyOther{$job}:=Round:C94(($otherQty); -2)
		
		
		$aActualDays{$job}:=Round:C94((($aActSheeting{$job}+$aActPrinting{$job}+$aActStamping{$job}+$aActBlanking{$job}+$aActGluing{$job}+$aActOther{$job})/$hours_in_day); 1)
		$aActGlueReadyDays{$job}:=Round:C94((($aActSheeting{$job}+$aActPrinting{$job}+$aActStamping{$job}+$aActBlanking{$job}+$aActOther{$job})/$hours_in_day); 1)
		
		$aQueue{$job}:=$aElapse{$job}-$aActualDays{$job}
		
		uThermoUpdate($job)
	End for 
	uThermoClose
	
	
	
	
	//report
	//$t:="  "
	//utl_LogIt ("init")
	//For ($job;1;$numElements)
	//utl_LogIt("---------------")
	//utl_LogIt ($aJobforms{$job}+$t+string($aBudgetDays{$job};"^^^0.0")+$t+string($aBudSheeting{$job};"^^^0.00")+$t+string($aBudPrinting{$job};"^^^0.00")+$t+string($aBudStamping{$job};"^^^0.00")+$t+string($aBudBlanking{$job};"^^^0.00")+$t+string($aBudGluing{$job};"^^^0.00")+$t+string($aBudOther{$job};"^^^0.00"))
	//utl_LogIt ("        "+$t+String($aActualDays{$job};"^^^0.0")+$t+String($aActSheeting{$job};"^^^0.00")+$t+String($aActPrinting{$job};"^^^0.00")+$t+String($aActStamping{$job};"^^^0.00")+$t+String($aActBlanking{$job};"^^^0.00")+$t+String($aActGluing{$job};"^^^0.00")+$t+String($aActOther{$job};"^^^0.00"))
	//end for
	//utl_LogIt ("show")
	
	C_TEXT:C284($title; $text; $docName)
	C_TIME:C306($docRef)
	$t:="\t"
	$r:="\r"
	$title:=""
	$text:=""
	$docName:="JobElapseAnalysis_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $title+"\r\r")
		
		$text:=$text+"JOB_FORM"+$t+"BUDGETED_DAYS"+$t+"ACTUAL_DAYS"+$t+"GLUE_READY_DAYS"+$t+"QUEUE_DAYS"+$t+"ELAPSE_DAYS"+$t+"LEAD_TIME"+$t+"BUD_SHEETING_HRS"+$t+"BUD_PRINTING_HRS"+$t+"BUD_STAMP_EMB_HRS"+$t+"BUD_BLANKING_HRS"+$t+"BUD_GLUING_HRS"+$t+"BUD_OTHER_HRS"+$t
		$text:=$text+"ACT_SHEETING_HRS"+$t+"ACT_PRINTING_HRS"+$t+"ACT_STAMP_EMB_HRS"+$t+"ACT_BLANKING_HRS"+$t+"ACT_GLUING_HRS"+$t+"ACT_OTHER_HRS"+$t
		$text:=$text+"SHEETING_QTY"+$t+"PRINTING_QTY"+$t+"STAMP_EMB_QTY"+$t+"BLANKING_QTY"+$t+"GLUING_QTY"+$t+"OTHER_QTY"+$t+"NUMUP"+$r
		
		For ($job; 1; $numElements)
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if 
			
			$text:=$text+$aJobforms{$job}+$t+String:C10($aBudgetDays{$job})+$t+String:C10($aActualDays{$job})+$t+String:C10($aActGlueReadyDays{$job})+$t+String:C10($aQueue{$job})+$t+String:C10($aElapse{$job})+$t+$aLeadTime{$job}+$t+String:C10($aBudSheeting{$job})+$t+String:C10($aBudPrinting{$job})+$t+String:C10($aBudStamping{$job})+$t+String:C10($aBudBlanking{$job})+$t+String:C10($aBudGluing{$job})+$t+String:C10($aBudOther{$job})+$t
			$text:=$text+String:C10($aActSheeting{$job})+$t+String:C10($aActPrinting{$job})+$t+String:C10($aActStamping{$job})+$t+String:C10($aActBlanking{$job})+$t+String:C10($aActGluing{$job})+$t+String:C10($aActOther{$job})+$t
			$text:=$text+String:C10($aQtySheeting{$job})+$t+String:C10($aQtyPrinting{$job})+$t+String:C10($aQtyStamping{$job})+$t+String:C10($aQtyBlanking{$job})+$t+String:C10($aQtyGluing{$job})+$t+String:C10($aQtyOther{$job})+$t+String:C10($aNumUp{$job})+$r
			
		End for 
		
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
		$err:=util_Launch_External_App($docName)
	End if 
	
End if   //ok, the dates

