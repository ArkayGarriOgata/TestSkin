//%attributes = {"publishedWeb":true}
//Job_DailyProdRpt(date)

C_DATE:C307(dDateBegin)

If (Count parameters:C259=0)
	dDateBegin:=Current date:C33-1
	dDateBegin:=Date:C102(Request:C163("Which day do you want the report for?"; String:C10(dDateBegin; System date short:K1:1)))
	$cc:=Request:C163("Which costcenters?"; "@")
Else 
	dDateBegin:=$1
	$cc:="@"
	OK:=1
End if 

If (OK=1)
	If (dDateBegin#!00-00-00!)
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5=dDateBegin; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & [Job_Forms_Machine_Tickets:61]CostCenterID:2=$cc)
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]Shift:18; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >)
			BREAK LEVEL:C302(1; 1)
			ACCUMULATE:C303([Job_Forms_Machine_Tickets:61]MR_Act:6; [Job_Forms_Machine_Tickets:61]Run_Act:7; [Job_Forms_Machine_Tickets:61]Good_Units:8; [Job_Forms_Machine_Tickets:61]DownHrs:11)
			util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "DailyProduction")
			FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "DailyProduction")
			
			PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
			
			FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
			
		Else 
			BEEP:C151
			ALERT:C41("No Machine Tickets for "+String:C10(dDateBegin; System date short:K1:1)+" "+$cc)
		End if 
	End if 
End if 