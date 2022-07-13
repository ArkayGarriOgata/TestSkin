//%attributes = {"publishedWeb":true}
//Procedure: mMachTick()  12/19/94 
//upr 163 1/9/95
//upr 1425 2/9/95 add another substitution
//2/20/95 eliminate closed jobs from the validate array
//•062695  MLB  UPR 220 add the 487
//•092895  MLB  UPR 1720 add the 488
//•031996  mBohince   try to ice the temp files e.g. 188.tempsel17.46
//•042096 TJF
//•112296    make sure latest costs are used
//•112696    change which effectivity date is used on none budgeted items
//•121096  mBohince  don't create budget records, messes up closeout rpt
//• 4/10/98 cs Nan Checking
//• 8/4/98 cs insure that start date is set
//•121498  Systems G3  UPR make sure start date is not after earliest MT
//• mlb - 11/21/02  15:28 add MR code (text) to qualify make readies when desired

C_LONGINT:C283(i; j; $entries; $jobIndex; iQty)
C_REAL:C285($MTTotHrs; $MTLabCost; $MTBurCost; $MTS_ECost)
C_TEXT:C284(<>xText1; t1)
C_REAL:C285(rPrintMT; rPrintExp)
ARRAY TEXT:C222(asChkJob; 0)
ARRAY REAL:C219(arChkLength; 0)
ARRAY TEXT:C222(asChkCC; 0)

READ ONLY:C145([Customers:16])

Est_LogIt("init")  // Added by: Mark Zinke (11/1/13) 

<>xText1:=""
i:=0  //array size counter
fNewMT:=True:C214
fDelete:=False:C215
uSetUp(1; 1)
windowTitle:="Machine Ticket Entry"
wWindowTitle("Push"; windowTitle)
$winRef:=OpenFormWindow(->[zz_control:1]; "MachTicket"; ->windowTitle; windowTitle; 8)

MESSAGE:C88("  Loading job forms without a Closed Date, Please Wait...")
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Machines:43])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11=!00-00-00!)  //2/20/95

SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; asChkJob; [Job_Forms:42]Lenth:24; arChkLength)
REDUCE SELECTION:C351([Job_Forms:42]; 0)  //•031996  mBohince   try to ice the temp files e.g. 188.tempsel17.46

MESSAGE:C88(Char:C90(13)+"  Loading all cost centers, Please Wait...")
CostCtrCurrent("init"; "00/00/00")

MESSAGE:C88(Char:C90(13)+"  Initializing, Please Wait...")
gMTsizeArrays(0)
gClearMT(4D_Current_date-1)
ERASE WINDOW:C160

If (Count parameters:C259=0)
	DIALOG:C40([zz_control:1]; "MachTicket")
Else 
	bOK:=1
	rPrintMT:=1
	rPrintExp:=1
End if 

CLOSE WINDOW:C154  // Added by: Mark Zinke (11/5/13) Code below is now in mMachTickDo.

