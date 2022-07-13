//%attributes = {}
// Method: JOB_ProdPerformance   ( ) ->
// By: Mel Bohince @ 06/10/16, 11:33:26
// Description
// if seq is marked complete on machine ticket, gather totals for this seq
// and email a report to the Wheels
// ----------------------------------------------------
// Modified by: Mel Bohince (8/11/16) //auto ink calc may load fg record
// Modified by: Mel Bohince (8/24/16) remove the 02016. type jobs from the intial query
// Modified by: Mel Bohince (9/1/16) add total for sheets
// Modified by: Mel Bohince (4/13/20) put in on error, CREATE SELECTION FROM ARRAY([Job_Forms_Machines];$_updatedMachineRecs) can RT
// Modified by: Mel Bohince (10/9/20) remove , from string format arg so csv isn't complicated
// use PressPerf distribution list instead of override to jill and i


C_TIME:C306($wait_until)
C_DATE:C307($wait_date; $tomorrow)
C_BOOLEAN:C305($not_sent_yet; <>run_press_perf; $laminated)
C_TEXT:C284($r)
C_LONGINT:C283($delay_in_seconds; $i; $numElements; $minutes; $loops; <>press_perf_PID)
C_TEXT:C284($1)
$laminated:=False:C215

$wait_until:=?14:01:00?  //2pm
$wait_date:=4D_Current_date  //see line 70 for testing
$tomorrow:=Add to date:C393($wait_date; 0; 0; 1)

If (4d_Current_time>?15:20:00?)
	$not_sent_yet:=False:C215  //this is it for today
Else 
	$not_sent_yet:=True:C214
End if 

$minutes:=15
$loops:=0
$delay_in_seconds:=$minutes*60*60  //wake up every 15 minutes

If (Count parameters:C259=0)
	<>press_perf_PID:=Process number:C372("JOB_PressPerformance")
	If (<>press_perf_PID=0)  //not already running
		<>run_press_perf:=True:C214
		//If (Application type=4D Server )  `(Application type#4D Client )
		<>press_perf_PID:=New process:C317("JOB_ProdPerformance"; <>lMinMemPart; "JOB_ProdPerformance"; "init")
		If (False:C215)
			JOB_ProdPerformance
		End if 
		//End if 
	Else 
		If (Not:C34(<>fQuit4D))  // Added by: Mel Bohince (6/11/19) 
			uConfirm("JOB_ProdPerformance is already running on this client."; "Just Checking"; "Kill")
			If (ok=0)
				<>run_press_perf:=False:C215
			End if 
			
		Else   //help it die
			<>run_wms:=False:C215
		End if 
	End if 
	
