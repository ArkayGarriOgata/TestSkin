//bzSort: Sort Cost Centers
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
	ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >)
End if 
//EOP