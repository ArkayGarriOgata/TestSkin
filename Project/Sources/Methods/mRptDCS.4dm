//%attributes = {"publishedWeb":true}
//(P) mRptDCS: Produces Daily Cost Center Input Summary Report

SET MENU BAR:C67(5)
//uCenterWindow (260;130;1;"")
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
dFrom:=!00-00-00!
dTo:=!00-00-00!
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select3.0")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175
iPage:=0

If (OK=1)
	If (dFrom#!00-00-00!)
		If (dTo=!00-00-00!)
			dTo:=dFrom
		End if 
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
			ALERT:C41("No records found!!!")
		Else 
			
			$file:="["+Table name:C256(->[Job_Forms_Machine_Tickets:61])+"]"
			zSort:=$file+Field name:C257(->[Job_Forms_Machine_Tickets:61]DateEntered:5)+";>;"+$file+Field name:C257(->[Job_Forms_Machine_Tickets:61]CostCenterID:2)+";>"
			
			gRptSort
			If (OK=1)
				SET WINDOW TITLE:C213("DAILY COST CENTER INPUT SUMMARY REPORT")
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "DailySumRept")
				util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "DailySumRept")
				ACCUMULATE:C303(rMRHrs; rRunHrs; rSubTotHrs; rDownHrs; rTotHrs)
				BREAK LEVEL:C302(2; 1)
				PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61])
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
				gSetWindTitle
			End if 
		End if 
	End if 
End if 

MESSAGES ON:C181