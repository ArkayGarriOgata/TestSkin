//%attributes = {}
// --------
// Method: Job_WIP_Kanban   ({"email"} ) ->
// By: Mel Bohince @ 05/09/16, 08:22:38
// Description
// report on where in the wip process each job is
// called by Batch_Runner and btn on job palette
// ----------------------------------------------------
// Modified by: Mel Bohince (5/21/16) add route mnemonic to output
// Modified by: Mel Bohince (5/31/16) Sort by department based on thru-put dollars
// Modified by: Mel Bohince (6/2/16) Add thru-put per M sheets
// Modified by: Mel Bohince (6/10/16) look for complete flag before advancing the wip sheets
// Modified by: Mel Bohince (6/17/16) added jobLastTouch to see how long in current queue
// Modified by: Mel Bohince (8/11/16) added $nextseq
// Modified by: Mel Bohince (8/24/16) added assignment of Thruput to new [ProductionSchedules]ThruPutValueOfJob field and TP button on schedule
// Modified by: Mel Bohince (2/12/20) change from .xls to .csv
C_TEXT:C284($1; $distributionList; $nextSeq)  //send as email if param
C_TEXT:C284($delim)  // Modified by: Mel Bohince (2/12/20) change from .xls to .csv
$delim:=","
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Raw_Materials:21])
READ WRITE:C146([ProductionSchedules:110])
//reset the thru put sort field
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78#-1)
APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78:=-1)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([ProductionSchedules:110])
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
Else 
	
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
End if   // END 4D Professional Services : January 2019 

//see qryJobsInWIP
QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18=!00-00-00!; *)  //still in production
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10#!00-00-00!; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]cust_id:82#"00001"; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Closed")

SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobforms; [Job_Forms:42]PlnnerReleased:59; $aPlnReleased; [Job_Forms:42]EstGrossSheets:27; $aGrossSheets; [Job_Forms:42]QtyYield:30; $aCartonQty; [Job_Forms:42]cust_id:82; $aJobCust; [Job_Forms:42]CustomerLine:62; $aJobLine; [Job_Forms:42]JobType:33; $aJobType)  //[Job_Forms]ProducedQty
REDUCE SELECTION:C351([Job_Forms:42]; 0)
//SORT ARRAY($aJobforms;$aPlnReleased;$aGrossSheets;$aCartonQty;>)//don't sort by job, below will sort by department

C_LONGINT:C283($job; $numElements)
$numElements:=Size of array:C274($aJobforms)
ARRAY TEXT:C222($aOutput; 0)  //the output'd array, appended as neeeded
ARRAY TEXT:C222($aJobData; $numElements)  //used to collect data about the job
ARRAY LONGINT:C221($aJobTP; $numElements)  //used to hold tp for the job

//utl_LogIt ("JOBFORM\t"+"FIRST_SHIP\t"+"TP$\t"+"WIP$"+"STOCK-RECD\t"+"PRINTING\t"+"STAMPING\t"+"EMBOSSING\t"+"LAMINATING\t"+"OTHER\t"+"BLANKING\t"+"GLUEING\t"

//hash tables, KVP, for each department so that they can be sorted after populated
ARRAY TEXT:C222($aJobSheeter; 0)
ARRAY TEXT:C222($aJobPrinting; 0)
ARRAY TEXT:C222($aJobStamping; 0)
ARRAY TEXT:C222($aJobEmbossing; 0)
ARRAY TEXT:C222($aJobLaminating; 0)
ARRAY TEXT:C222($aJobBlanking; 0)
ARRAY TEXT:C222($aJobGlueing; 0)
ARRAY TEXT:C222($aJobIsGlueing; 0)
ARRAY TEXT:C222($aJobOther; 0)

// Modified by: Mel Bohince (8/10/16) capture the sequences so they can be touched on production schedule
//ARRAY TEXT($aSeqSheeter;0)
//ARRAY TEXT($aSeqPrinting;0)
//ARRAY TEXT($aSeqStamping;0)
//ARRAY TEXT($aSeqEmbossing;0)
//ARRAY TEXT($aSeqLaminating;0)
//ARRAY TEXT($aSeqBlanking;0)
//ARRAY TEXT($aSeqGlueing;0)
//ARRAY TEXT($aSeqIsGlueing;0)
//ARRAY TEXT($aSeqOther;0)
// Modified by: Mel Bohince (8/10/16) end

