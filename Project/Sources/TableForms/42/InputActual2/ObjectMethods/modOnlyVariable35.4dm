If (Records in set:C195("clickedIncluded")>0)
	uConfirm("Select one or more Machine Ticket records to delete."; "Delete"; "Cancel")
	If (ok=1)
		USE SET:C118("clickedIncluded")
		util_DeleteSelection(->[Job_Forms_Machine_Tickets:61])
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms:42]JobFormID:5)
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		COPY NAMED SELECTION:C331([Job_Forms_Machine_Tickets:61]; "machTicks")
	End if 
Else 
	uConfirm("Select one or more Machine Ticket records to delete."; "OK"; "Help")
End if 