//ERASE WINDOW
//If (bOK=1)  // Modified by: Mark Zinke (11/1/13) If changing anything in this If statement change mMachTickDo also.
//SORT ARRAY(asMACC;asMAJob;adMADate;aiMASeq;aiMAItemNo;arMAMRHours;arMARHours;arMADTHours;asMADTCat;alMAGood;alMAWaste;asP_C;aiShift;aRecNo;aMRcode;>)
//$entries:=Size of array(asMACC)
//
//ARRAY LONGINT(alBRS;$entries)  //planned runrate
//ARRAY REAL(arRun_AS;$entries)  //actual runrate  
//
//CREATE EMPTY SET([Job_Forms_Machine_Tickets];"ActualRecs")
//USE SET("ActualRecs")
//MESSAGE(Char(13)+("-"*40))
//CREATE EMPTY SET([Job_Forms_Machines];"sequence")  //•121096  mBohince  
//For (j;1;$entries)
//JML_setOperationDone (asMAJob{j};asMACC{j})  //• mlb - 7/30/02  16:18
//MESSAGE(Char(13)+"• Searching for "+asMAJob{j}+"."+String(aiMASeq{j};"000"))
//sCostCenter:=CostCtr_Substitution (asMACC{j})  //•042096 TJF   `look up the substitution
//QUERY([Job_Forms_Machines];[Job_Forms_Machines]JobForm=asMAJob{j};*)  //validate the budget
//QUERY([Job_Forms_Machines]; & ;[Job_Forms_Machines]Sequence=aiMASeq{j})
//CREATE SET([Job_Forms_Machines];"sequence")
//Case of 
//: (Records in selection([Job_Forms_Machines])=0)
//BEEP
//Est_LogIt ("Sequence number "+String(aiMASeq{j})+" not found on Job Form "+asMAJob{j}+"'s budget.";0)  // Added by: Mark Zinke (11/1/13) 
//MESSAGE(Char(13)+"     Sequence number "+String(aiMASeq{j})+" not found on Job Form "+asMAJob{j}+"'s budget.")
//<>xText1:=<>xText1+Char(13)+"Sequence number "+String(aiMASeq{j})+" not found on Job Form "+asMAJob{j}+"'s budget."
//
//Else   //whether or not there was a substitution
//QUERY SELECTION([Job_Forms_Machines];[Job_Forms_Machines]CostCenterID=sCostCenter;*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID=asMACC{j})
//If (Records in selection([Job_Forms_Machines])=0)
//BEEP
//Est_LogIt ("Neither Cost Center "+asMACC{j}+" or "+sCostCenter+" is not on on Job Form "+asMAJob{j}+" at sequence "+String(iMASeq)+".";0)  // Added by: Mark Zinke (11/1/13) 
//MESSAGE(Char(13)+"     Neither Cost Center "+asMACC{j}+" or "+sCostCenter+" is not on on Job Form "+asMAJob{j}+" at sequence "+String(iMASeq)+".")
//<>xText1:=<>xText1+Char(13)+"Neither Cost Center "+asMACC{j}+" or "+sCostCenter+" is not on on Job Form "+asMAJob{j}+" at sequence "+String(iMASeq)+"."
//  // $valid:=False
//USE SET("sequence")
//End if 
//End case 
//
//alBRS{j}:=0
//arRun_AS{j}:=0
//MESSAGE(Char(13)+"  Calculating adjusted Run hrs.")
//Case of 
//: (Records in selection([Job_Forms_Machines])=0)
//
//: ([Job_Forms_Machines]Planned_RunRate=0)  // "401 405 442 581"  `upr 163 1/9/95 was <
//If (Position(asMACC{j};<>PLATEMAKING)=0)
//Est_LogIt ("Job # = "+asMAJob{j}+" Cost Center = "+asMACC{j}+" Sequence Number = "+String(aiMASeq{j};"######0")+".  A Run Speed was not found for this cost center.";0)  // Added by: Mark Zinke (11/1/13) 
//<>xText1:=<>xText1+Char(13)+"Job # = "+asMAJob{j}+" Cost Center = "+asMACC{j}+" Sequence Number = "+String(aiMASeq{j};"######0")+".  A Run Speed was not found for this cost center."
//End if 
//
//Else 
//alBRS{j}:=[Job_Forms_Machines]Planned_RunRate
//If (alBRS{j}>0)
//If (alMAGood{j}#0)
//
//If (Position(asMACC{j};<>SHEETERS)>0)
//$jobIndex:=Find in array(asChkJob;asMAJob{j})
//If ($jobIndex>0)
//arRun_AS{j}:=Round(((alMAGood{j}*arChkLength{$jobIndex})/12)/alBRS{j};2)
//End if 
//
//Else 
//arRun_AS{j}:=Round(alMAGood{j}/alBRS{j};2)
//End if 
//End if 
//End if 
//
//End case 
//
//MESSAGE(Char(13)+"  Saving Machine Ticket in aMs.")
//CREATE RECORD([Job_Forms_Machine_Tickets])
//[Job_Forms_Machine_Tickets]JobForm:=asMAJob{j}
//[Job_Forms_Machine_Tickets]CostCenterID:=asMACC{j}
//[Job_Forms_Machine_Tickets]GlueMachItemNo:=aiMAItemNo{j}
//[Job_Forms_Machine_Tickets]Sequence:=aiMASeq{j}
//[Job_Forms_Machine_Tickets]DateEntered:=adMADate{j}
//[Job_Forms_Machine_Tickets]MR_Act:=arMAMRHours{j}  //[MachineTicket]MR_Act+
//[Job_Forms_Machine_Tickets]Run_Act:=arMARHours{j}  //[MachineTicket]Run_Act+
//[Job_Forms_Machine_Tickets]Run_AdjStd:=uNANCheck (arRun_AS{j})  //[MachineTicket]Run_AdjStd+
//[Job_Forms_Machine_Tickets]Good_Units:=alMAGood{j}  //[MachineTicket]Good_Units+
//[Job_Forms_Machine_Tickets]Waste_Units:=alMAWaste{j}  //[MachineTicket]Waste_Units+
//[Job_Forms_Machine_Tickets]P_C:=asP_C{j}
//[Job_Forms_Machine_Tickets]BudRunSpeed:=alBRS{j}
//[Job_Forms_Machine_Tickets]DownHrs:=arMADTHours{j}  //[MachineTicket]DownHrs+
//[Job_Forms_Machine_Tickets]DownHrsCat:=asMADTCat{j}
//[Job_Forms_Machine_Tickets]Shift:=aiShift{j}  //05/30/00
//[Job_Forms_Machine_Tickets]TimeStamp:=aRecNo{j}
//[Job_Forms_Machine_Tickets]MRcode:=aMRcode{j}  //• mlb - 11/21/02  15:27
//SAVE RECORD([Job_Forms_Machine_Tickets])
//ADD TO SET([Job_Forms_Machine_Tickets];"ActualRecs")
//
//  //*Add costs into jobform and job sequence `•112596  
//$MTTotHrs:=arMAMRHours{j}+arMARHours{j}
//$labor:=CostCtrCurrent ("Labor";asMACC{j})
//$burden:=CostCtrCurrent ("Burden";asMACC{j})
//$scrap:=CostCtrCurrent ("Scrap";asMACC{j})
//
//$MTLabCost:=Round(($MTTotHrs*$labor);2)
//$MTBurCost:=Round(($MTTotHrs*$burden);2)
//$MTS_ECost:=Round(($MTTotHrs*$scrap);2)
//
//MESSAGE(Char(13)+"  Updating Job form costs")
//QUERY([Job_Forms];[Job_Forms]JobFormID=asMAJob{1})
//If (Records in selection([Job_Forms])>0)
//If (Not(Locked([Job_Forms])))
//Case of 
//: ([Job_Forms]Status="Closed")
//: ([Job_Forms]Status="Complete")
//Else 
//[Job_Forms]Status:="WIP"
//End case 
//
//If ([Job_Forms]StartDate=!00/00/00!)  //• 8/4/98 cs insure that start date is set
//[Job_Forms]StartDate:=adMADate{j}
//Else   //•121498  Systems G3  make sure its earlier
//If ([Job_Forms]StartDate>adMADate{j})
//[Job_Forms]StartDate:=adMADate{j}
//End if 
//End if 
//[Job_Forms]ActLabCost:=uNANCheck ([Job_Forms]ActLabCost+$MTLabCost)
//[Job_Forms]ActOvhdCost:=uNANCheck ([Job_Forms]ActOvhdCost+$MTBurCost)
//[Job_Forms]ActS_ECost:=uNANCheck ([Job_Forms]ActS_ECost+$MTS_ECost)
//[Job_Forms]ActFormCost:=uNANCheck ([Job_Forms]ActFormCost+$MTLabCost+$MTBurCost+$MTS_ECost)
//If (([Job_Forms]ActProducedQty#0) & ([Job_Forms]ActFormCost#0))
//[Job_Forms]ActCost_M:=uNANCheck (Round(([Job_Forms]ActFormCost/[Job_Forms]ActProducedQty)*1000;2))
//Else 
//[Job_Forms]ActCost_M:=0
//End if 
//SAVE RECORD([Job_Forms])
//End if 
//End if 
//
//MESSAGE(Char(13)+"  Updating the Job Sequence record")
//If (Records in selection([Job_Forms_Machines])=0)
//USE SET("sequence")
//
//End if 
//If (Records in selection([Job_Forms_Machines])>0)
//If (Not(Locked([Job_Forms_Machines])))
//[Job_Forms_Machines]Actual_Labor:=[Job_Forms_Machines]Actual_Labor+$MTLabCost
//[Job_Forms_Machines]Actual_OH:=[Job_Forms_Machines]Actual_OH+$MTBurCost
//[Job_Forms_Machines]Actual_SE_Cost:=[Job_Forms_Machines]Actual_SE_Cost+$MTS_ECost
//[Job_Forms_Machines]Actual_Qty:=[Job_Forms_Machines]Actual_Qty+alMAGood{j}
//[Job_Forms_Machines]Actual_Waste:=[Job_Forms_Machines]Actual_Waste+alMAWaste{j}
//[Job_Forms_Machines]Actual_MR_Hrs:=[Job_Forms_Machines]Actual_MR_Hrs+arMAMRHours{j}
//[Job_Forms_Machines]Actual_RunHrs:=[Job_Forms_Machines]Actual_RunHrs+arMARHours{j}
//SAVE RECORD([Job_Forms_Machines])
//End if 
//End if 
//
//End for   //each entry in the arrays
//CLEAR SET("sequence")
//
//  // PRINT SETTINGS, Not used
//If (rPrintMT=1)  // set in before phase of the MachTick dialog
//USE SET("ActualRecs")
//FORM SET OUTPUT([Job_Forms_Machine_Tickets];"RptMachTicket")
//util_PAGE_SETUP(->[Job_Forms_Machine_Tickets];"RptMachTicket")
//MESSAGE(Char(13)+"  Printing Machine Ticket Report by Cost Center...")
//ORDER BY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]CostCenterID;>)
//PRINT SELECTION([Job_Forms_Machine_Tickets];*)
//MESSAGE(Char(13)+"  Printing Machine Ticket Report by Job Form...")
//ORDER BY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]JobForm;>;[Job_Forms_Machine_Tickets]CostCenterID;>)
//PRINT SELECTION([Job_Forms_Machine_Tickets];*)
//End if 
//
//If (rPrintExp=1)  // set in before phase of the MachTick dialog
//If (<>xText1="")
//ALERT(Uppercase("No exceptions or problems to report."))
//
//Else 
//FORM SET OUTPUT([Job_Forms_Machine_Tickets];"RptMTExcept")
//util_PAGE_SETUP(->[Job_Forms_Machine_Tickets];"RptMTExcept")
//FIRST RECORD([Job_Forms_Machine_Tickets])
//ONE RECORD SELECT([Job_Forms_Machine_Tickets])
//MESSAGE(Char(13)+"  Printing Machine Ticket Exceptions Report...")
//PRINT SELECTION([Job_Forms_Machine_Tickets];*)
//End if 
//End if 
//
//FORM SET OUTPUT([Job_Forms_Machine_Tickets];"List")
//
//Est_LogIt ("show")  // Added by: Mark Zinke (11/1/13) 
//Est_LogIt ("init")  // Added by: Mark Zinke (11/1/13) 
//End if 
//
//CLEAR SET("ActualRecs")
//ARRAY TEXT(asChkJob;0)
//ARRAY REAL(arChkLength;0)
//ARRAY TEXT(asChkCC;0)
//  //•112296    clear these arrays
//ARRAY LONGINT(alBRS;0)  //planned runrate
//ARRAY REAL(arRun_AS;0)  //actual runrate
//
//uClearSelection (->[Job_Forms_Machine_Tickets])
//uClearSelection (->[Job_Forms])
//uClearSelection (->[Job_Forms_Machines])
//READ ONLY([Job_Forms])
//READ ONLY([Job_Forms_Machines])
//
//CLOSE WINDOW($winRef)
//wWindowTitle ("Pop")