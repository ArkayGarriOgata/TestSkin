// -------
// Method: [zz_control].eBag_dio.MachTickNew   ( ) ->
// Modified by: Mel Bohince (11/29/16)  check if more sheets to completed seq
// Modified by: Mel Bohince (12/1/16) , ignore Case Liners and Misc jobs
C_BOOLEAN:C305($gluingUser; $continue)
$continue:=True:C214
$tabNumber:=Selected list items:C379(ieBagTabs)
GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
iSeq:=Num:C11(Substring:C12($itemText; 1; 3))
sCC:=Substring:C12($itemText; 5; 3)
C_TEXT:C284(iOperator; machineClass)
machineClass:=CostCtr_getClass(sCC)  // Modified by: Mel Bohince (10/19/16) 
$markedComplete:=0  // Modified by: Mel Bohince (11/29/16) check if more sheets to completed seq

$gluingUser:=(Substring:C12(Current user:C182; 1; 4)="Glue")  // Modified by: Mel Bohince (10/12/17) 

If (Position:C15(machineClass; " printer gluer ")>0)  // Modified by: Mel Bohince (10/19/16) 
	//If (Position(sCC;<>PRESSES)>0) | (Position(sCC;<>GLUERS)>0)
	If (Length:C16(iOperator)=0)
		iOperator:=Request:C163("Please enter your initials:"; ""; "Sign in"; "Use Shift")
	End if 
End if 

If (machineClass="gluer")  //Position(sCC;<>gluers)>0)
	
	If (Records in set:C195("clickedIncluded")>0)
		CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
		USE SET:C118("clickedIncluded")
		iItem:=[Job_Forms_Items:44]ItemNumber:7
		If (Length:C16([Job_Forms_Items:44]Gluer:47)=3)  //set in the glue schedule
			sCC:=[Job_Forms_Items:44]Gluer:47
		End if 
		USE NAMED SELECTION:C332("hold")
		
	Else 
		uConfirm("Select a carton first."; "OK"; "Help")
		$continue:=False:C215
	End if 
	
Else 
	iItem:=0
End if 

If (machineClass="sheeter")  // Modified by: Mel Bohince (11/29/16) check if more sheets to completed seq
	If (Not:C34($gluingUser))  // Modified by: Mel Bohince (10/12/17) 
		//see if seq had been marked complete before, then warn if additonal good count is added in this entry
		If (sCriterion1#"020@")  // Modified by: Mel Bohince (12/1/16) , ignore Case Liners and Misc jobs
			SET QUERY DESTINATION:C396(Into variable:K19:4; $markedComplete)
			$jobSeq:=sCriterion1+"."+String:C10(iSeq; "000")
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$jobSeq; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]P_C:10="C")
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
		End if 
	End if 
End if 

dDate:=Current date:C33
// Modified by: Mel Bohince (8/17/17) back date 3rd shift
If (Current time:C178<?04:00:00?)
	dDate:=Add to date:C393(dDate; 0; 0; -1)
End if 

iShift:=SF_GetShift(TSTimeStamp)

If ($continue)
	overwindow:="MachineLog for "+sCriterion1
	<>winX:=<>winX+30
	<>winY:=<>winY+30
	$winRef:=OpenFormWindow(->[Job_Forms_Machine_Tickets:61]; "Input"; ->overwindow; "")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		
		ARRAY LONGINT:C221($_machinetickets; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	Repeat 
		ADD RECORD:C56([Job_Forms_Machine_Tickets:61]; *)
		$complete:=([Job_Forms_Machine_Tickets:61]P_C:10="C")
		//$markedComplete is pre-existing MT marked as complete from a sheeter sequence
		If ($markedComplete>0) & ([Job_Forms_Machine_Tickets:61]Good_Units:8>0)  // Modified by: Mel Bohince (11/29/16) check if more sheets to completed seq
			$distro:=Batch_GetDistributionList(""; "ADD_SHEET")
			$body:="Sheeting operation on "+[Jobs:15]Line:3+": "+[Job_Forms_Machine_Tickets:61]JobForm:1+" had been marked as complete and "+String:C10([Job_Forms_Machine_Tickets:61]Good_Units:8)+" more sheets have been reported as good, please check board allocations."
			EMAIL_Sender("WARNING: Additional Sheets Used on "+[Job_Forms_Machine_Tickets:61]JobFormSeq:16; ""; $body; $distro)
		End if 
		
		If (ok=1)
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				ADD TO SET:C119([Job_Forms_Machine_Tickets:61]; "machinetickets")
				
			Else 
				
				APPEND TO ARRAY:C911($_machinetickets; Record number:C243([Job_Forms_Machine_Tickets:61]))
				
				
			End if   // END 4D Professional Services : January 2019 
			//confirm("Continue with Log entries?";"Continue";"Done")
		End if 
	Until (ok=0) | ($complete)
	CLOSE WINDOW:C154($winRef)
	
	UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
	Else 
		
		CREATE SET FROM ARRAY:C641([Job_Forms_Machine_Tickets:61]; $_machinetickets; "4D_Ps_Set")
		UNION:C120("machinetickets"; "4D_Ps_Set"; "machinetickets")
		CLEAR SET:C117("4D_Ps_Set")
		
	End if   // END 4D Professional Services : January 2019 
	
	USE SET:C118("machinetickets")
	
End if 

// ******* Verified  - 4D PS - January  2019 ********
QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3=Num:C11(Substring:C12($itemText; 1; 3)))

// ******* Verified  - 4D PS - January 2019 (end) *********

//ORDER BY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]Sequence;>;[Job_Forms_Machine_Tickets]GlueMachItemNo;>;[Job_Forms_Machine_Tickets]DateEntered;>;[Job_Forms_Machine_Tickets]P_C;<)
ORDER BY:C49([Job_Forms_Machine_Tickets:61]TimeStampEntered:17; <)