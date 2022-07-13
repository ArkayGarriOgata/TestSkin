//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/31/13, 10:26:44
// ----------------------------------------------------
// Method: mMachTickDo
// Description:
// Code copied here to allow Posting without closing the window.
// ----------------------------------------------------

Est_LogIt("init")

SORT ARRAY:C229(asMACC; asMAJob; adMADate; aiMASeq; aiMAItemNo; arMAMRHours; arMARHours; arMADTHours; asMADTCat; alMAGood; alMAWaste; asP_C; aiShift; aRecNo; aMRcode; >)
$entries:=Size of array:C274(asMACC)

ARRAY LONGINT:C221(alBRS; $entries)  //planned runrate
ARRAY REAL:C219(arRun_AS; $entries)  //actual runrate  
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE EMPTY SET:C140([Job_Forms_Machine_Tickets:61]; "ActualRecs")
	USE SET:C118("ActualRecs")
	
Else 
	//you don't use "ActualRecs"
	REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
	
	
	
End if   // END 4D Professional Services : January 2019 query selection

CREATE EMPTY SET:C140([Job_Forms_Machines:43]; "sequence")  //•121096  mBohince  
For (j; 1; $entries)
	JML_setOperationDone(asMAJob{j}; asMACC{j})  //• mlb - 7/30/02  16:18
	sCostCenter:=CostCtr_Substitution(asMACC{j})  //•042096 TJF   `look up the substitution
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=asMAJob{j}; *)  //validate the budget
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=aiMASeq{j})
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		CREATE SET:C116([Job_Forms_Machines:43]; "sequence")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	Case of 
		: (Records in selection:C76([Job_Forms_Machines:43])=0)
			BEEP:C151
			Est_LogIt("Sequence number "+String:C10(aiMASeq{j})+" not found on Job Form "+asMAJob{j}+"'s budget."; 0)
			
		Else   //whether or not there was a substitution
			QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=sCostCenter; *)
			QUERY SELECTION:C341([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4=asMACC{j})
			If (Records in selection:C76([Job_Forms_Machines:43])=0)
				BEEP:C151
				//Est_LogIt ("Neither Cost Center "+asMACC{j}+" or "+sCostCenter+" is not on on Job Form "+asMAJob{j}+" at sequence "+String(iMASeq)+".";0)
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
					
					USE SET:C118("sequence")
					
				Else 
					
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=asMAJob{j}; *)  //validate the budget
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=aiMASeq{j})
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			End if 
	End case 
	
	alBRS{j}:=0
	arRun_AS{j}:=0
	Case of 
		: (Records in selection:C76([Job_Forms_Machines:43])=0)
			
		: ([Job_Forms_Machines:43]Planned_RunRate:36=0)  // "401 405 442 581"  `upr 163 1/9/95 was <
			If (Position:C15(asMACC{j}; <>PLATEMAKING)=0)
				Est_LogIt("Job # = "+asMAJob{j}+" Cost Center = "+asMACC{j}+" Sequence Number = "+String:C10(aiMASeq{j}; "######0")+".  A Run Speed was not found for this cost center."; 0)
			End if 
			
		Else 
			alBRS{j}:=[Job_Forms_Machines:43]Planned_RunRate:36
			If (alBRS{j}>0)
				If (alMAGood{j}#0)
					If (Position:C15(asMACC{j}; <>SHEETERS)>0)
						$jobIndex:=Find in array:C230(asChkJob; asMAJob{j})
						If ($jobIndex>0)
							arRun_AS{j}:=Round:C94(((alMAGood{j}*arChkLength{$jobIndex})/12)/alBRS{j}; 2)
						End if 
						
					Else 
						arRun_AS{j}:=Round:C94(alMAGood{j}/alBRS{j}; 2)
					End if 
				End if 
			End if 
	End case 
	
	CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])
	[Job_Forms_Machine_Tickets:61]JobForm:1:=asMAJob{j}
	[Job_Forms_Machine_Tickets:61]CostCenterID:2:=asMACC{j}
	[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=aiMAItemNo{j}
	[Job_Forms_Machine_Tickets:61]Sequence:3:=aiMASeq{j}
	[Job_Forms_Machine_Tickets:61]DateEntered:5:=adMADate{j}
	[Job_Forms_Machine_Tickets:61]MR_Act:6:=arMAMRHours{j}  //[MachineTicket]MR_Act+
	[Job_Forms_Machine_Tickets:61]Run_Act:7:=arMARHours{j}  //[MachineTicket]Run_Act+
	[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=uNANCheck(arRun_AS{j})  //[MachineTicket]Run_AdjStd+
	[Job_Forms_Machine_Tickets:61]Good_Units:8:=alMAGood{j}  //[MachineTicket]Good_Units+
	[Job_Forms_Machine_Tickets:61]Waste_Units:9:=alMAWaste{j}  //[MachineTicket]Waste_Units+
	[Job_Forms_Machine_Tickets:61]P_C:10:=asP_C{j}
	[Job_Forms_Machine_Tickets:61]BudRunSpeed:13:=alBRS{j}
	[Job_Forms_Machine_Tickets:61]DownHrs:11:=arMADTHours{j}  //[MachineTicket]DownHrs+
	
	If (arMADTHours{j}>0) & (Length:C16(asMADTCat{j})>0)  // Modified by: Mel Bohince (5/30/17) , zinke code put erronous dt code in
		$hit:=Find in array:C230(atDowntime; asMADTCat{j}+"@")  //begins with, not contains
		If ($hit>-1)
			[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=atDowntime{$hit}
		Else   // Added by: Mark Zinke (1/20/14) 
			C_TEXT:C284(tError)
			ARRAY TEXT:C222(atDowntimeList; 0)
			COPY ARRAY:C226(atDowntime; atDowntimeList)
			DELETE FROM ARRAY:C228(atDowntimeList; 1)  //Remove the blank
			windowTitle:="Machine Ticket Catagory Error"
			tError:="*ERROR*"
			OpenFormWindow(->[zz_control:1]; "MachTickErrorDialog"; ->windowTitle; windowTitle)
			DIALOG:C40([zz_control:1]; "MachTickErrorDialog")
			CLOSE WINDOW:C154
			[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=tError
		End if 
	End if 
	//The drop down list was removed from the entry screen but the text still needs to be stored.
	//ARRAY TEXT(atDowntime;0)  // Added by: Mark Zinke (1/20/14) // Modified by: Mel Bohince (5/30/17) moved to form onload
	//LIST TO ARRAY("Downtime";atDowntime)  // Added by: Mark Zinke (11/21/13) 
	//$xlPosition:=Find in array(atDowntime;"@"+asMADTCat{j}+"@")  // Added by: Mark Zinke (11/21/13) 
	//If ($xlPosition>0)  // Added by: Mark Zinke (1/20/14) 
	//[Job_Forms_Machine_Tickets]DownHrsCat:=atDowntime{$xlPosition}  // Modified by: Mark Zinke (11/21/13) Was asMADTCat{j}
	//Else   // Added by: Mark Zinke (1/20/14) 
	//C_TEXT(tError)
	//ARRAY TEXT(atDowntimeList;0)
	//COPY ARRAY(atDowntime;atDowntimeList)
	//DELETE FROM ARRAY(atDowntimeList;1)  //Remove the blank
	//windowTitle:="Machine Ticket Catagory Error"
	//tError:="*ERROR*"
	//OpenFormWindow (->[zz_control];"MachTickErrorDialog";->windowTitle;windowTitle)
	//DIALOG([zz_control];"MachTickErrorDialog")
	//CLOSE WINDOW
	//[Job_Forms_Machine_Tickets]DownHrsCat:=tError
	//End if 
	[Job_Forms_Machine_Tickets:61]Shift:18:=aiShift{j}  //05/30/00
	[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=aRecNo{j}
	[Job_Forms_Machine_Tickets:61]MRcode:19:=aMRcode{j}  //• mlb - 11/21/02  15:27
	SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		ADD TO SET:C119([Job_Forms_Machine_Tickets:61]; "ActualRecs")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//*Add costs into jobform and job sequence `•112596  
	$MTTotHrs:=arMAMRHours{j}+arMARHours{j}
	$labor:=CostCtrCurrent("Labor"; asMACC{j})
	$burden:=CostCtrCurrent("Burden"; asMACC{j})
	$scrap:=CostCtrCurrent("Scrap"; asMACC{j})
	$MTLabCost:=Round:C94(($MTTotHrs*$labor); 2)
	$MTBurCost:=Round:C94(($MTTotHrs*$burden); 2)
	$MTS_ECost:=Round:C94(($MTTotHrs*$scrap); 2)
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=asMAJob{1})
	If (Records in selection:C76([Job_Forms:42])>0)
		If (Not:C34(Locked:C147([Job_Forms:42])))
			Case of 
				: ([Job_Forms:42]Status:6="Closed")
				: ([Job_Forms:42]Status:6="Complete")
				Else 
					[Job_Forms:42]Status:6:="WIP"
			End case 
			
			If ([Job_Forms:42]StartDate:10=!00-00-00!)  //• 8/4/98 cs insure that start date is set
				[Job_Forms:42]StartDate:10:=adMADate{j}
			Else   //•121498  Systems G3  make sure its earlier
				If ([Job_Forms:42]StartDate:10>adMADate{j})
					[Job_Forms:42]StartDate:10:=adMADate{j}
				End if 
			End if 
			[Job_Forms:42]ActLabCost:37:=uNANCheck([Job_Forms:42]ActLabCost:37+$MTLabCost)
			[Job_Forms:42]ActOvhdCost:38:=uNANCheck([Job_Forms:42]ActOvhdCost:38+$MTBurCost)
			[Job_Forms:42]ActS_ECost:39:=uNANCheck([Job_Forms:42]ActS_ECost:39+$MTS_ECost)
			[Job_Forms:42]ActFormCost:13:=uNANCheck([Job_Forms:42]ActFormCost:13+$MTLabCost+$MTBurCost+$MTS_ECost)
			If (([Job_Forms:42]QtyActProduced:35#0) & ([Job_Forms:42]ActFormCost:13#0))
				[Job_Forms:42]ActCost_M:41:=uNANCheck(Round:C94(([Job_Forms:42]ActFormCost:13/[Job_Forms:42]QtyActProduced:35)*1000; 2))
			Else 
				[Job_Forms:42]ActCost_M:41:=0
			End if 
			SAVE RECORD:C53([Job_Forms:42])
		End if 
	End if 
	
	If (Records in selection:C76([Job_Forms_Machines:43])=0)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			USE SET:C118("sequence")
			
		Else 
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=asMAJob{j}; *)  //validate the budget
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=aiMASeq{j})
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		If (Not:C34(Locked:C147([Job_Forms_Machines:43])))
			[Job_Forms_Machines:43]Actual_Labor:22:=[Job_Forms_Machines:43]Actual_Labor:22+$MTLabCost
			[Job_Forms_Machines:43]Actual_OH:23:=[Job_Forms_Machines:43]Actual_OH:23+$MTBurCost
			[Job_Forms_Machines:43]Actual_SE_Cost:25:=[Job_Forms_Machines:43]Actual_SE_Cost:25+$MTS_ECost
			[Job_Forms_Machines:43]Actual_Qty:19:=[Job_Forms_Machines:43]Actual_Qty:19+alMAGood{j}
			[Job_Forms_Machines:43]Actual_Waste:20:=[Job_Forms_Machines:43]Actual_Waste:20+alMAWaste{j}
			[Job_Forms_Machines:43]Actual_MR_Hrs:24:=[Job_Forms_Machines:43]Actual_MR_Hrs:24+arMAMRHours{j}
			[Job_Forms_Machines:43]Actual_RunHrs:40:=[Job_Forms_Machines:43]Actual_RunHrs:40+arMARHours{j}
			SAVE RECORD:C53([Job_Forms_Machines:43])
		End if 
	End if 
End for   //each entry in the arrays

gMTsizeArrays(0)
gClearMT(4D_Current_date-1)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CLEAR SET:C117("sequence")
	CLEAR SET:C117("ActualRecs")
	
Else 
	
End if   // END 4D Professional Services : January 2019 query selection


//ARRAY TEXT(asChkJob;0)  // Modified by: Mark Zinke (12/26/13) Let the ending of the process clear this one.
//ARRAY REAL(arChkLength;0)  // Modified by: Mark Zinke (12/26/13) Let the ending of the process clear this one.
//ARRAY TEXT(asChkCC;0)  // Modified by: Mark Zinke (12/26/13) Let the ending of the process clear this one.
//ARRAY LONGINT(alBRS;0)  //Planned runrate // Modified by: Mark Zinke (12/26/13) Let the ending of the process clear this one.
//ARRAY REAL(arRun_AS;0)  //Actual runrate // Modified by: Mark Zinke (12/26/13) Let the ending of the process clear this one.

uClearSelection(->[Job_Forms_Machine_Tickets:61])
uClearSelection(->[Job_Forms:42])
uClearSelection(->[Job_Forms_Machines:43])

If (tCalculationLog#"")  // Added by: Mark Zinke (12/26/13) Don't show window if there's nothing in it.
	Est_LogIt("show")
End if 
Est_LogIt("init")