Else   //init
	
	READ ONLY:C145([y_batches:10])
	READ ONLY:C145([Job_Forms_Machine_Tickets:61])
	READ ONLY:C145([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Machines:43])
	READ ONLY:C145([Finished_Goods:26])  // Modified by: Mel Bohince (8/11/16) //auto ink calc may load fg record
	
	utl_Logfile("PressPerf.Log"; "Started; waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
	
	While (Not:C34(<>fQuit4D)) & (<>run_press_perf)
		zwStatusMsg("PressPerf"; "Running...")
		$loops:=$loops+1
		If (4D_Current_date>$wait_date)  //its a new day
			$wait_date:=4D_Current_date
			$tomorrow:=Add to date:C393($wait_date; 0; 0; 1)
			$not_sent_yet:=True:C214
			utl_Logfile("PressPerf.Log"; "Focus date advanced to "+String:C10($wait_date))
		End if 
		
		If (4d_Current_time>=$wait_until) & ($not_sent_yet) & (<>run_press_perf)
			
			$lastOnErrorMethod:=Method called on error:C704
			ON ERR CALL:C155("eLogAnError")  // Modified by: Mel Bohince (4/13/20) 
			
			//If (Current user="Designer")  //doing some tracing on past date
			//$wait_date:=!09/19/2016!//!08/23/2016!
			//End if 
			
			//Get a list of completed press sequences for a day from 2pm to 2pm
			$dateMeasured:=$wait_date
			//$dateMeasured:=Date(Request("What date?";String(!05/27/2016!;Internal date short special);"Continue";"Cancel"))
			$timeCutOff:=?14:00:00?  //2pm
			
			//query will use the Machtick's timestamp, find the interval:
			$from:=TSTimeStamp(Add to date:C393($dateMeasured; 0; 0; -1); $timeCutOff)
			$to:=TSTimeStamp($dateMeasured; $timeCutOff)
			
			//machine ticks marked as completed during interval:
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]P_C:10="C"; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]JobForm:1#"020@")  //plant downtime considered separtely
			
			//see JOB_PressPerformancePrinting ($from;$to) below for the printing only email
			If (False:C215)  //only interested in printing:
				$press_ids:=txt_Trim(<>PRESSES)  //load all presses in an array for a build query below
				$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
				// ******* Verified  - 4D PS - January  2019 ******** you have false before
				
				QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser(1); *)
				For ($press; 2; $cnt_of_presses)
					QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser($press); *)
				End for 
				QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61])
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				//Here are the completed press sequences:
				SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobFormSeq:16; $aCompletedSequences)
			End if 
			
			//Here are the all completed sequences in range:
			DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]JobFormSeq:16; $aCompletedSequences)
			
			If (True:C214)  //now roll up on their budget records, save jobseq to set
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					CREATE EMPTY SET:C140([Job_Forms_Machines:43]; "updatedMachineRecs")
					
					
				Else 
					
					ARRAY LONGINT:C221($_updatedMachineRecs; 0)
					
					
				End if   // END 4D Professional Services : January 2019 
				C_LONGINT:C283($seq; $numElements)
				$numElements:=Size of array:C274($aCompletedSequences)
				uThermoInit($numElements; "Rolling up machine tickets...")
				For ($seq; 1; $numElements)
					
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=$aCompletedSequences{$seq})
					If (fLockNLoad(->[Job_Forms_Machines:43]; "no msg"))
						
						QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$aCompletedSequences{$seq})
						//init the fields
						[Job_Forms_Machines:43]Actual_MR_Hrs:24:=0
						[Job_Forms_Machines:43]Actual_RunHrs:40:=0
						[Job_Forms_Machines:43]Actual_Qty:19:=0
						[Job_Forms_Machines:43]Actual_Waste:20:=0
						[Job_Forms_Machines:43]Actual_RunRate:39:=0
						
						//do the rollup
						[Job_Forms_Machines:43]CostCenterID:4:=[Job_Forms_Machine_Tickets:61]CostCenterID:2  // set this to the actual cc used
						[Job_Forms_Machines:43]Actual_MR_Hrs:24:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
						[Job_Forms_Machines:43]Actual_RunHrs:40:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
						[Job_Forms_Machines:43]Actual_Qty:19:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
						[Job_Forms_Machines:43]Actual_Waste:20:=Sum:C1([Job_Forms_Machine_Tickets:61]Waste_Units:9)
						[Job_Forms_Machines:43]Downtime:21:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)  // Modified by: Mel Bohince (6/15/16) newly added field
						//calc runrate based on lessor of what was wanted or actual
						If ([Job_Forms_Machines:43]Planned_Qty:10<[Job_Forms_Machines:43]Actual_Qty:19)
							$rateQty:=[Job_Forms_Machines:43]Planned_Qty:10
						Else 
							$rateQty:=[Job_Forms_Machines:43]Actual_Qty:19
						End if 
						If ([Job_Forms_Machines:43]Actual_RunHrs:40#0) & ($rateQty#0)
							[Job_Forms_Machines:43]Actual_RunRate:39:=Round:C94($rateQty/[Job_Forms_Machines:43]Actual_RunHrs:40; -2)
						Else 
							[Job_Forms_Machines:43]Actual_RunRate:39:=0
						End if 
						
						DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]Operator:27; $aOperators)
						[Job_Forms_Machines:43]Operators:9:=util_textFromArray_implode(->$aOperators; "/")
						SAVE RECORD:C53([Job_Forms_Machines:43])
						
						// tag it so we can pull it for the report
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([Job_Forms_Machines:43]; "updatedMachineRecs")
							
						Else 
							
							APPEND TO ARRAY:C911($_updatedMachineRecs; Record number:C243([Job_Forms_Machines:43]))
							
						End if   // END 4D Professional Services : January 2019 
						
					End if   //locked
					
					If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
						
						UNLOAD RECORD:C212([Job_Forms_Machines:43])
						REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
						
					Else 
						
						REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
						
					End if   // END 4D Professional Services : January 2019 
					
					uThermoUpdate($seq)
				End for 
				uThermoClose
			End if   //true rollup
			
			//now make the report
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				USE SET:C118("updatedMachineRecs")
				CLEAR SET:C117("updatedMachineRecs")
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machines:43]; $_updatedMachineRecs)
				
				
			End if   // END 4D Professional Services : January 2019 
			
			$body:="<p>Details attached, summary below:</p>  <dl>"
			
			If (Records in selection:C76([Job_Forms_Machines:43])>0)
				
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4; >; [Job_Forms_Machines:43]JobSequence:8; >)
				$t:=","
				$r:="\r"
				$dateString:=String:C10($dateMeasured; Internal date short special:K1:4)
				$cc:=""
				$text:=""
				$totalSheets:=0  // Modified by: Mel Bohince (9/1/16) 
				$totalSheetsCC:=0  // Modified by: Mel Bohince (9/1/16) 
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
					
					While (Not:C34(End selection:C36([Job_Forms_Machines:43])))  //these are the machine seqs that were rolled up above
						
						If ([Job_Forms_Machines:43]CostCenterID:4#$cc)  //starting the next press
							$body:=$body+"<dt>"+[Job_Forms_Machines:43]CostCenterID:4+"</dt>"
							
							If (Length:C16($cc)>0)
								$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC)+$r+$r
							End if 
							$totalSheetsCC:=0
							$cc:=[Job_Forms_Machines:43]CostCenterID:4
							
							//see if plant charged downtime occurred on this machine in this time period
							QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16="020@"; *)  //dt charged to the plant
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Job_Forms_Machines:43]CostCenterID:4; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
							If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
								$dt:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
								$hours:=Time:C179(Time string:C180($dt*60*60))
								$timeStringShort:="   "+String:C10($hours; HH MM:K7:2)+" U"
								SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments)
								$comments:=util_textFromArray_implode(->$aComments; " // ")
								DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]Operator:27; $aOperators)
								$operators:=util_textFromArray_implode(->$aOperators; "/")
								$text:=$text+[Job_Forms_Machines:43]CostCenterID:4+$t+$operators+$t+"Arkay"+$t+"Factory"+$t+"Downtime"+$t+$timeStringShort+(8*($t+"0"))+String:C10($dt; "##0.00")+$t+$comments+$r
							End if 
							
						End if   //starting next press
						
						//sinful, not really cohesive to include these here, just dang convenient to make the ink and coating issues to wip$ now instead of later
						QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Machines:43]JobForm:1)
						If ([Job_Forms:42]JobType:33#"3 ASSEMBLY")  // Modified by: Mel Bohince (3/6/17) 
							RM_Issue_Auto_Ink
							If (Not:C34($laminated))  // Modified by: Mel Bohince (5/15/17) , wasn't testing 
								RM_Issue_Auto_Coating
							End if 
							RM_Issue_Auto_Corrugate  // Modified by: Mel Bohince (5/15/17) 
						End if 
						REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
						//sin no more
						
						$cust:=CUST_getName([Job_Forms:42]cust_id:82; "elc")
						$line:=[Job_Forms:42]CustomerLine:62
						
						$ttl_bud:=Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37; 2)
						$ttl_act:=Round:C94([Job_Forms_Machines:43]Actual_MR_Hrs:24+[Job_Forms_Machines:43]Actual_RunHrs:40+[Job_Forms_Machines:43]Downtime:21; 2)
						$ttl_var:=Round:C94($ttl_bud-$ttl_act; 2)
						$hours:=Time:C179(Time string:C180(Abs:C99($ttl_var)*60*60))
						
						$timeString:=String:C10($hours; Hour min:K7:4)
						$timeStringShort:=String:C10($hours; HH MM:K7:2)
						If ($ttl_var>=0)
							$timeStringShort:="   "+$timeStringShort+" F"
							$varString:=" Favorable"
						Else 
							$timeStringShort:="   "+$timeStringShort+" U"
							$varString:=" Unfavorable"
						End if 
						
						
						$sheetVar:=[Job_Forms_Machines:43]Planned_Qty:10-[Job_Forms_Machines:43]Actual_Qty:19
						$totalSheetsCC:=$totalSheetsCC+[Job_Forms_Machines:43]Actual_Qty:19
						$totalSheets:=$totalSheets+[Job_Forms_Machines:43]Actual_Qty:19
						Case of 
							: ($sheetVar<0)
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "####0")+" E"
								$qtyString:=String:C10(Abs:C99($sheetVar); "####0")+" Excess sheets "
							: ($sheetVar>0)
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "####0")+" S"
								$qtyString:=String:C10(Abs:C99($sheetVar); "####0")+" Sheets short "
							Else 
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "####0")+"  "
								$qtyString:=""
						End case 
						
						$body:=$body+"<dd>"+[Job_Forms_Machines:43]JobSequence:8+" for "+$cust+"/"+$line  //+" time variance was "+$timeString+$varString+$qtyString+", effective run rate was "+string([Job_Forms_Machines]Actual_RunRate)+"<br />"+"<br />"
						$body:=$body+"<ul>"
						$body:=$body+"<li>"+$timeString+$varString+"</li>"
						If (Length:C16($qtyString)>0)
							$body:=$body+"<li>"+$qtyString+"</li>"
						End if 
						$body:=$body+"<li>"+String:C10([Job_Forms_Machines:43]Actual_RunRate:39)+" effective runrate"+"</li>"
						$body:=$body+"</ul>"
						$body:=$body+"</dd>"
						
						//$text:=$text+[Job_Forms_Machines]CostCenterID+$t+[Job_Forms_Machines]Operators+$t+$dateString+$t+$cust+$t+$line+$t+[Job_Forms_Machines]JobSequence+$t+$timeStringShort+$t+String($ttl_bud;"#,##0.00")+$t+String($ttl_act;"#,##0.00")
						//$text:=$text+$t+String([Job_Forms_Machines]Planned_MR_Hrs-[Job_Forms_Machines]Actual_MR_Hrs;"##,##0.00")+$t+String([Job_Forms_Machines]Planned_MR_Hrs;"##,##0.00")+$t+String([Job_Forms_Machines]Actual_MR_Hrs;"##,##0.00")
						//$text:=$text+$t+String([Job_Forms_Machines]Planned_RunHrs-[Job_Forms_Machines]Actual_RunHrs;"##,##0.00")+$t+String([Job_Forms_Machines]Planned_RunHrs;"##,##0.00")+$t+String([Job_Forms_Machines]Actual_RunHrs;"##,##0.00")
						//$text:=$text+$t+String([Job_Forms_Machines]Actual_RunRate-[Job_Forms_Machines]Planned_RunRate;"##,##0")+$t+String([Job_Forms_Machines]Planned_RunRate;"##,##0")+$t+String([Job_Forms_Machines]Actual_RunRate;"##,##0")
						//$text:=$text+$t+String([Job_Forms_Machines]Actual_Qty-[Job_Forms_Machines]Planned_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Planned_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Actual_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Downtime;"##0.00")
						
						$text:=$text+[Job_Forms_Machines:43]CostCenterID:4+$t+[Job_Forms_Machines:43]Operators:9+$t+$cust+$t+$line+$t+[Job_Forms_Machines:43]JobSequence:8+$t+$timeStringShort+$t+String:C10($ttl_bud; "#,##0.00")+$t+String:C10($ttl_act; "#,##0.00")
						$text:=$text+$t+String:C10([Job_Forms_Machines:43]Planned_MR_Hrs:15; "####0.00")+$t+String:C10([Job_Forms_Machines:43]Actual_MR_Hrs:24; "####0.00")
						$text:=$text+$t+String:C10([Job_Forms_Machines:43]Planned_RunHrs:37; "####0.00")+$t+String:C10([Job_Forms_Machines:43]Actual_RunHrs:40; "####0.00")
						$text:=$text+$t+String:C10([Job_Forms_Machines:43]Actual_Qty:19; "######0")+$t+String:C10([Job_Forms_Machines:43]Downtime:21; "##0.00")
						
						
						If ([Job_Forms_Machines:43]Downtime:21>0)  //look for comments
							QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=[Job_Forms_Machines:43]JobSequence:8; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
							SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments)
							$comments:=util_textFromArray_implode(->$aComments; " // ")
							$text:=$text+(1*$t)+$comments+$r
						Else 
							$text:=$text+$r
						End if 
						
						NEXT RECORD:C51([Job_Forms_Machines:43])
					End while 
					
				Else 
					SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; \
						[Job_Forms_Machines:43]JobForm:1; $_JobForm; \
						[Job_Forms_Machines:43]Planned_MR_Hrs:15; $_Planned_MR_Hrs; \
						[Job_Forms_Machines:43]Planned_RunHrs:37; $_Planned_RunHrs; \
						[Job_Forms_Machines:43]Actual_MR_Hrs:24; $_Actual_MR_Hrs; \
						[Job_Forms_Machines:43]Actual_RunHrs:40; $_Actual_RunHrs; \
						[Job_Forms_Machines:43]Actual_RunRate:39; $_Actual_RunRate; \
						[Job_Forms_Machines:43]Downtime:21; $_Downtime; \
						[Job_Forms_Machines:43]Planned_Qty:10; $_Planned_Qty; \
						[Job_Forms_Machines:43]Actual_Qty:19; $_Actual_Qty; \
						[Job_Forms_Machines:43]JobSequence:8; $_JobSequence; \
						[Job_Forms_Machines:43]Operators:9; $_Operators)
					
					$i:=1
					$n:=Size of array:C274($_Operators)+1
					While ($i<$n)  //these are the machine seqs that were rolled up above
						
						If ($_CostCenterID{$i}#$cc)  //starting the next press
							$body:=$body+"<dt>"+$_CostCenterID{$i}+"</dt>"
							
							If (Length:C16($cc)>0)
								$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC; "######0")+$r+$r
							End if 
							$totalSheetsCC:=0
							$cc:=$_CostCenterID{$i}
							
							//see if plant charged downtime occurred on this machine in this time period
							QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16="020@"; *)  //dt charged to the plant
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=$_CostCenterID{$i}; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
							If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
								$dt:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
								$hours:=Time:C179(Time string:C180($dt*60*60))
								$timeStringShort:="   "+String:C10($hours; HH MM:K7:2)+" U"
								SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments)
								$comments:=util_textFromArray_implode(->$aComments; " // ")
								DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]Operator:27; $aOperators)
								$operators:=util_textFromArray_implode(->$aOperators; "/")
								$text:=$text+$_CostCenterID{$i}+$t+$operators+$t+"Arkay"+$t+"Factory"+$t+"Downtime"+$t+$timeStringShort+(8*($t+"0"))+String:C10($dt; "##0.00")+$t+$comments+$r
							End if 
							
						End if   //starting next press
						
						//sinful, not really cohesive to include these here, just dang convenient to make the ink and coating issues to wip$ now instead of later
						QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$_JobForm{$i})
						If ([Job_Forms:42]JobType:33#"3 ASSEMBLY")  // Modified by: Mel Bohince (3/6/17) 
							RM_Issue_Auto_Ink
							If (Not:C34($laminated))  // Modified by: Mel Bohince (5/15/17) , wasn't testing 
								RM_Issue_Auto_Coating
							End if 
							RM_Issue_Auto_Corrugate  // Modified by: Mel Bohince (5/15/17) 
						End if 
						REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
						//sin no more
						
						$cust:=CUST_getName([Job_Forms:42]cust_id:82; "elc")
						$line:=[Job_Forms:42]CustomerLine:62
						
						$ttl_bud:=Round:C94($_Planned_MR_Hrs{$i}+$_Planned_RunHrs{$i}; 2)
						$ttl_act:=Round:C94($_Actual_MR_Hrs{$i}+$_Actual_RunHrs{$i}+$_Downtime{$i}; 2)
						$ttl_var:=Round:C94($ttl_bud-$ttl_act; 2)
						$hours:=Time:C179(Time string:C180(Abs:C99($ttl_var)*60*60))
						
						$timeString:=String:C10($hours; Hour min:K7:4)
						$timeStringShort:=String:C10($hours; HH MM:K7:2)
						If ($ttl_var>=0)
							$timeStringShort:="   "+$timeStringShort+" F"
							$varString:=" Favorable"
						Else 
							$timeStringShort:="   "+$timeStringShort+" U"
							$varString:=" Unfavorable"
						End if 
						
						
						$sheetVar:=$_Planned_Qty{$i}-$_Actual_Qty{$i}
						$totalSheetsCC:=$totalSheetsCC+$_Actual_Qty{$i}
						$totalSheets:=$totalSheets+$_Actual_Qty{$i}
						Case of 
							: ($sheetVar<0)
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" E"
								$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Excess sheets "
							: ($sheetVar>0)
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" S"
								$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Sheets short "
							Else 
								$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+"  "
								$qtyString:=""
						End case 
						
						$body:=$body+"<dd>"+$_JobSequence{$i}+" for "+$cust+"/"+$line  //+" time variance was "+$timeString+$varString+$qtyString+", effective run rate was "+string([Job_Forms_Machines]Actual_RunRate)+"<br />"+"<br />"
						$body:=$body+"<ul>"
						$body:=$body+"<li>"+$timeString+$varString+"</li>"
						If (Length:C16($qtyString)>0)
							$body:=$body+"<li>"+$qtyString+"</li>"
						End if 
						$body:=$body+"<li>"+String:C10($_Actual_RunRate{$i})+" effective runrate"+"</li>"
						$body:=$body+"</ul>"
						$body:=$body+"</dd>"
						$text:=$text+$_CostCenterID{$i}+$t+$_Operators{$i}+$t+$cust+$t+$line+$t+$_JobSequence{$i}+$t+$timeStringShort+$t+String:C10($ttl_bud; "#,##0.00")+$t+String:C10($ttl_act; "#,##0.00")
						$text:=$text+$t+String:C10($_Planned_MR_Hrs{$i}; "####0.00")+$t+String:C10($_Actual_MR_Hrs{$i}; "####0.00")
						$text:=$text+$t+String:C10($_Planned_RunHrs{$i}; "####0.00")+$t+String:C10($_Actual_RunHrs{$i}; "####0.00")
						$text:=$text+$t+String:C10($_Actual_Qty{$i}; "######0")+$t+String:C10($_Downtime{$i}; "##0.00")
						
						
						If ($_Downtime{$i}>0)  //look for comments
							QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$_JobSequence{$i}; *)
							QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
							SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments)
							$comments:=util_textFromArray_implode(->$aComments; " // ")
							$text:=$text+(1*$t)+$comments+$r
						Else 
							$text:=$text+$r
						End if 
						
						$i:=$i+1
						
					End while 
					
				End if   // END 4D Professional Services : January 2019 
				
				$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC; "######0")+$r+$r
				$text:=$text+"REPORT TOTAL"+("\t"*12)+String:C10($totalSheets; "######0")+$r
				$body:=$body+"</dl>"
				
				C_TEXT:C284($title; $text; $docName)
				C_TIME:C306($docRef)
				$subject:="Production Performance "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
				$title:=$subject
				//If (Length($text)>0)
				//$headings:="PRESS"+$t+"OPERATOR"+$t+"DATE"+$t+"CUSTOMER"+$t+"LINE"+$t+"JOB SEQUENCE"+$t+"TTL TIME VAR"+$t+"TTL BUD"+$t+"TTL ACT"
				//$headings:=$headings+$t+"MR VAR"+$t+"BUD MR"+$t+"ACT MR"
				//$headings:=$headings+$t+"RUN VAR"+$t+"BUD RUN"+$t+"ACT RUN"
				//$headings:=$headings+$t+"RATE VAR"+$t+"BUD RATE"+$t+"ACT RATE"
				//$headings:=$headings+$t+"SHEET VAR"+$t+"BUD SHEET"+$t+"ACT SHEET"
				//$headings:=$headings+$t+"DOWNTIME"+$t+"COMMENTS"+$r
				//$text:=$headings+$text
				//End if 
				
				If (Length:C16($text)>0)
					$headings:="PRESS"+$t+"OPERATOR"+$t+"CUSTOMER"+$t+"LINE"+$t+"JOB SEQUENCE"+$t+"VARIANCE"+$t+"HRS BUD"+$t+"HRS ACT"
					$headings:=$headings+$t+"BUD MR"+$t+"ACT MR"
					$headings:=$headings+$t+"BUD RUN"+$t+"ACT RUN"
					$headings:=$headings+$t+"SHEETS"
					$headings:=$headings+$t+"DT"+$t+"COMMENTS"+$r
					$text:=$headings+$text
				End if 
				$docName:="Prod_Perf_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
				$subject:="Production Performance "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
				$docRef:=util_putFileName(->$docName)
				
				If ($docRef#?00:00:00?)
					SEND PACKET:C103($docRef; $title+"\r\r")
					
					If (Length:C16($text)>25000)
						SEND PACKET:C103($docRef; $text)
						$text:=""
					End if 
					
					SEND PACKET:C103($docRef; $text)
					SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
					CLOSE DOCUMENT:C267($docRef)
					
					//$err:=util_Launch_External_App ($docName)
				End if 
				
				$preheader:="Budget vs. Actual for printing sequences completed in the past 24 hours."
				
				$distributionList:=Batch_GetDistributionList("PressPerf")
				//limit distro until approved
				// Modified by: Mel Bohince (8/30/21) 
				//$distributionList:="jill.cook@arkay.com"+$t+"mel.bohince@arkay.com"+$t  //+"paul.Ladino@arkay.com"+$t
				
				//Email_html_body ($subject;$preheader;$body;500;$distributionList;$docName)//far too confusing to mgmt to summarize data
				$body2:="Budget vs. Actual for production sequences completed in the past 24 hours. Open attached with Excel."
				EMAIL_Sender($subject; ""; $body2; $distributionList; $docName)
				util_deleteDocument($docName)
				
				REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				REDUCE SELECTION:C351([Job_Forms:42]; 0)
				
				JOB_PressPerformance($from; $to)
				
			End if   //something to report
			
			$not_sent_yet:=False:C215  //this is it for today
			
			ON ERR CALL:C155("$lastOnErrorMethod")
			
		End if   //time to run
		
		zwStatusMsg("PressPerf"; "Delaying for "+String:C10($minutes)+" minutes")
		DELAY PROCESS:C323(Current process:C322; $delay_in_seconds)  //take a nap
		
	End while 
	utl_Logfile("PressPerf.Log"; "ENDED loops:"+String:C10($loops))
End if 







