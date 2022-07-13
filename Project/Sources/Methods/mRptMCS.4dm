//%attributes = {"publishedWeb":true}
//(P) mRptMCS: Produces Monthly Cost Center Summary Report

SET MENU BAR:C67(5)
//uCenterWindow (250;100;1;"")
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
aMMYY:=""
aMonthYear:=""
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select3.1")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175

If (OK=1)
	gGetDate(Substring:C12(aMMYY; 3; 2); Substring:C12(aMMYY; 1; 2))
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
		ALERT:C41("No records found!!!")
	Else 
		$file:="["+Table name:C256(->[Job_Forms_Machine_Tickets:61])+"]"
		zSort:=$file+Field name:C257(->[Job_Forms_Machine_Tickets:61]CostCenterID:2)+";>;"+"[JOBform]"+Field name:C257(->[Job_Forms:42]JobType:33)+";>;"+"[MachineTicket]"+Field name:C257(->[Job_Forms_Machine_Tickets:61]Sequence:3)+";>"
		fAutoOne:=True:C214
		fAutoMany:=False:C215
		fAutoBoth:=False:C215
		fSortxForm:=False:C215
		
		gModSort
		If (OK=1)
			SET WINDOW TITLE:C213("MONTHLY COST CENTER SUMMARY REPORT")
			FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "MonthlySumRept")
			util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "MonthlySumRept")
			BREAK LEVEL:C302(2)
			ACCUMULATE:C303(rMRHrs; rRunHrs; rSubTotHrs; rDownHrs; rTotHrs)
			PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61])
			FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
			gSetWindTitle
		End if 
	End if 
End if 

MESSAGES ON:C181