ARRAY LONGINT:C221($aQueSheeter; 0)
ARRAY LONGINT:C221($aQuePrinting; 0)
ARRAY LONGINT:C221($aQueStamping; 0)
ARRAY LONGINT:C221($aQueEmbossing; 0)
ARRAY LONGINT:C221($aQueLaminating; 0)
ARRAY LONGINT:C221($aQueBlanking; 0)
ARRAY LONGINT:C221($aQueGlueing; 0)
ARRAY LONGINT:C221($aIsGlueing; 0)
ARRAY LONGINT:C221($aQueOther; 0)

ARRAY LONGINT:C221($aThruPutSheeter; 0)
ARRAY LONGINT:C221($aThruPutPrinting; 0)
ARRAY LONGINT:C221($aThruPutStamping; 0)
ARRAY LONGINT:C221($aThruPutEmbossing; 0)
ARRAY LONGINT:C221($aThruPutLaminating; 0)
ARRAY LONGINT:C221($aThruPutBlanking; 0)
ARRAY LONGINT:C221($aThruPutGlueing; 0)
ARRAY LONGINT:C221($aThruPutIsGlueing; 0)
ARRAY LONGINT:C221($aThruPutOther; 0)


//for each job in wip, get some descriptive data, then determine which department the sheets have advanced 
uThermoInit($numElements; "Measuring Jobs...")
For ($job; 1; $numElements)
	$nextSeq:=""  // Modified by: Mel Bohince (8/11/16) 
	//grab some readiness flags
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$aJobforms{$job})
	
	If (False:C215)  // these are just flags indicating if closing was met, stock was rec'd, and if planner released the job; doesn't look like the give a shit
		$readyForProduction:=""
		
		If ([Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
			$readyForProduction:="c"
		End if 
		If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
			$readyForProduction:=$readyForProduction+"s"
		End if 
		If ($aPlnReleased{$job}=!00-00-00!)
			$readyForProduction:=$readyForProduction+"p"
		End if 
	End if   //flags for readiness
	
	If (True:C214)  //calc wip value based solely no r/m issued to the job
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$aJobforms{$job}; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$wip:=Round:C94((Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10))*-1; 0)
		Else 
			$wip:=0
		End if 
	End if   //wip value
	
	If (True:C214)  //get the routing into $mnemonic and load the routing in arrays for c/c and sequence
		//$mnemonic:=Job_Routing ("init";$aJobforms{$job})
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$aJobforms{$job})
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]; $aRecNo; [Job_Forms_Machines:43]CostCenterID:4; $cc; [Job_Forms_Machines:43]JobSequence:8; $route)  //;[Job_Forms_Machines]Planned_Qty;$want)
		SORT ARRAY:C229($route; $cc; $aRecNo; >)  //$want
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		$lengthRoute:=Size of array:C274($route)
		If ($lengthRoute>0)
			$nextSeq:=$route{1}  //+"a"
		Else 
			$nextSeq:="n/a"
		End if 
		// Modified by: Mel Bohince (5/21/16) add mnemonic to assist if downstream is a slow operation
		$mnemonic:="-"
		$handLabor:=" 501 503 505 "
		For ($operation; 1; $lengthRoute)
			$budCC:=String:C10(Num:C11($cc{$operation}))
			Case of   //see uInit_CostCenterGroups
				: (Position:C15($budCC; <>SHEETERS)>0)
					$mnemonic:="B"  //replace the hyphen which meant sheeted stock
				: (Position:C15($budCC; <>PRESSES)>0)
					$mnemonic:=$mnemonic+"P"
				: (Position:C15($budCC; <>LAMINATERS)>0)
					$mnemonic:=$mnemonic+"L"
				: (Position:C15($budCC; <>STAMPERS)>0) | (Position:C15($budCC; <>EMBOSSERS)>0)
					GOTO RECORD:C242([Job_Forms_Machines:43]; $aRecNo{$operation})
					$desc:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)  //see also CostCtr_Description_Tweak for emb v stamp
					If (Position:C15("Embossing"; $desc)>0)
						$mnemonic:=$mnemonic+"E"
					Else 
						$mnemonic:=$mnemonic+"S"
					End if 
					UNLOAD RECORD:C212([Job_Forms_Machines:43])
				: (Position:C15($budCC; <>BLANKERS)>0)
					$mnemonic:=$mnemonic+"D"
				: (Position:C15($budCC; $handLabor)>0)
					$mnemonic:=$mnemonic+"H"
				: (Position:C15($budCC; <>GLUERS)>0)
					$mnemonic:=$mnemonic+"G"
				Else 
					$mnemonic:=$mnemonic+"O"
			End case 
		End for 
		
	End if   //get the routing mnemonic
	
	If (True:C214)  //use machine tickets to measure progress of the job, or board issue if no MT's, decide which queue the sheets are waiting at
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$aJobforms{$job}; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Good_Units:8>0)
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)  //work has really started
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobFormSeq:16; $mtJseq; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $mtCC; [Job_Forms_Machine_Tickets:61]DateEntered:5; $mtDateEntered)
			REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
			SORT ARRAY:C229($mtDateEntered; $mtJseq; $mtCC; <)
			$jobLastTouch:=$mtDateEntered{1}
			SORT ARRAY:C229($mtJseq; $mtCC; $mtDateEntered; <)
			
			//starting at the highest sequence machine ticket
			// find the next sequence in the route and pass the wip there
			For ($seq; 1; Size of array:C274($mtJseq))
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$mtJseq{$seq})
				$sheets:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)  //what happened here, calc the sheets
				
				//Modified by: Mel Bohince (6/10/16) look for complete flag before advancing the wip sheets
				C_LONGINT:C283($isComplete)
				SET QUERY DESTINATION:C396(Into variable:K19:4; $isComplete)
				// ******* Verified  - 4D PS - January  2019 ********
				QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]P_C:10="@C@")
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				//$isComplete:=1
				
				If (Position:C15($mtCC{$seq}; <>BLANKERS)>0)  //only glueing left
					APPEND TO ARRAY:C911($aJobGlueing; $aJobforms{$job})  //so dump the wip on gluing
					APPEND TO ARRAY:C911($aQueGlueing; $sheets)
					APPEND TO ARRAY:C911($aThruPutGlueing; [Job_Forms_Master_Schedule:67]ThroughPut:86)
					$seq:=1+Size of array:C274($mtJseq)  //break out of loop
					$nextSeq:=$route{Size of array:C274($route)}  //+"b"
					
				Else   //walk the walk,
					//$nextCC:=Job_Routing ("nextCC";$mtJseq{$seq})
					$hit:=Find in array:C230($route; $mtJseq{$seq})  //how far did we get and 
					If ($hit>-1)  //whew, this is normal, 
						If ($hit<$lengthRoute)  //looks like there will be another sequence,  and where are they going
							//what happens next in the route?
							If ($isComplete>0)  //move qty to next seq
								$next:=$hit+1
								$nextCC:=Replace string:C233($cc{$next}; "!"; "")  //ignore the unbudgeted additons
								If ($nextCC="SFM")  //ignore semi finished good extractions
									$next:=$next+1
									$nextCC:=Replace string:C233($cc{$next}; "!"; "")
								End if 
								$nextSeq:=$route{$next}  //+"c"
								
							Else   //seq not complete so leave qty at this seq
								$nextCC:=$mtCC{$seq}
								$nextSeq:=$route{$seq}  //+"d"
							End if 
							
							If ((Position:C15($nextCC; <>EMBOSSERS)>0) | (Position:C15($nextCC; <>STAMPERS)>0))  // ugly little test to see if this is stamping or embossing
								GOTO RECORD:C242([Job_Forms_Machines:43]; $aRecNo{$hit+1})
								$desc:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)  //see also CostCtr_Description_Tweak for emb v stamp
								If (Position:C15("Embossing"; $desc)>0)
									$nextCC:="552"
								End if 
								UNLOAD RECORD:C212([Job_Forms_Machines:43])
							End if 
							
						Else   //last operation still happening
							$nextCC:=$cc{$hit}  //, or gone to outside service
							$nextSeq:=$route{$hit}  //+"e"
						End if   //less than the end of the route
						
						//tally the wip sheets to a department
						Case of   //see uInit_CostCenterGroups
							: (Position:C15($nextCC; <>SHEETERS)>0)
								APPEND TO ARRAY:C911($aJobSheeter; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueSheeter; $sheets)
								APPEND TO ARRAY:C911($aThruPutSheeter; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>PRESSES)>0)
								APPEND TO ARRAY:C911($aJobPrinting; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQuePrinting; $sheets)
								APPEND TO ARRAY:C911($aThruPutPrinting; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>LAMINATERS)>0)
								APPEND TO ARRAY:C911($aJobLaminating; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueLaminating; $sheets)
								APPEND TO ARRAY:C911($aThruPutLaminating; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>STAMPERS)>0)
								APPEND TO ARRAY:C911($aJobStamping; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueStamping; $sheets)
								APPEND TO ARRAY:C911($aThruPutStamping; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>EMBOSSERS)>0)
								APPEND TO ARRAY:C911($aJobEmbossing; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueEmbossing; $sheets)
								APPEND TO ARRAY:C911($aThruPutEmbossing; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>BLANKERS)>0)
								APPEND TO ARRAY:C911($aJobBlanking; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueBlanking; $sheets)
								APPEND TO ARRAY:C911($aThruPutBlanking; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							: (Position:C15($nextCC; <>GLUERS)>0)
								APPEND TO ARRAY:C911($aJobIsGlueing; $aJobforms{$job})
								APPEND TO ARRAY:C911($aIsGlueing; ($aCartonQty{$job}-$sheets))  //in this case sheets are really cartons, so find how many more to glue
								APPEND TO ARRAY:C911($aThruPutIsGlueing; [Job_Forms_Master_Schedule:67]ThroughPut:86)
								
							Else 
								APPEND TO ARRAY:C911($aJobOther; $aJobforms{$job})
								APPEND TO ARRAY:C911($aQueOther; $sheets)
								APPEND TO ARRAY:C911($aThruPutOther; [Job_Forms_Master_Schedule:67]ThroughPut:86)
						End case 
						
						$seq:=1+Size of array:C274($mtJseq)  //break out of loop
						
					Else   //try earlier mt
						BEEP:C151
					End if 
					
				End if   //not just blanked
				
			End for   //each mt
			
		Else   //see if board or plastic was issued
			$jobLastTouch:=!00-00-00!  // Modified by: Mel Bohince (7/28/16) init when no mt's
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=1; *)
			QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]CommodityCode:24=20; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=$aJobforms{$job}; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
				If ([Raw_Materials:21]IssueUOM:10="SHT")
					$quePrinting:=(Sum:C1([Raw_Materials_Transactions:23]Qty:6))*-1
					APPEND TO ARRAY:C911($aJobPrinting; $aJobforms{$job})
					APPEND TO ARRAY:C911($aQuePrinting; $quePrinting)
					APPEND TO ARRAY:C911($aThruPutPrinting; [Job_Forms_Master_Schedule:67]ThroughPut:86)
					$printingMenmonic:=Position:C15("P"; $mnemonic)
					$nextSeq:=$route{$printingMenmonic}  //+"f"
					
				Else 
					$queSheeter:=(Sum:C1([Raw_Materials_Transactions:23]Qty:6))*-1
					APPEND TO ARRAY:C911($aJobSheeter; $aJobforms{$job})
					APPEND TO ARRAY:C911($aQueSheeter; $queSheeter)
					APPEND TO ARRAY:C911($aThruPutSheeter; [Job_Forms_Master_Schedule:67]ThroughPut:86)
					$sheetingMenmonic:=Position:C15("B"; $mnemonic)
					$nextSeq:=$route{$sheetingMenmonic}  //+"g"
				End if 
				
			Else   //no board issue, is the stock available
				If ([Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
					$queSheeter:=$aGrossSheets{$job}
					APPEND TO ARRAY:C911($aJobSheeter; $aJobforms{$job})
					APPEND TO ARRAY:C911($aQueSheeter; $queSheeter)
					APPEND TO ARRAY:C911($aThruPutSheeter; [Job_Forms_Master_Schedule:67]ThroughPut:86)
				End if 
			End if 
		End if   //machine tickets
	End if   //measure progress
	
	
	//$aText{$job}:=$aJobforms{$job}+"-["+$mnemonic+"]"+$delim+$readyForProduction+$delim+String([Job_Forms_Master_Schedule]FirstReleaseDat;Internal date short special)+$delim+String([Job_Forms_Master_Schedule]ThroughPut)+$delim+String($wip)+$delim+String([Job_Forms_Master_Schedule]DateStockRecd;Internal date short special)+$delim+String($queSheeter)+$delim+String($quePrinting)+$delim+String($queStamping)+$delim+String($queEmbossing)+$delim+String($queLaminating)+$delim+String($queOther)+$delim+String($queBlanking)+$delim+String($queGlueing)+$delim+String($isGlueing)+"\r"
	
	
	
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$nextSeq)  // Modified by: Mel Bohince (8/11/16) 
	If (Records in selection:C76([ProductionSchedules:110])=1)  // if found set the priority and note the sched on the report
		$nextSeq:=Substring:C12($nextSeq; 10)+">"+[ProductionSchedules:110]CostCenter:1+"@"+String:C10([ProductionSchedules:110]Priority:3)
		[ProductionSchedules:110]ThruPutValueOfJob:78:=[Job_Forms_Master_Schedule:67]ThroughPut:86
		SAVE RECORD:C53([ProductionSchedules:110])
	Else 
		$nextSeq:=Substring:C12($nextSeq; 10)+">?"
	End if 
	UNLOAD RECORD:C212([ProductionSchedules:110])
	
	//stringify the common job info, will merge it with department sheet counts later after a department sort
	If (Position:C15("3"; $aJobType{$job})=0)
		$aJobLine{$job}:=Substring:C12($aJobType{$job}; 3)+"-"+$aJobLine{$job}
	End if 
	$aJobData{$job}:=$aJobforms{$job}+"-["+$mnemonic+"]"+$delim+$nextSeq+$delim+CUST_getName($aJobCust{$job}; "el")+$delim+$aJobLine{$job}+$delim+String:C10([Job_Forms_Master_Schedule:67]FirstReleaseDat:13; Internal date short special:K1:4)+$delim+String:C10([Job_Forms_Master_Schedule:67]ThroughPut:86)+$delim+String:C10($wip)+$delim+String:C10([Job_Forms_Master_Schedule:67]DateStockRecd:17; Internal date short special:K1:4)+$delim+String:C10($jobLastTouch; Internal date short special:K1:4)  //+String($queSheeter)+$delim+String($quePrinting)+$delim+String($queStamping)+$delim+String($queEmbossing)+$delim+String($queLaminating)+$delim+String($queOther)+$delim+String($queBlanking)+$delim+String($queGlueing)+$delim+String($isGlueing)+"\r"
	$aJobTP{$job}:=[Job_Forms_Master_Schedule:67]ThroughPut:86  // Modified by: Mel Bohince (6/2/16) Add thru-put per M sheets
	
	
	
	
	
	uThermoUpdate($job)
End for   //each job
uThermoClose

//create a "waterfall" sorting of this data
//sort within the department, descending by Thru-put dollars
SORT ARRAY:C229($aThruPutSheeter; $aQueSheeter; $aJobSheeter; <)
SORT ARRAY:C229($aThruPutPrinting; $aQuePrinting; $aJobPrinting; <)
SORT ARRAY:C229($aThruPutStamping; $aQueStamping; $aJobStamping; <)
SORT ARRAY:C229($aThruPutEmbossing; $aQueEmbossing; $aJobEmbossing; <)
SORT ARRAY:C229($aThruPutLaminating; $aQueLaminating; $aJobLaminating; <)
SORT ARRAY:C229($aThruPutBlanking; $aQueBlanking; $aJobBlanking; <)
SORT ARRAY:C229($aThruPutGlueing; $aQueGlueing; $aJobGlueing; <)
SORT ARRAY:C229($aThruPutIsGlueing; $aIsGlueing; $aJobIsGlueing; <)
SORT ARRAY:C229($aThruPutOther; $aQueOther; $aJobOther; <)
$pH:="0"  //place holder

//from workflow begining to end reassemble the job info with the department sheet count
// Modified by: Mel Bohince (6/2/16) Add thru-put per M sheets in each department below
For ($queue; 1; Size of array:C274($aJobSheeter))
	$hit:=Find in array:C230($aJobforms; $aJobSheeter{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueSheeter{$queue}); -1))+$delim+String:C10($aQueSheeter{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobPrinting))
	$hit:=Find in array:C230($aJobforms; $aJobPrinting{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQuePrinting{$queue}); -1))+$delim+$pH+$delim+String:C10($aQuePrinting{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobStamping))
	$hit:=Find in array:C230($aJobforms; $aJobStamping{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueStamping{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+String:C10($aQueStamping{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobEmbossing))
	$hit:=Find in array:C230($aJobforms; $aJobEmbossing{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueEmbossing{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aQueEmbossing{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobLaminating))
	$hit:=Find in array:C230($aJobforms; $aJobLaminating{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueLaminating{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aQueLaminating{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobOther))
	$hit:=Find in array:C230($aJobforms; $aJobOther{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueOther{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aQueOther{$queue})+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobBlanking))
	$hit:=Find in array:C230($aJobforms; $aJobBlanking{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueBlanking{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aQueBlanking{$queue})+$delim+$pH+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobGlueing))
	$hit:=Find in array:C230($aJobforms; $aJobGlueing{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aQueGlueing{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aQueGlueing{$queue})+$delim+$pH+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 

For ($queue; 1; Size of array:C274($aJobIsGlueing))
	$hit:=Find in array:C230($aJobforms; $aJobIsGlueing{$queue})
	If ($hit>-1)
		$outputLine:=$aJobData{$hit}+$delim+String:C10(Round:C94(($aJobTP{$hit}*1000/$aIsGlueing{$queue}); -1))+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+String:C10($aIsGlueing{$queue})+"\r"
		APPEND TO ARRAY:C911($aOutput; $outputLine)
	Else 
		ALERT:C41("error")
	End if 
End for 


C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)
$t:=$delim  //"\t"
$r:="\r"
$title:=(6*$t)+"SHEETS IN WIP BY DEPARTMENT SORTED DESCENDING BY THRU-PUT DOLLARS (8WKS FIRM&FCST)"
$text:=""
$docName:="JobWIP_kanban_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	$text:=$text+"JOB_FORM"+$t+"SEQ>CC@PRIOR"+$t+"CUSTOMER"+$t+"LINE"+$t+"FIRST_SHIP"+$t+"TP$"+$t+"WIP$"+$t+"STOCK_RECD"+$t+"LASTTOUCH"+$t+"TP/MSHT"+$t+"SHEETING"+$t+"PRINTING"+$t+"STAMPING"+$t+"EMBOSSING"+$t+"LAMINATING"+$t+"OTHER"+$t+"BLANKING"+$t+"TO_GLUE"+$t+"GLUEING"+$r
	
	
	For ($line; 1; Size of array:C274($aOutput))
		If (Length:C16($text)>25000)
			SEND PACKET:C103($docRef; $text)
			$text:=""
		End if 
		
		$text:=$text+$aOutput{$line}  //normally this is enough
		//check if any sheets had been appended
		$lastChar:=Substring:C12($aOutput{$line}; Length:C16($aOutput{$line}); 1)
		If ($lastChar#"\r")
			$text:=$text+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+$delim+$pH+"\r"
		End if 
	End for 
	
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		UNLOAD RECORD:C212([ProductionSchedules:110])
		REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
		
	Else 
		
		REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	If (Count parameters:C259=1)
		$distributionList:=$1
		//Batch_GetDistributionList
		$body:="Department queues sorted by thru-put dollars. You may wish to sort thru-put per thousand sheets."
		//EMAIL_Sender ("Kanban Status";"";$body;"mel.bohince@arkay.com";$docName)
		EMAIL_Transporter("Kanban Status"; ""; $body; "mel.bohince@arkay.com"; $docName)
		util_deleteDocument($docName)
		
	Else 
		$err:=util_Launch_External_App($docName)
	End if 
	
End if 
