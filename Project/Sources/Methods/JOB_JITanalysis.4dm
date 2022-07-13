//%attributes = {"publishedWeb":true}
//PM: JOB_JITanalysis() -> 
//@author mlb - 5/24/02  12:01

C_DATE:C307($1; $2; dDateEnd; dDateBegin; $dateJobStart; $dateJobDone)
C_DATE:C307($board; $ink; $coating; $plates; $leaf; $corragate; $stamping; $acetate; $laser; $other)
C_LONGINT:C283($i; $numJobs; $numPOI; $numJML; $job; $elapse)
C_REAL:C285($printingHrs; $gluingHrs)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$gridSize:=22  //=columns of data
$t:=Char:C90(9)
$cr:=Char:C90(13)

MESSAGES OFF:C175
//*Find the jobs to report
If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15>=dDateBegin; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15<=dDateEnd)
	$numJobs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
	OK:=1
Else 
	$numJobs:=qryByDateRange(->[Job_Forms_Master_Schedule:67]DateComplete:15; "Select Completed Date")
End if   //params  

If (OK=1)
	If ($numJobs>0)
		xText:="JobForm"+$t+"Sheeted"+$t+"Complete"+$t+"elapse"+$t
		xText:=xText+"board"+$t+"ink"+$t+"coating"+$t+"plates"+$t
		xText:=xText+"leaf"+$t+"stamping"+$t+"acetate"+$t+"laser"+$t
		xText:=xText+"corragate"+$t+$cr
		uThermoInit($numJobs; "Just-in-Time Analysis")
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4; >)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($job; 1; $numJobs)
				//$numJML:=qryJML ([JobForm]JobFormID)
				$dateJobStart:=[Job_Forms_Master_Schedule:67]DateStockSheeted:47
				$dateJobDone:=[Job_Forms_Master_Schedule:67]DateComplete:15
				$elapse:=$dateJobDone-$dateJobStart
				//*get the material receipt dates
				ARRAY TEXT:C222($aPOI; 0)
				ARRAY DATE:C224($aRecieved; 0)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms_Master_Schedule:67]JobForm:4; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				CREATE SET:C116([Raw_Materials_Transactions:23]; "theIssues")
				DISTINCT VALUES:C339([Raw_Materials_Transactions:23]POItemKey:4; $aPOI)
				$numPOI:=Size of array:C274($aPOI)
				ARRAY DATE:C224($aRecieved; $numPOI)
				For ($i; 1; $numPOI)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$aPOI{$i}; *)
					QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
					SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate)
					If (Size of array:C274($aDate)>0)
						SORT ARRAY:C229($aDate; >)
						$aRecieved{$i}:=$aDate{1}
					Else 
						$aRecieved{$i}:=<>MAGIC_DATE
					End if 
				End for 
				
				USE SET:C118("theIssues")
				CLEAR SET:C117("theIssues")
				ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24)
				
				$board:=<>MAGIC_DATE
				$ink:=<>MAGIC_DATE
				$coating:=<>MAGIC_DATE
				$plates:=<>MAGIC_DATE
				$leaf:=<>MAGIC_DATE
				$corragate:=<>MAGIC_DATE
				$stamping:=<>MAGIC_DATE
				$acetate:=<>MAGIC_DATE
				$laser:=<>MAGIC_DATE
				$other:=<>MAGIC_DATE
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					
					For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
						$comm:=[Raw_Materials_Transactions:23]CommodityCode:24
						$hit:=Find in array:C230($aPOI; [Raw_Materials_Transactions:23]POItemKey:4)
						If ($hit>-1)
							$dateReceived:=$aRecieved{$hit}
							Case of 
								: ($comm=1)  //board
									If ($dateReceived<$board)
										$board:=$dateReceived
									End if 
								: ($comm=2)  //ink
									If ($dateReceived<$ink)
										$ink:=$dateReceived
									End if 
								: ($comm=3)  //coatins
									If ($dateReceived<$coating)
										$coating:=$dateReceived
									End if 
								: ($comm=4)  //plates
									If ($dateReceived<$plates)
										$plates:=$dateReceived
									End if 
								: ($comm=5)  //leaf
									If ($dateReceived<$leaf)
										$leaf:=$dateReceived
									End if 
								: ($comm=6)  //corragee
									If ($dateReceived<$corragate)
										$corragate:=$dateReceived
									End if 
								: ($comm=7)  //stampoing dies
									If ($dateReceived<$stamping)
										$stamping:=$dateReceived
									End if 
								: ($comm=8)  //acetate
									If ($dateReceived<$acetate)
										$acetate:=$dateReceived
									End if 
								: ($comm=13)  //`• mlb - 9/24/01  08:43
									If ([Raw_Materials_Transactions:23]Commodity_Key:22="13-LASER DIES")
										If ($dateReceived<$laser)
											$laser:=$dateReceived
										End if 
									End if 
								Else 
									If ($dateReceived<$other)
										$other:=$dateReceived
									End if 
							End case 
						End if 
						NEXT RECORD:C51([Raw_Materials_Transactions:23])
					End for 
					
				Else 
					
					ARRAY TEXT:C222($_Commodity_Key; 0)
					ARRAY TEXT:C222($_POItemKey; 0)
					ARRAY TEXT:C222(CommodityCode; 0)
					
					SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Commodity_Key:22; $_Commodity_Key; [Raw_Materials_Transactions:23]POItemKey:4; $_POItemKey; [Raw_Materials_Transactions:23]CommodityCode:24; $_CommodityCode)
					
					For ($i; 1; Size of array:C274($_Commodity_Key); 1)
						$comm:=$_CommodityCode{$i}
						$hit:=Find in array:C230($aPOI; $_POItemKey{$i})
						If ($hit>-1)
							$dateReceived:=$aRecieved{$hit}
							Case of 
								: ($comm=1)  //board
									If ($dateReceived<$board)
										$board:=$dateReceived
									End if 
								: ($comm=2)  //ink
									If ($dateReceived<$ink)
										$ink:=$dateReceived
									End if 
								: ($comm=3)  //coatins
									If ($dateReceived<$coating)
										$coating:=$dateReceived
									End if 
								: ($comm=4)  //plates
									If ($dateReceived<$plates)
										$plates:=$dateReceived
									End if 
								: ($comm=5)  //leaf
									If ($dateReceived<$leaf)
										$leaf:=$dateReceived
									End if 
								: ($comm=6)  //corragee
									If ($dateReceived<$corragate)
										$corragate:=$dateReceived
									End if 
								: ($comm=7)  //stampoing dies
									If ($dateReceived<$stamping)
										$stamping:=$dateReceived
									End if 
								: ($comm=8)  //acetate
									If ($dateReceived<$acetate)
										$acetate:=$dateReceived
									End if 
								: ($comm=13)  //`• mlb - 9/24/01  08:43
									If ($_Commodity_Key{$i}="13-LASER DIES")
										If ($dateReceived<$laser)
											$laser:=$dateReceived
										End if 
									End if 
								Else 
									If ($dateReceived<$other)
										$other:=$dateReceived
									End if 
							End case 
						End if 
						
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If ($dateJobStart#!00-00-00!)
					xText:=xText+[Job_Forms_Master_Schedule:67]JobForm:4+$t+String:C10($dateJobStart)+$t+String:C10($dateJobDone)+$t+String:C10($elapse)+$t
					If ($board#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$board)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($ink#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$ink)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($coating#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$coating)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($plates#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$plates)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($leaf#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$leaf)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($stamping#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$stamping)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($acetate#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$acetate)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($laser#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$laser)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($corragate#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$corragate)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					xText:=xText+$cr
					
					
				Else 
					xText:=xText+[Job_Forms_Master_Schedule:67]JobForm:4+$t+"Sheeted Date Not Set"+$cr
				End if 
				NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
				uThermoUpdate($job)
			End for 
			
			
		Else 
			//lagzhaoui remmove next and use set
			ARRAY DATE:C224($_DateStockSheeted; 0)
			ARRAY DATE:C224($_DateComplete; 0)
			ARRAY TEXT:C222($_JobForm; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]DateStockSheeted:47; $_DateStockSheeted; \
				[Job_Forms_Master_Schedule:67]DateComplete:15; $_DateComplete; \
				[Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm)
			
			
			For ($job; 1; $numJobs)
				$dateJobStart:=$_DateStockSheeted{$job}
				$dateJobDone:=$_DateComplete{$job}
				$elapse:=$dateJobDone-$dateJobStart
				ARRAY TEXT:C222($aPOI; 0)
				ARRAY DATE:C224($aRecieved; 0)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$_JobForm{$job}; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				ARRAY LONGINT:C221($_recordnumber; 0)
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]; $_recordnumber)
				DISTINCT VALUES:C339([Raw_Materials_Transactions:23]POItemKey:4; $aPOI)
				$numPOI:=Size of array:C274($aPOI)
				ARRAY DATE:C224($aRecieved; $numPOI)
				For ($i; 1; $numPOI)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$aPOI{$i}; *)
					QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
					SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate)
					If (Size of array:C274($aDate)>0)
						SORT ARRAY:C229($aDate; >)
						$aRecieved{$i}:=$aDate{1}
					Else 
						$aRecieved{$i}:=<>MAGIC_DATE
					End if 
				End for 
				CREATE SELECTION FROM ARRAY:C640([Raw_Materials_Transactions:23]; $_recordnumber)
				ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24)
				
				$board:=<>MAGIC_DATE
				$ink:=<>MAGIC_DATE
				$coating:=<>MAGIC_DATE
				$plates:=<>MAGIC_DATE
				$leaf:=<>MAGIC_DATE
				$corragate:=<>MAGIC_DATE
				$stamping:=<>MAGIC_DATE
				$acetate:=<>MAGIC_DATE
				$laser:=<>MAGIC_DATE
				$other:=<>MAGIC_DATE
				
				ARRAY TEXT:C222($_Commodity_Key; 0)
				ARRAY TEXT:C222($_POItemKey; 0)
				ARRAY TEXT:C222(CommodityCode; 0)
				
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Commodity_Key:22; $_Commodity_Key; [Raw_Materials_Transactions:23]POItemKey:4; $_POItemKey; [Raw_Materials_Transactions:23]CommodityCode:24; $_CommodityCode)
				
				For ($i; 1; Size of array:C274($_Commodity_Key); 1)
					$comm:=$_CommodityCode{$i}
					$hit:=Find in array:C230($aPOI; $_POItemKey{$i})
					If ($hit>-1)
						$dateReceived:=$aRecieved{$hit}
						Case of 
							: ($comm=1)  //board
								If ($dateReceived<$board)
									$board:=$dateReceived
								End if 
							: ($comm=2)  //ink
								If ($dateReceived<$ink)
									$ink:=$dateReceived
								End if 
							: ($comm=3)  //coatins
								If ($dateReceived<$coating)
									$coating:=$dateReceived
								End if 
							: ($comm=4)  //plates
								If ($dateReceived<$plates)
									$plates:=$dateReceived
								End if 
							: ($comm=5)  //leaf
								If ($dateReceived<$leaf)
									$leaf:=$dateReceived
								End if 
							: ($comm=6)  //corragee
								If ($dateReceived<$corragate)
									$corragate:=$dateReceived
								End if 
							: ($comm=7)  //stampoing dies
								If ($dateReceived<$stamping)
									$stamping:=$dateReceived
								End if 
							: ($comm=8)  //acetate
								If ($dateReceived<$acetate)
									$acetate:=$dateReceived
								End if 
							: ($comm=13)  //`• mlb - 9/24/01  08:43
								If ($_Commodity_Key{$i}="13-LASER DIES")
									If ($dateReceived<$laser)
										$laser:=$dateReceived
									End if 
								End if 
							Else 
								If ($dateReceived<$other)
									$other:=$dateReceived
								End if 
						End case 
					End if 
					
				End for 
				
				If ($dateJobStart#!00-00-00!)
					xText:=xText+$_JobForm{$job}+$t+String:C10($dateJobStart)+$t+String:C10($dateJobDone)+$t+String:C10($elapse)+$t
					If ($board#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$board)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($ink#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$ink)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($coating#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$coating)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($plates#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$plates)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($leaf#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$leaf)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($stamping#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$stamping)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($acetate#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$acetate)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($laser#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$laser)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					If ($corragate#<>MAGIC_DATE)
						xText:=xText+String:C10($dateJobStart-$corragate)+$t
					Else 
						xText:=xText+"N/A"+$t
					End if 
					xText:=xText+$cr
					
					
				Else 
					xText:=xText+$_JobForm{$job}+$t+"Sheeted Date Not Set"+$cr
				End if 
				uThermoUpdate($job)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		uThermoClose
		
		xTitle:="Just-in-time Analysis - Positive Days Means before Sheeting, "+"Negative Days is after"
		rPrintText("JIT-"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls")
		
	Else 
		BEEP:C151
		ALERT:C41("No Jobforms completed in that date range.")
	End if 
End if   //search  