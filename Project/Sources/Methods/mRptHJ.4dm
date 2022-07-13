//%attributes = {"publishedWeb":true}
//(P) mRptHJ: Produces Monthly Hours Journal Report

C_DATE:C307(dFrom; dTo)

SET MENU BAR:C67(5)
//uCenterWindow (250;100;1;"")
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
aMMYY:=""
aMonthYear:=""
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select_9.1")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175

If (OK=1)
	gGetDate(Substring:C12(aMMYY; 3; 2); Substring:C12(aMMYY; 1; 2))
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		For (i; 1; 7)
			If (Day number:C114(dFrom)=1)
				dweek1:=dFrom
				dweek2:=dFrom+7
				dweek3:=dFrom+14
				dweek4:=dFrom+21
				dweek5:=dTo
			End if 
			dFrom:=dFrom+1
		End for 
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
			ALERT:C41("No records found!!!")
		Else 
			//---------------------------------------------------------
			//$file:="["+Table name(->[MachineTicket])+"]"
			//zSort:=$file+Fieldname(»[MachineTicket]CostCenterID)+";>"
			//;"+"[MachineTicket]"+Fieldname(»[MachineTicket]DateEntered)+";>
			//;"+"[JobForm]"+Fieldname(»[JobForm]JobType)+";>
			//;"+"[MachineTicket]"+Fieldname(»[MachineTicket]Sequence)+";>"
			//zSort:=$file+Field name(->[MachineTicket]CostCenterID)+";>;"+"
			//«[MachineTicket]"+Field name(->[MachineTicket]DateEntered)+";>;"+"
			//«[MachineTicket]"+Field name(->[MachineTicket]Sequence)+";>"
			//---------------------------------------------------------
			//AUTOMATIC RELATIONS(True;False)
			//gRptSort 
			ORDER BY:C49([Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]Sequence:3; >)
			//AUTOMATIC RELATIONS(False;False)
			If (OK=1)
				SET WINDOW TITLE:C213("MONTHLY HOURS JOURNAL REPORT")
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "HoursJrnlRept")
				util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "HoursJrnlRept")
				BREAK LEVEL:C302(1)
				ACCUMULATE:C303(rPrepHrs; rProdHrs; rRDHrs; rTotHrs; rDLDol; rOHDol; rPrepDL; rPrepOH; rProdDL; rProdOH; rRDDL; rRDOH; rTotDL; rTotOH)
				PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61])
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
				gSetWindTitle
			End if 
		End if 
	Else 
		BEEP:C151
		BEEP:C151
		ALERT:C41("Actuals do not exist for specified date.  Please try again.")
	End if 
End if 

MESSAGES ON:C181