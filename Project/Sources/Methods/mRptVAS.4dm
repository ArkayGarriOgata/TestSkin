//%attributes = {"publishedWeb":true}
//(P) mRptVAS: Produces Variance Analysis Summary Report

SET MENU BAR:C67(5)
//OPEN WINDOW(150;110;500;360;1)
//uCenterWindow (350;250;1;"")
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
aFrom:=""
aTo:=""
aFromP:=""
xText:=""
dFrom:=!00-00-00!
dTo:=!00-00-00!
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select4.9")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175

If (OK=1)
	aFromP:=Substring:C12(aFrom; 1; 2)+"/"+Substring:C12(aFrom; 3; 2)
	xText:=Substring:C12(aTo; 1; 2)+"/"+Substring:C12(aTo; 3; 2)
	gGetDate(Substring:C12(aFrom; 3; 2); Substring:C12(aFrom; 1; 2))
	$HoldFrom:=dFrom
	gGetDate(Substring:C12(aTo; 3; 2); Substring:C12(aTo; 1; 2))
	dFrom:=$HoldFrom
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
	rDate:=(dTo-dFrom)/365
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
		ALERT:C41("No records found!!!")
	Else 
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >)
		
		SET WINDOW TITLE:C213("VARIANCE ANALYSIS SUMMARY REPORT")
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "VarAnalSumRept")
		util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "VarAnalSumRept")
		ACCUMULATE:C303(rBud_Hrs; rAct_Hrs; rStd_Hrs; rVar; rEVar; rSVar; rVVar; rConvVar)
		BREAK LEVEL:C302(2)
		PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61])
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
		gSetWindTitle
	End if 
End if 

MESSAGES ON:C181