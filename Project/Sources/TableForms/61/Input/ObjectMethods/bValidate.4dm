$dtCode:=Substring:C12([Job_Forms_Machine_Tickets:61]DownHrsCat:12; 1; 2)
$dtCodesNeedingComment:=" 13 20 21 26 30 44 99 "
$dtCodesAgainstPlant:=" 07 10 15 30 33 35 40 42 44 50 55 60 70 76 80 93 "
$jobRepresentingPlant:="0"+String:C10(Year of:C25(Current date:C33))+".02"
C_BOOLEAN:C305($sendToPrintFlow)  // Modified by: Mel Bohince (2/23/18) 
$sendToPrintFlow:=False:C215
//look for special causes for rejection, else accept
Case of 
		//gotta have something
	: (([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]DownHrs:11+[Job_Forms_Machine_Tickets:61]Good_Units:8+[Job_Forms_Machine_Tickets:61]Waste_Units:9)=0)
		uConfirm("Please enter some time and/or counts."; "Ok"; "Help")
		REJECT:C38
		GOTO OBJECT:C206([Job_Forms_Machine_Tickets:61]MR_Act:6)
		
		//dt needs reason
	: ([Job_Forms_Machine_Tickets:61]DownHrs:11>0) & (Length:C16([Job_Forms_Machine_Tickets:61]DownHrsCat:12)=0)
		uConfirm("Please select catagory for the Downtime."; "Ok"; "Help")
		REJECT:C38
		GOTO OBJECT:C206([Job_Forms_Machine_Tickets:61]DownHrsCat:12)
		
		//dt reason needs hours
	: ([Job_Forms_Machine_Tickets:61]DownHrs:11=0) & (Length:C16([Job_Forms_Machine_Tickets:61]DownHrsCat:12)>0)
		uConfirm("Please enter time for "+[Job_Forms_Machine_Tickets:61]DownHrsCat:12+" or clear the reason."; "Ok"; "Help")
		REJECT:C38
		GOTO OBJECT:C206([Job_Forms_Machine_Tickets:61]DownHrsCat:12)
		
		//some dt on presses need comment
	: (Position:C15(sCC; <>PRESSES)>0) & ([Job_Forms_Machine_Tickets:61]DownHrs:11>0) & (Length:C16([Job_Forms_Machine_Tickets:61]Comment:25)<3) & (Position:C15($dtCode; $dtCodesNeedingComment)>0)
		uConfirm("Comment required for this Downtime category "+[Job_Forms_Machine_Tickets:61]DownHrsCat:12+"."; "Ok"; "Try again")
		REJECT:C38
		GOTO OBJECT:C206([Job_Forms_Machine_Tickets:61]Comment:25)
		
		//some dt goes against plant, not job
	: (Position:C15($dtCode; $dtCodesAgainstPlant)>0) & (([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]Good_Units:8+[Job_Forms_Machine_Tickets:61]Waste_Units:9)=0)
		//uConfirm ("Charge "+[Job_Forms_Machine_Tickets]DownHrsCat+" against the Plant or Job?";"Plant";"Job")
		//If (ok=1)
		[Job_Forms_Machine_Tickets:61]Comment:25:=[Job_Forms_Machine_Tickets:61]Comment:25+" occurred during job "+[Job_Forms_Machine_Tickets:61]JobForm:1
		[Job_Forms_Machine_Tickets:61]JobForm:1:=$jobRepresentingPlant
		//End if 
		ACCEPT:C269
		$sendToPrintFlow:=True:C214
		
	Else 
		ACCEPT:C269
		$sendToPrintFlow:=True:C214
End case 

$jobit:=JMI_makeJobIt([Job_Forms_Machine_Tickets:61]JobForm:1; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4)
$jobformseq:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")
If ($sendToPrintFlow)
	PF_SendTimeAndImpressions($jobformseq; [Job_Forms_Machine_Tickets:61]CostCenterID:2; Substring:C12($jobit; 10; 2); ([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7); [Job_Forms_Machine_Tickets:61]Good_Units:8; (Position:C15("C"; [Job_Forms_Machine_Tickets:61]P_C:10)>0))
End if 