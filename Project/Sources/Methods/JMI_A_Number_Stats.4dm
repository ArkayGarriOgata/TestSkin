//%attributes = {}
// -------
// Method: JMI_A_Number_Stats   ( ) ->
// By: Mel Bohince @ 09/21/17, 10:44:22
// Description
// find historical info based on outline number
// ----------------------------------------------------
// Added by: Mel Bohince (8/14/19) added a couple columns

C_TEXT:C284($1)
C_DATE:C307($2; $3; dDateBegin; dDateEnd; $To)

If (Count parameters:C259=0)
	
	<>pid_:=New process:C317("JMI_A_Number_Stats"; <>lMidMemPart; "JMI_A_Number_Stats"; "init")
	If (False:C215)
		JMI_A_Number_Stats
	End if 
	
Else 
	Case of 
			
		: ($1="init")
			
			$jobsCompleteFrom:=Date:C102(FiscalYear("start"; 4D_Current_date))
			$jobsCompleteTo:=Add to date:C393($jobsCompleteFrom; 1; 0; -1)
			$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
			dDateBegin:=$jobsCompleteFrom
			dDateEnd:=$jobsCompleteTo
			
			DIALOG:C40([zz_control:1]; "DateRange2")
			CLOSE WINDOW:C154($winRef)
			//$jobsCompleteFrom:=Date(Request("Jobforms Completed From: ";String($jobsCompleteFrom;Internal date short);"Ok";"Cancel"))
			//$jobsCompleteTo:=Date(Request(" To: ";String($jobsCompleteTo;Internal date short);"Ok";"Cancel"))
			If (ok=1)
				READ ONLY:C145([Job_Forms_Items:44])
				READ ONLY:C145([Job_Forms_Machine_Tickets:61])
				If (bSearch=1)
					QUERY:C277([Job_Forms_Items:44])  //the Find Button
				Else 
					QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39>=dDateBegin; *)
					QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39<=dDateEnd; *)
					QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11>100)
				End if 
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					CREATE SET:C116([Job_Forms_Items:44]; "completedItems")
					
				Else 
				End if   // END 4D Professional Services : January 2019 query selection
				zwStatusMsg("Loading A#'s"; "Please wait...")
				DISTINCT VALUES:C339([Job_Forms_Items:44]OutlineNumber:43; $aOutlines)
				
				C_LONGINT:C283($i; $numElements)
				$numElements:=Size of array:C274($aOutlines)
				ARRAY REAL:C219($aAvgMR; $numElements)
				ARRAY LONGINT:C221($aAvgRate; $numElements)
				ARRAY TEXT:C222($aCCsUsed; $numElements)
				
				uThermoInit($numElements; "Analyzing Outlines")
				For ($a_number; 1; $numElements)
					//get this outline's jobits
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						USE SET:C118("completedItems")
						QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]OutlineNumber:43=$aOutlines{$a_number})
						
						
					Else 
						
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39>=$jobsCompleteFrom; *)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39<=$jobsCompleteTo; *)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11>100; *)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OutlineNumber:43=$aOutlines{$a_number})
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobits)  //remove subform hell
					$numJobs:=Size of array:C274($aJobits)
					//init arrays
					ARRAY REAL:C219($aMR; 0)
					ARRAY REAL:C219($aRun; 0)
					ARRAY LONGINT:C221($aQty; 0)
					ARRAY LONGINT:C221($aRate; 0)
					
					ARRAY REAL:C219($aMR; $numJobs)
					ARRAY REAL:C219($aRun; $numJobs)
					ARRAY LONGINT:C221($aQty; $numJobs)
					ARRAY LONGINT:C221($aRate; $numJobs)
					
					$ttlMR:=0
					$ttlRun:=0
					$ttlQty:=0
					$costCenters:=""
					//get this outline's machine tickets via jobit
					//QUERY WITH ARRAY([Job_Forms_Machine_Tickets]Jobit;$aJobits)
					For ($jobit; 1; $numJobs)
						QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=$aJobits{$jobit})
						//$aMR{$jobit}:=sum([Job_Forms_Machine_Tickets]MR_Act)
						//$aRun{$jobit}:=sum([Job_Forms_Machine_Tickets]Run_Act)
						//$aQty{$jobit}:=Sum([Job_Forms_Machine_Tickets]Good_Units)
						
						$ttlMR:=$ttlMR+Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
						$ttlRun:=$ttlRun+Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
						$ttlQty:=$ttlQty+Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
						DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]CostCenterID:2; $aCC)
						$costCenters:=""
						For ($cc; 1; Size of array:C274($aCC))
							If (Position:C15($aCC{$cc}; $costCenters)=0)
								$costCenters:=$costCenters+$aCC{$cc}+" "
							End if 
						End for   //cc
						//if($aRun{$jobit}>0)
						//$aRate{$jobit}:=$aQty{$jobit}/$aRun{$jobit}
						//Else 
						//$aRate{$jobit}:=0
						//end if
					End for   //jobit
					
					$aAvgMR{$a_number}:=util_roundUp($ttlMR/$numJobs)
					If ($ttlQty>0) & ($ttlRun>0)
						$aAvgRate{$a_number}:=Round:C94($ttlQty/$ttlRun; -2)
					Else 
						$aAvgRate{$a_number}:=0
					End if 
					$aCCsUsed{$a_number}:=$costCenters
					
					uThermoUpdate($a_number)
				End for 
				uThermoClose
				
				C_TEXT:C284($title; $text; $docName)
				C_TIME:C306($docRef)
				$t:="\t"
				$r:="\r"
				$title:="see JMI_A_Number_Stats"
				If (bSearch=0)
					$title:=$title+", from "+String:C10(dDateBegin; Internal date short special:K1:4)+" to "+String:C10(dDateEnd; Internal date short special:K1:4)
				Else 
					$title:=$title+", custom search"
				End if 
				$text:=""
				$docName:="A_Number_Analysis_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
				$docRef:=util_putFileName(->$docName)
				
				If ($docRef#?00:00:00?)
					SEND PACKET:C103($docRef; $title+"\r\r")
					READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
					$text:=$text+"Outline"+$t+"AVG_MR"+$t+"AVG_RATE"+$t+"DIMENSIONS(ABH)"+$t+"STYLE"+$t+"TOP"+$t+"BOTTOM"+$t+"STOCK"+$t+"CALIPER"+$t+"COSTCTRS"+$t+"CUSTOMER"+$t+"SALESREP"+$t+"SAMPLES"+$t+"SUBMITTED"+$t+"EMAILED"+$t+"ADD_REQ"+$r
					
					For ($a_number; 1; $numElements)
						If (Length:C16($text)>25000)
							SEND PACKET:C103($docRef; $text)
							$text:=""
						End if 
						QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$aOutlines{$a_number})
						$text:=$text+$aOutlines{$a_number}+$t+String:C10($aAvgMR{$a_number})+$t+String:C10($aAvgRate{$a_number})+$t+String:C10([Finished_Goods_SizeAndStyles:132]Dim_A:17)+" x "+String:C10([Finished_Goods_SizeAndStyles:132]Dim_B:18)+" x "+String:C10([Finished_Goods_SizeAndStyles:132]Dim_Ht:19)+$t+[Finished_Goods_SizeAndStyles:132]Style:14+$t+[Finished_Goods_SizeAndStyles:132]Top:15+$t+[Finished_Goods_SizeAndStyles:132]Bottom:16+$t+[Finished_Goods_SizeAndStyles:132]StockType:20+$t+String:C10([Finished_Goods_SizeAndStyles:132]StockCaliper:21)+$t+$aCCsUsed{$a_number}+$t
						// Added by: Mel Bohince (8/14/19) 
						If ([Finished_Goods_SizeAndStyles:132]EmailFile:34)
							$emailed:="emailed"
						Else 
							$emailed:="-"
						End if 
						If ([Finished_Goods_SizeAndStyles:132]Samples:28)
							$samples:="samples"
						Else 
							$samples:="-"
						End if 
						$_SalesmanID:=""
						$_SalesCoord:=""
						$_PlannerID:=""
						Cust_getTeam([Finished_Goods_SizeAndStyles:132]CustID:52; ->$_SalesmanID; ->$_SalesCoord; ->$_SalesCoord)
						$text:=$text+CUST_getName([Finished_Goods_SizeAndStyles:132]CustID:52; "elc")+$t+$_SalesmanID+$t+$samples+$t+String:C10([Finished_Goods_SizeAndStyles:132]DateSubmitted:5; Internal date short special:K1:4)+$t+$emailed+$t+String:C10([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54)+$r
						// end Added by: Mel Bohince (8/14/19) 
					End for 
					
					SEND PACKET:C103($docRef; $text)
					SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
					CLOSE DOCUMENT:C267($docRef)
					
					// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
					$err:=util_Launch_External_App($docName)
				End if 
				
			End if   //ok=1
			
	End case 
End if 
