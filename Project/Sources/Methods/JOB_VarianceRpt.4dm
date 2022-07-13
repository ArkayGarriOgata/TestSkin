//%attributes = {"publishedWeb":true}
//PM: JOB_VarianceRpt() -> 08/25/1999  Mel Bohince
//Give Marty a variance report that he likes
//•083199  mlb  MSK wanted the Selling and PV columns added
//•10/12/00  mlb  chg algo to get final sheet count
//• mlb - 9/24/01  15:57 revise for Sherry
//• mlb - 10/22/02  13:39 fix else in comm 13's
//• mlb - 11/21/02  11:46 remove Platemaking MachTicks.
// Modified by: MelvinBohince (4/5/22) change xls to csv,

C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numJobs; $j; $gridSize)
C_REAL:C285($printingHrs; $gluingHrs)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)

$gridSize:=23  //=columns of data
$t:=","  // Modified by: MelvinBohince (4/5/22) change xls to csv,  Char(9)
$cr:=Char:C90(13)

MESSAGES OFF:C175
//*Find the jobs to report
If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=dDateBegin; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=dDateEnd)
	OK:=1
Else 
	$numJobs:=qryByDateRange(->[Job_Forms:42]ClosedDate:11; "Select Closed Date")
End if   //params

If (OK=1)
	C_REAL:C285($toleranceTrigger)
	$toleranceTrigger:=20
	If (Count parameters:C259=0)
		$toleranceTrigger:=Num:C11(Request:C163("Flag jobs with a Total$ variance greater than ?%"; "20"))
	End if 
	If ($toleranceTrigger>0)
		$toleranceTrigger:=$toleranceTrigger/100  //convert to decimal
	End if 
	xTitle:="Job Var Rpt-Closed "+String:C10(dDateBegin; <>MIDDATE)+" to "+String:C10(dDateEnd; <>MIDDATE)
	xText:="NOTE: Copy/Paste the text below into a spreadsheet for the columns to align:"+$cr+$cr+xTitle+$cr
	xText:=xText+$cr+"JobForm"+$t+"CUSTOMER"+$t
	For ($col; 1; $gridSize)
		xText:=xText+String:C10($col)+$t
	End for 
	xText:=xText+$cr
	xText:=xText+$t+$t+"Board$"+$t+"Ink$"+$t+"Coating$"+$t+"Plate$"+$t+"Leaf$"+$t+"Corr$"+$t+"Stamping$"+$t+"Acetate$"+$t+"Laser$"+$t+"SenserTag$"+$t+"OtherMatl$"+$t+"TotalMatl$"+$t+"MR$"+$t+"MRHrs"+$t+"Run$"+$t+"RunHrs"+$t+"TotalConv$"+$t+"TotalHrs"
	xText:=xText+$t+"@Selling$"+$t+"TotalCost"+$t+"Contribution"+$t+"PV"+$t+"> "+String:C10($toleranceTrigger*100)+" % $VAR"+$cr
	docName:="JobVarianceRpt_"+fYYMMDD(dDateEnd)+".csv"  // Modified by: MelvinBohince (4/5/22) change xls to csv,
	
	If (Count parameters:C259=0)
		docName:=Request:C163("Enter name for document"; docName)
		//$docRef:=Create document("")
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			OK:=1
		End if 
	Else 
		//$docRef:=Create document("JobVarianceRpt_"+fYYMMDD (dDateEnd))
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			OK:=1
		End if 
		
	End if 
	If (OK=1)
		$numJobs:=Records in selection:C76([Job_Forms:42])
		If ($numJobs>0)
			ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
			//*Init the CostCenters
			CostCtrCurrent("init"; String:C10([Job_Forms:42]ClosedDate:11; Internal date short special:K1:4))
			
			//*   Send Header
			ARRAY REAL:C219($aTBudget; 0)
			ARRAY REAL:C219($aTBudget; $gridSize)
			ARRAY REAL:C219($aTActual; 0)
			ARRAY REAL:C219($aTActual; $gridSize)
			ARRAY REAL:C219($aTVariance; 0)
			ARRAY REAL:C219($aTVariance; $gridSize)
			
			uThermoInit($numJobs; "Saving Job Variance to "+document)
			For ($i; 1; $numJobs)
				//If (Length(xText)>28000)  //flush the buffer
				//SEND PACKET($docRef;xText)
				//xText:=""
				//End if 
				//*   Query Related records
				RELATE ONE:C42([Job_Forms:42]JobNo:2)
				RELATE MANY:C262([Job_Forms:42]JobFormID:5)
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
				//*   Init the Row buffers
				ARRAY TEXT:C222($aBudget; 0)
				ARRAY TEXT:C222($aBudget; $gridSize)
				ARRAY TEXT:C222($aActual; 0)
				ARRAY TEXT:C222($aActual; $gridSize)
				ARRAY TEXT:C222($aVariance; 0)
				ARRAY TEXT:C222($aVariance; $gridSize)
				
				//*   Get Budget  
				//*      Materials
				$board:=0
				$ink:=0
				$coating:=0  //• mlb - 9/24/01  08:41
				$plates:=0
				$leaf:=0
				$corragate:=0  //• mlb - 9/24/01  08:41
				$stamping:=0  //• mlb - 9/24/01  08:41
				$acetate:=0
				$laser:=0  //• mlb - 9/24/01  08:41
				$sensor:=0  //• mlb - 12/11/02  10:32
				$other:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					For ($j; 1; Records in selection:C76([Job_Forms_Materials:55]))
						$comm:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
						Case of 
							: ($comm=1) | ($comm=20)  //board
								$board:=$board+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=2)  //ink
								$ink:=$ink+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=3)  //coatins
								$coating:=$coating+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=4)  //plates
								$plates:=$plates+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=5)  //leaf
								$leaf:=$leaf+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=6)  //corragee
								$corragate:=$corragate+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=7)  //stampoing dies
								$stamping:=$stamping+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=8)  //acetate
								$acetate:=$acetate+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=12)  //sensor tags
								$sensor:=$sensor+[Job_Forms_Materials:55]Planned_Cost:8
							: ($comm=13)  //`• mlb - 9/24/01  08:43
								If ([Job_Forms_Materials:55]Commodity_Key:12="13-LASER DIES")
									$laser:=$laser+[Job_Forms_Materials:55]Planned_Cost:8
								Else   //• mlb - 10/22/02  13:38
									$other:=$other+[Job_Forms_Materials:55]Planned_Cost:8
								End if 
							Else 
								$other:=$other+[Job_Forms_Materials:55]Planned_Cost:8
						End case 
						NEXT RECORD:C51([Job_Forms_Materials:55])
					End for 
					
				Else 
					
					ARRAY TEXT:C222($_Commodity_Key; 0)
					ARRAY REAL:C219($_Planned_Cost; 0)
					SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; [Job_Forms_Materials:55]Planned_Cost:8; $_Planned_Cost)
					$size:=Size of array:C274($_Planned_Cost)
					
					For ($j; 1; $size)
						$comm:=Num:C11(Substring:C12($_Commodity_Key{$j}; 1; 2))  // Modified by: Mel Bohince (10/31/21) was j instead of $j
						Case of 
							: ($comm=1) | ($comm=20)  //board
								$board:=$board+$_Planned_Cost{$j}
							: ($comm=2)  //ink
								$ink:=$ink+$_Planned_Cost{$j}
							: ($comm=3)  //coatins
								$coating:=$coating+$_Planned_Cost{$j}
							: ($comm=4)  //plates
								$plates:=$plates+$_Planned_Cost{$j}
							: ($comm=5)  //leaf
								$leaf:=$leaf+$_Planned_Cost{$j}
							: ($comm=6)  //corragee
								$corragate:=$corragate+$_Planned_Cost{$j}
							: ($comm=7)  //stampoing dies
								$stamping:=$stamping+$_Planned_Cost{$j}
							: ($comm=8)  //acetate
								$acetate:=$acetate+$_Planned_Cost{$j}
							: ($comm=12)  //sensor tags
								$sensor:=$sensor+$_Planned_Cost{$j}
							: ($comm=13)  //`• mlb - 9/24/01  08:43
								If ($_Commodity_Key{$j}="13-LASER DIES")
									$laser:=$laser+$_Planned_Cost{$j}
								Else   //• mlb - 10/22/02  13:38
									$other:=$other+$_Planned_Cost{$j}
								End if 
							Else 
								$other:=$other+$_Planned_Cost{$j}
						End case 
						
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				$aBudget{1}:=String:C10(Round:C94($board; 0))
				$aBudget{2}:=String:C10(Round:C94($ink; 0))
				$aBudget{3}:=String:C10(Round:C94($coating; 0))
				$aBudget{4}:=String:C10(Round:C94($plates; 0))
				$aBudget{5}:=String:C10(Round:C94($leaf; 0))
				$aBudget{6}:=String:C10(Round:C94($corragate; 0))
				$aBudget{7}:=String:C10(Round:C94($stamping; 0))
				$aBudget{8}:=String:C10(Round:C94($acetate; 0))
				$aBudget{9}:=String:C10(Round:C94($laser; 0))
				$aBudget{10}:=String:C10(Round:C94($sensor; 0))
				$aBudget{11}:=String:C10(Round:C94($other; 0))
				$matlCost:=Round:C94($board+$ink+$coating+$plates+$leaf+$corragate+$stamping+$acetate+$sensor+$laser+$other; 0)
				$aBudget{12}:=String:C10($matlCost)
				
				//*      Operations
				$mrHrs:=0
				$mrDollars:=0
				$runHrs:=0
				$runDollars:=0
				//$printingHrs:=0
				//$gluingHrs:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					For ($j; 1; Records in selection:C76([Job_Forms_Machines:43]))
						$mrHrs:=$mrHrs+[Job_Forms_Machines:43]Planned_MR_Hrs:15
						$runHrs:=$runHrs+[Job_Forms_Machines:43]Planned_RunHrs:37
						//Case of 
						//: (Position([Machine_Job]CostCenterID;◊PRESSES)>0)
						//$printingHrs:=$printingHrs+[Machine_Job]Pld_RunHrs
						//: (Position([Machine_Job]CostCenterID;◊GLUERS)>0)
						//$gluingHrs:=$gluingHrs+[Machine_Job]Pld_RunHrs
						//End case 
						$oop:=CostCtrCurrent("oop"; [Job_Forms_Machines:43]CostCenterID:4)
						$mrDollars:=$mrDollars+($oop*[Job_Forms_Machines:43]Planned_MR_Hrs:15)
						$runDollars:=$runDollars+($oop*[Job_Forms_Machines:43]Planned_RunHrs:37)
						NEXT RECORD:C51([Job_Forms_Machines:43])
					End for 
					
					
				Else 
					
					ARRAY REAL:C219($_Planned_MR_Hrs; 0)
					ARRAY REAL:C219($_Planned_RunHrs; 0)
					ARRAY TEXT:C222($_CostCenterID; 0)
					
					SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Planned_MR_Hrs:15; $_Planned_MR_Hrs; [Job_Forms_Machines:43]Planned_RunHrs:37; $_Planned_RunHrs; [Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID)
					
					$size:=Size of array:C274($_CostCenterID)
					
					For ($j; 1; $size)
						$mrHrs:=$mrHrs+$_Planned_MR_Hrs{$j}
						$runHrs:=$runHrs+$_Planned_RunHrs{$j}
						$oop:=CostCtrCurrent("oop"; $_CostCenterID{$j})
						$mrDollars:=$mrDollars+($oop*$_Planned_MR_Hrs{$j})
						$runDollars:=$runDollars+($oop*$_Planned_RunHrs{$j})
					End for 
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				$aBudget{13}:=String:C10(Round:C94($mrDollars; 0))
				$aBudget{14}:=String:C10(Round:C94($mrHrs; 0))
				$aBudget{15}:=String:C10(Round:C94($runDollars; 0))
				$aBudget{16}:=String:C10(Round:C94($runHrs; 0))
				$aBudget{17}:=String:C10(Round:C94($mrDollars+$runDollars; 0))
				$aBudget{18}:=String:C10(Round:C94($mrHrs+$runHrs; 0))
				
				//•083199  mlb  get booked selling and PV
				$bookedRev:=Job_SalesValue([Job_Forms:42]JobFormID:5)  // Modified by: Mel Bohince (3/6/17) use standard method
				
				$aBudget{19}:=String:C10(Round:C94($bookedRev; 0))
				$aBudget{20}:=String:C10(Round:C94($matlCost+$mrDollars+$runDollars; 0))
				$aBudget{21}:=String:C10(Round:C94($bookedRev-($matlCost+$mrDollars+$runDollars); 0))
				$rebate:=fGetCustRebate([Jobs:15]CustID:2)
				$aBudget{22}:=String:C10(Round:C94(fProfitVariable("PV"; $matlCost+$mrDollars+$runDollars; $bookedRev; $rebate)*100; 1))
				//•083199  mlb  en        
				//$aBudget{22}:=String(Round(Num($aBudget{17})/Num($aBudget{16});1))
				
				//*   Get Actual  
				//*      Materials        
				$board:=0
				$ink:=0
				$coating:=0  //• mlb - 9/24/01  08:41
				$plates:=0
				$leaf:=0
				$corragate:=0  //• mlb - 9/24/01  08:41
				$stamping:=0  //• mlb - 9/24/01  08:41
				$acetate:=0
				$sensor:=0  //• mlb - 12/11/02  10:32
				$laser:=0  //• mlb - 9/24/01  08:41
				$other:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					For ($j; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
						Case of 
							: ([Raw_Materials_Transactions:23]CommodityCode:24=1)  //board
								$board:=$board+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=2)  //ink
								$ink:=$ink+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=3)  //ink
								$coating:=$coating+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=4)  //plates
								$plates:=$plates+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=5)  //leaf
								$leaf:=$leaf+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=6)  //leaf
								$corragate:=$corragate+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=7)  //leaf
								$stamping:=$stamping+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=8)  //acetate
								$acetate:=$acetate+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=12)  //acetate
								$sensor:=$sensor+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
							: ([Raw_Materials_Transactions:23]CommodityCode:24=13)  //`• mlb - 9/24/01  08:43
								If ([Raw_Materials_Transactions:23]Commodity_Key:22="13-LASER DIES")
									$laser:=$laser+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
								Else   //• mlb - 10/22/02  13:38
									$other:=$other+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
								End if 
							Else 
								$other:=$other+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
						End case 
						NEXT RECORD:C51([Raw_Materials_Transactions:23])
					End for 
					
				Else 
					
					ARRAY INTEGER:C220($_CommodityCode; 0)
					ARRAY REAL:C219($_ActExtCost; 0)
					ARRAY TEXT:C222($_Commodity_Key; 0)
					
					SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]CommodityCode:24; $_CommodityCode; [Raw_Materials_Transactions:23]ActExtCost:10; $_ActExtCost; [Raw_Materials_Transactions:23]Commodity_Key:22; $_Commodity_Key)
					
					$size:=Size of array:C274($_ActExtCost)
					
					For ($j; 1; $size)
						Case of 
							: ($_CommodityCode{$j}=1)  //board
								$board:=$board+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=2)  //ink
								$ink:=$ink+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=3)  //ink
								$coating:=$coating+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=4)  //plates
								$plates:=$plates+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=5)  //leaf
								$leaf:=$leaf+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=6)  //leaf
								$corragate:=$corragate+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=7)  //leaf
								$stamping:=$stamping+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=8)  //acetate
								$acetate:=$acetate+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=12)  //acetate
								$sensor:=$sensor+($_ActExtCost{$j}*-1)
							: ($_CommodityCode{$j}=13)  //`• mlb - 9/24/01  08:43
								If ($_Commodity_Key{$j}="13-LASER DIES")
									$laser:=$laser+($_ActExtCost{$j}*-1)
								Else   //• mlb - 10/22/02  13:38
									$other:=$other+($_ActExtCost{$j}*-1)
								End if 
							Else 
								$other:=$other+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
						End case 
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				$aActual{1}:=String:C10(Round:C94($board; 0))
				$aActual{2}:=String:C10(Round:C94($ink; 0))
				$aActual{3}:=String:C10(Round:C94($coating; 0))
				$aActual{4}:=String:C10(Round:C94($plates; 0))
				$aActual{5}:=String:C10(Round:C94($leaf; 0))
				$aActual{6}:=String:C10(Round:C94($corragate; 0))
				$aActual{7}:=String:C10(Round:C94($stamping; 0))
				$aActual{8}:=String:C10(Round:C94($acetate; 0))
				$aActual{9}:=String:C10(Round:C94($laser; 0))
				$aActual{10}:=String:C10(Round:C94($sensor; 0))
				$aActual{11}:=String:C10(Round:C94($other; 0))
				$matlCost:=Round:C94($board+$ink+$coating+$plates+$leaf+$corragate+$stamping+$acetate+$sensor+$laser+$other; 0)
				$aActual{12}:=String:C10($matlCost)
				
				//*      Operations
				$mrHrs:=0
				$mrDollars:=0
				$runHrs:=0
				$runDollars:=0
				$countSheets:=0
				//$printingHrs:=0
				//$gluingHrs:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >)  //•10/12/00  mlb 
					$currentSeq:=0
					//If ([JobForm]JobFormID="78958.06")
					//TRACE
					//End if 
					For ($j; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
						If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>PLATEMAKING)=0)  //• mlb - 11/21/02  11:46
							$mrHrs:=$mrHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6
							$runHrs:=$runHrs+[Job_Forms_Machine_Tickets:61]Run_Act:7
							//Case of 
							//: (Position([MachineTicket]CostCenterID;◊PRESSES)>0)
							//$printingHrs:=$printingHrs+[MachineTicket]Run_Act
							//: (Position([MachineTicket]CostCenterID;◊GLUERS)>0)
							//$gluingHrs:=$gluingHrs+[MachineTicket]Run_Act
							//End case 
							$oop:=CostCtrCurrent("oop"; [Job_Forms_Machine_Tickets:61]CostCenterID:2)
							$mrDollars:=$mrDollars+($oop*[Job_Forms_Machine_Tickets:61]MR_Act:6)
							$runDollars:=$runDollars+($oop*[Job_Forms_Machine_Tickets:61]Run_Act:7)
							//•10/12/00  mlb  
							If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>GLUERS)=0)
								If ($currentSeq#[Job_Forms_Machine_Tickets:61]Sequence:3)
									$countSheets:=[Job_Forms_Machine_Tickets:61]Good_Units:8
									$currentSeq:=[Job_Forms_Machine_Tickets:61]Sequence:3
								Else 
									$countSheets:=$countSheets+[Job_Forms_Machine_Tickets:61]Good_Units:8
								End if 
							End if 
							//If (Position([MachineTicket]CostCenterID;◊BLANKERS)>0)
							//$countSheets:=$countSheets+[MachineTicket]Good_Units
							//End if 
						End if   //not platemaking
						NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
					End for 
					
				Else 
					
					ARRAY INTEGER:C220($_Sequence; 0)
					ARRAY TEXT:C222($_CostCenterID; 0)
					ARRAY REAL:C219($_MR_Act; 0)
					ARRAY REAL:C219($_Run_Act; 0)
					ARRAY LONGINT:C221($_Good_Units; 0)
					
					SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; [Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; [Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; [Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units)
					SORT ARRAY:C229($_Sequence; $_CostCenterID; $_MR_Act; $_Run_Act; $_Good_Units; >)
					
					$size:=Size of array:C274($_Sequence)
					$currentSeq:=0
					
					For ($j; 1; $size)
						If (Position:C15($_CostCenterID{$j}; <>PLATEMAKING)=0)  //• mlb - 11/21/02  11:46
							$mrHrs:=$mrHrs+$_MR_Act{$j}
							$runHrs:=$runHrs+$_Run_Act{$j}
							$oop:=CostCtrCurrent("oop"; $_CostCenterID{$j})
							$mrDollars:=$mrDollars+($oop*$_MR_Act{$j})
							$runDollars:=$runDollars+($oop*$_Run_Act{$j})
							//•10/12/00  mlb  
							If (Position:C15($_CostCenterID{$j}; <>GLUERS)=0)
								If ($currentSeq#$_Sequence{$j})
									$countSheets:=$_Good_Units{$j}
									$currentSeq:=$_Sequence{$j}
								Else 
									$countSheets:=$countSheets+$_Good_Units{$j}
								End if 
							End if 
						End if 
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				
				$aActual{13}:=String:C10(Round:C94($mrDollars; 0))
				$aActual{14}:=String:C10(Round:C94($mrHrs; 0))
				$aActual{15}:=String:C10(Round:C94($runDollars; 0))
				$aActual{16}:=String:C10(Round:C94($runHrs; 0))
				$aActual{17}:=String:C10(Round:C94($mrDollars+$runDollars; 0))
				$aActual{18}:=String:C10(Round:C94($mrHrs+$runHrs; 0))
				
				$numReceipt:=Records in selection:C76([Finished_Goods_Transactions:33])
				$glueQty:=0
				$actRev:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					
					FIRST RECORD:C50([Finished_Goods_Transactions:33])
					For ($j; 1; $numReceipt)
						qryJMI([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)
						$unitPrice:=0
						QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
						If (Records in selection:C76([Customers_Order_Lines:41])=1)
							$unitPrice:=[Customers_Order_Lines:41]Price_Per_M:8
						Else 
							qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
							If (Records in selection:C76([Finished_Goods:26])>0) & ([Job_Forms_Items:44]OrderItem:2#"Rerun")
								If ([Finished_Goods:26]RKContractPrice:49#0)
									$unitPrice:=[Finished_Goods:26]RKContractPrice:49
								Else 
									$unitPrice:=[Finished_Goods:26]LastPrice:27
								End if 
							Else 
							End if 
						End if 
						$actRev:=$actRev+($unitPrice*[Finished_Goods_Transactions:33]Qty:6/1000)
						$glueQty:=$glueQty+[Finished_Goods_Transactions:33]Qty:6
						NEXT RECORD:C51([Finished_Goods_Transactions:33])
					End for 
					
					
				Else 
					ARRAY TEXT:C222($_JobForm; 0)
					ARRAY INTEGER:C220($_JobFormItem; 0)
					ARRAY LONGINT:C221($_Qty; 0)
					
					SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]JobForm:5; $_JobForm; [Finished_Goods_Transactions:33]JobFormItem:30; $_JobFormItem; [Finished_Goods_Transactions:33]Qty:6; $_Qty)
					
					
					For ($j; 1; $numReceipt; 1)
						qryJMI($_JobForm{$j}; $_JobFormItem{$j})
						$unitPrice:=0
						QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
						If (Records in selection:C76([Customers_Order_Lines:41])=1)
							$unitPrice:=[Customers_Order_Lines:41]Price_Per_M:8
						Else 
							qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
							If (Records in selection:C76([Finished_Goods:26])>0) & ([Job_Forms_Items:44]OrderItem:2#"Rerun")
								If ([Finished_Goods:26]RKContractPrice:49#0)
									$unitPrice:=[Finished_Goods:26]RKContractPrice:49
								Else 
									$unitPrice:=[Finished_Goods:26]LastPrice:27
								End if 
							Else 
							End if 
						End if 
						$actRev:=$actRev+($unitPrice*$_Qty{$j}/1000)
						$glueQty:=$glueQty+$_Qty{$j}
					End for 
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				//$aActual{19}:=String($glueQty)
				$aActual{19}:=String:C10(Round:C94($actRev; 0))
				$aActual{20}:=String:C10(Round:C94($matlCost+$mrDollars+$runDollars; 0))
				$aActual{21}:=String:C10(Round:C94($actRev-($matlCost+$mrDollars+$runDollars); 0))
				$rebate:=fGetCustRebate([Jobs:15]CustID:2)
				$aActual{22}:=String:C10(Round:C94(fProfitVariable("PV"; $matlCost+$mrDollars+$runDollars; $actRev; $rebate)*100; 1))
				
				//*   Get Variance  
				For ($j; 1; $gridSize-1)
					$aVariance{$j}:=String:C10(Num:C11($aActual{$j})-Num:C11($aBudget{$j}))
				End for 
				
				If ($toleranceTrigger#0)
					$var:=(Num:C11($aVariance{19}))/(Num:C11($aBudget{19}))
					If (Abs:C99($var)>Abs:C99($toleranceTrigger))
						$aVariance{23}:="<<<<"+String:C10(Round:C94($var*100; 0); "#,##0% U;#,##0% F; ")+">>>>"
					Else 
						$aVariance{23}:=""
					End if 
					
				Else 
					$aVariance{23}:=""
				End if 
				
				//*   Save to file  
				xText:=xText+[Job_Forms:42]JobFormID:5+$t+txt_quote([Jobs:15]CustomerName:5)+$cr+$t+"Actual:"  // Modified by: MelvinBohince (4/5/22) change xls to csv,
				For ($j; 1; $gridSize)
					xText:=xText+$t+$aActual{$j}
				End for 
				
				xText:=xText+$cr+$t+"Budget:"
				For ($j; 1; $gridSize)
					xText:=xText+$t+$aBudget{$j}
				End for 
				
				xText:=xText+$cr+$t+"Variance:"
				For ($j; 1; $gridSize)
					xText:=xText+$t+$aVariance{$j}
				End for 
				
				xText:=xText+$cr+$t+"Variance%:"
				For ($j; 1; $gridSize-1)
					If (Num:C11($aBudget{$j})#0)
						xText:=xText+$t+String:C10(Round:C94(Num:C11($aVariance{$j})/Num:C11($aBudget{$j})*100; 0))
					Else 
						If (Num:C11($aVariance{$j})#0)
							xText:=xText+$t+"100 U"
						Else 
							xText:=xText+$t+"0"
						End if 
					End if 
				End for 
				xText:=xText+$cr
				
				//*Accumulate totals
				For ($j; 1; $gridSize-1)
					$aTBudget{$j}:=$aTBudget{$j}+Num:C11($aBudget{$j})
					$aTActual{$j}:=$aTActual{$j}+Num:C11($aActual{$j})
					$aTVariance{$j}:=$aTVariance{$j}+Num:C11($aVariance{$j})
				End for 
				
				NEXT RECORD:C51([Job_Forms:42])
				uThermoUpdate($i)
			End for 
			//CostCtrCurrent ("kill")
			
			xText:=xText+$cr+"GRAND TOTALS:"+$t+"("+String:C10($numJobs)+" Jobs)"+$cr+$t
			$aTBudget{22}:=Round:C94(fProfitVariable("PV"; $aTBudget{20}; $aTBudget{19}; 0)*100; 1)
			$aTActual{22}:=Round:C94(fProfitVariable("PV"; $aTActual{20}; $aTActual{19}; 0)*100; 1)
			$aTVariance{22}:=$aTActual{22}-$aTBudget{22}
			
			xText:=xText+"Actual:"
			For ($j; 1; $gridSize)
				xText:=xText+$t+String:C10(Round:C94($aTActual{$j}; 0))
			End for 
			xText:=xText+$cr+$t
			
			xText:=xText+"Budget:"
			For ($j; 1; $gridSize)
				xText:=xText+$t+String:C10(Round:C94($aTBudget{$j}; 0))
			End for 
			xText:=xText+$cr+$t
			
			xText:=xText+"Variance:"
			$aTVariance{23}:=Round:C94($aTVariance{20}/$aTBudget{20}*100; 0)
			For ($j; 1; $gridSize)
				xText:=xText+$t+String:C10(Round:C94($aTVariance{$j}; 0))
			End for 
			xText:=xText+$cr+$t
			
			xText:=xText+"Variance%:"
			For ($j; 1; $gridSize-1)
				If ($aTBudget{$j}#0)
					xText:=xText+$t+String:C10(Round:C94($aTVariance{$j}/$aTBudget{$j}*100; 0))
				Else 
					If ($aTVariance{$j}#0)
						xText:=xText+$t+"100 U"
					Else 
						xText:=xText+$t+"0"
					End if 
				End if 
			End for 
			xText:=xText+$cr
			uThermoClose
			
		Else   //none found
			If (Count parameters:C259=0)
				BEEP:C151
				ALERT:C41("No Job Forms matched your criterion.")
			Else 
				xText:=xText+$cr+$cr+"No Job Forms matched date range: "+String:C10(dDateBegin; Internal date short special:K1:4)+" to "+String:C10(dDateEnd; Internal date short special:K1:4)
			End if 
		End if   //no jobs  
		
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		If (Count parameters:C259=0)
			$err:=util_Launch_External_App(docName)
		Else 
			QM_Sender(xTitle; ""; "Open the attached with Excel"; distributionList; docName)
			util_deleteDocument(docName)
		End if 
		xText:=""
		
	End if 
End if 