//%attributes = {"publishedWeb":true}
//PM:  rptMachineLog  061699  mlb UPR 2055
//print a date ranges production grouped by Production Group
//•6/18/99  MLB  exceed the 32k variable limit
C_DATE:C307(dDateBegin; $1; dDateEnd; $2; $latestEff)
C_TEXT:C284(xTitle; xText)
C_TEXT:C284($t; $cr)
C_TIME:C306($docRef)
C_REAL:C285(rReal1; rReal2; rReal3; rReal4; rReal5; rReal6; rReal7; rReal8)
C_REAL:C285(rReal1t; rReal2t; rReal3t; rReal4t; rReal5t; rReal6t; rReal7t; rReal8t)
C_REAL:C285(rReal1a; rReal2a; rReal3a; rReal4a; rReal5a; rReal6a; rReal7a; rReal8a)

$t:=Char:C90(9)
$cr:=Char:C90(13)

MESSAGES OFF:C175

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Cost_Centers:27])

//*Get the date range of interest
If (Count parameters:C259=0)
	NewWindow(340; 215; 6; 0; "Enter date range")
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154
Else 
	dDateBegin:=$1
	dDateEnd:=$2
	OK:=1
End if 

If (OK=1)
	//*Get the machineTickets in the period  
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "MTs")
			
			
		Else 
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		//*Find the associated CC records, but only the latest effectivity   
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Cost_Centers:27]ID:1; ->[Job_Forms_Machine_Tickets:61]CostCenterID:2)
			
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Cost_Centers:27])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Job_Forms_Machine_Tickets:61]; [Cost_Centers:27])
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; >)
		//$latestEff:=[Cost_Centers]EffectivityDate
		//QUERY SELECTION([Cost_Centers];[Cost_Centers]EffectivityDate=$latestEff)
		$numCC:=Records in selection:C76([Cost_Centers:27])
		If ($numCC>0)
			ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2; >; [Cost_Centers:27]ID:1; >)
			xTitle:="M A C H I N E   L O G  from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)
			xText:="jobform"+$t+"seq"+$t+"c/c "+$t+"item"+$t+"#MR"+$t+"MRhrs "+$t+"Runhrs"+$t+"DownHrs"+$t+"NonshopHrs"+$t+"Totl "+$t+"Dwn code"+$t+"Produced"+$t+"Waste"+$t+"p/c"+$t+"shift"+$t+"customer"+$t+"line"+$cr
			
			docName:="MachineLog_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			$docRef:=util_putFileName(->docName)
			SEND PACKET:C103($docRef; xTitle+$cr+$cr)
			
			$lastGrp:=Substring:C12([Cost_Centers:27]cc_Group:2; 4)
			xText:=xText+$lastGrp+$cr
			rReal1:=0
			rReal2:=0
			rReal3:=0
			rReal4:=0
			rReal5:=0
			rReal6:=0
			rReal7:=0
			rReal8:=0
			rReal1a:=0
			rReal2a:=0
			rReal3a:=0
			rReal4a:=0
			rReal5a:=0
			rReal6a:=0
			rReal7a:=0
			rReal8a:=0
			rReal1t:=0
			rReal2t:=0
			rReal3t:=0
			rReal4t:=0
			rReal5t:=0
			rReal6t:=0
			rReal7t:=0
			rReal8t:=0
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For ($i; 1; $numCC)
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					
					If ($lastGrp#(Substring:C12([Cost_Centers:27]cc_Group:2; 4)))
						rReal1t:=rReal1t+rReal1
						rReal2t:=rReal2t+rReal2
						rReal3t:=rReal3t+rReal3
						rReal4t:=rReal4t+rReal4
						rReal5t:=rReal5t+rReal5
						rReal6t:=rReal6t+rReal6
						rReal7t:=rReal7t+rReal7
						rReal8t:=rReal8t+rReal8
						xText:=xText+""+$t+""+$t+""+$t+""+$t
						xText:=xText+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t
						xText:=xText+""+$t+"__________"+$t+"__________"+$cr
						
						xText:=xText+""+$t+""+$t+""+$t+""+$t
						xText:=xText+String:C10(rReal1)+$t+String:C10(rReal2)+$t+String:C10(rReal3)+$t+String:C10(rReal4)+$t+String:C10(rReal5)+$t+String:C10(rReal6)+$t
						xText:=xText+""+$t+String:C10(rReal7)+$t+String:C10(rReal8)+$cr
						rReal1:=0
						rReal2:=0
						rReal3:=0
						rReal4:=0
						rReal5:=0
						rReal6:=0
						rReal7:=0
						rReal8:=0
						$lastGrp:=Substring:C12([Cost_Centers:27]cc_Group:2; 4)
						xText:=xText+$cr+$lastGrp+$cr
					End if 
					
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
						USE SET:C118("MTs")
						
						QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1)
						
					Else 
						QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
						QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd; *)
						QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1)
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					
					ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
					For ($j; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
						rReal1:=rReal1+0  //number of Make readies
						rReal2:=rReal2+[Job_Forms_Machine_Tickets:61]MR_Act:6
						rReal3:=rReal3+[Job_Forms_Machine_Tickets:61]Run_Act:7
						rReal4:=rReal4+[Job_Forms_Machine_Tickets:61]DownHrs:11
						rReal5:=rReal5+0
						rReal6:=rReal6+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]DownHrs:11+0
						rReal7:=rReal7+[Job_Forms_Machine_Tickets:61]Good_Units:8
						rReal8:=rReal8+[Job_Forms_Machine_Tickets:61]Waste_Units:9
						xText:=xText+[Job_Forms_Machine_Tickets:61]JobForm:1+$t+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")+$t+[Job_Forms_Machine_Tickets:61]CostCenterID:2+$t+String:C10([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; "00")+$t
						xText:=xText+String:C10(0)+$t+String:C10([Job_Forms_Machine_Tickets:61]MR_Act:6)+$t+String:C10([Job_Forms_Machine_Tickets:61]Run_Act:7)+$t+String:C10([Job_Forms_Machine_Tickets:61]DownHrs:11)+$t+String:C10(0)+$t+String:C10([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]DownHrs:11+0)+$t
						xText:=xText+[Job_Forms_Machine_Tickets:61]DownHrsCat:12+$t+String:C10([Job_Forms_Machine_Tickets:61]Good_Units:8)+$t+String:C10([Job_Forms_Machine_Tickets:61]Waste_Units:9)+$t+[Job_Forms_Machine_Tickets:61]P_C:10+$t
						QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([Job_Forms_Machine_Tickets:61]JobForm:1; 1; 5))))
						xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]Shift:18)+$t+[Jobs:15]CustomerName:5+$t+[Jobs:15]Line:3+$cr
						NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
					End for 
					NEXT RECORD:C51([Cost_Centers:27])
				End for 
				
			Else 
				
				// Laghzaoui change two next and use and query selection
				ARRAY TEXT:C222($_cc_Group; 0)
				ARRAY TEXT:C222($_ID_Cost_Centers; 0)
				
				SELECTION TO ARRAY:C260([Cost_Centers:27]cc_Group:2; $_cc_Group; \
					[Cost_Centers:27]ID:1; $_ID_Cost_Centers)
				
				For ($i; 1; $numCC)
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					
					If ($lastGrp#(Substring:C12($_cc_Group{$i}; 4)))
						rReal1t:=rReal1t+rReal1
						rReal2t:=rReal2t+rReal2
						rReal3t:=rReal3t+rReal3
						rReal4t:=rReal4t+rReal4
						rReal5t:=rReal5t+rReal5
						rReal6t:=rReal6t+rReal6
						rReal7t:=rReal7t+rReal7
						rReal8t:=rReal8t+rReal8
						xText:=xText+""+$t+""+$t+""+$t+""+$t
						xText:=xText+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t
						xText:=xText+""+$t+"__________"+$t+"__________"+$cr
						
						xText:=xText+""+$t+""+$t+""+$t+""+$t
						xText:=xText+String:C10(rReal1)+$t+String:C10(rReal2)+$t+String:C10(rReal3)+$t+String:C10(rReal4)+$t+String:C10(rReal5)+$t+String:C10(rReal6)+$t
						xText:=xText+""+$t+String:C10(rReal7)+$t+String:C10(rReal8)+$cr
						rReal1:=0
						rReal2:=0
						rReal3:=0
						rReal4:=0
						rReal5:=0
						rReal6:=0
						rReal7:=0
						rReal8:=0
						$lastGrp:=Substring:C12($_cc_Group{$i}; 4)
						xText:=xText+$cr+$lastGrp+$cr
					End if 
					
					
					QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
					QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd; *)
					QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=$_ID_Cost_Centers{$i})
					
					ARRAY TEXT:C222($_CostCenterID; 0)
					ARRAY DATE:C224($_DateEntered; 0)
					ARRAY REAL:C219($_MR_Act; 0)
					ARRAY REAL:C219($_Run_Act; 0)
					ARRAY REAL:C219($_DownHrs; 0)
					ARRAY LONGINT:C221($_Good_Units; 0)
					ARRAY LONGINT:C221($_Waste_Units; 0)
					ARRAY TEXT:C222($_JobForm; 0)
					ARRAY INTEGER:C220($_Sequence; 0)
					ARRAY INTEGER:C220($_GlueMachItemNo; 0)
					ARRAY TEXT:C222($_DownHrsCat; 0)
					ARRAY TEXT:C222($_P_C; 0)
					ARRAY TEXT:C222($_JobForm; 0)
					ARRAY LONGINT:C221($_Shift; 0)
					
					SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
						[Job_Forms_Machine_Tickets:61]DateEntered:5; $_DateEntered; \
						[Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; \
						[Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; \
						[Job_Forms_Machine_Tickets:61]DownHrs:11; $_DownHrs; \
						[Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units; \
						[Job_Forms_Machine_Tickets:61]Waste_Units:9; $_Waste_Units; \
						[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm; \
						[Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence; \
						[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $_GlueMachItemNo; \
						[Job_Forms_Machine_Tickets:61]DownHrsCat:12; $_DownHrsCat; \
						[Job_Forms_Machine_Tickets:61]P_C:10; $_P_C; \
						[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm; \
						[Job_Forms_Machine_Tickets:61]Shift:18; $_Shift)
					
					SORT ARRAY:C229($_CostCenterID; $_DateEntered; $_MR_Act; $_Run_Act; $_DownHrs; $_Good_Units; $_Waste_Units; $_JobForm; $_Sequence; $_GlueMachItemNo; $_DownHrsCat; $_P_C; $_JobForm; $_Shift; >)
					
					For ($j; 1; Size of array:C274($_CostCenterID); 1)
						rReal1:=rReal1+0  //number of Make readies
						rReal2:=rReal2+$_MR_Act{$j}
						rReal3:=rReal3+$_Run_Act{$j}
						rReal4:=rReal4+$_DownHrs{$j}
						rReal5:=rReal5+0
						rReal6:=rReal6+$_MR_Act{$j}+$_Run_Act{$j}+$_DownHrs{$j}+0
						rReal7:=rReal7+$_Good_Units{$j}
						rReal8:=rReal8+$_Waste_Units{$j}
						xText:=xText+$_JobForm{$j}+$t+String:C10($_Sequence{$j}; "000")+$t+$_CostCenterID{$j}+$t+String:C10($_GlueMachItemNo{$j}; "00")+$t
						xText:=xText+String:C10(0)+$t+String:C10($_MR_Act{$j})+$t+String:C10($_Run_Act{$j})+$t+String:C10($_DownHrs{$j})+$t+String:C10(0)+$t+String:C10($_MR_Act{$j}+$_Run_Act{$j}+$_DownHrs{$j}+0)+$t
						xText:=xText+$_DownHrsCat{$j}+$t+String:C10($_Good_Units{$j})+$t+String:C10($_Waste_Units{$j})+$t+$_P_C{$j}+$t
						QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12($_JobForm{$j}; 1; 5))))
						xText:=xText+String:C10($_Shift{$j})+$t+[Jobs:15]CustomerName:5+$t+[Jobs:15]Line:3+$cr
						
					End for 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 
			
			rReal1t:=rReal1t+rReal1
			rReal2t:=rReal2t+rReal2
			rReal3t:=rReal3t+rReal3
			rReal4t:=rReal4t+rReal4
			rReal5t:=rReal5t+rReal5
			rReal6t:=rReal6t+rReal6
			rReal7t:=rReal7t+rReal7
			rReal8t:=rReal8t+rReal8
			xText:=xText+""+$t+""+$t+""+$t+""+$t
			xText:=xText+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t+"__________"+$t
			xText:=xText+""+$t+"__________"+$t+"__________"+$cr
			
			xText:=xText+""+$t+""+$t+""+$t+""+$t
			xText:=xText+String:C10(rReal1)+$t+String:C10(rReal2)+$t+String:C10(rReal3)+$t+String:C10(rReal4)+$t+String:C10(rReal5)+$t+String:C10(rReal6)+$t
			xText:=xText+""+$t+String:C10(rReal7)+$t+String:C10(rReal8)+$cr
			
			xText:=xText+""+$t+""+$t+""+$t+""+$t
			xText:=xText+"=========="+$t+"=========="+$t+"=========="+$t+"=========="+$t+"=========="+$t+"=========="+$t
			xText:=xText+""+$t+"=========="+$t+"=========="+$cr
			
			xText:=xText+""+$t+""+$t+""+$t+""+$t
			xText:=xText+String:C10(rReal1t)+$t+String:C10(rReal2t)+$t+String:C10(rReal3t)+$t+String:C10(rReal4t)+$t+String:C10(rReal5t)+$t+String:C10(rReal6t)+$t
			xText:=xText+""+$t+String:C10(rReal7t)+$t+String:C10(rReal8t)+$cr
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				CLEAR SET:C117("MTs")
				
			Else 
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
			$err:=util_Launch_External_App(docName)
			
			xTitle:=""
			xText:=""
			
		Else 
			BEEP:C151
			ALERT:C41("No C/C records were found to match those MachineTickets.")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("There were NO Machine Tickets found to Print in the Date Range: "+String:C10(dDateBegin)+" - "+String:C10(dDateEnd))  //• 4/22/97 cs    
	End if 
End if 