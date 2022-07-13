If (Length:C16([Job_DieBoards:152]PO:16)>0)
	[Job_DieBoards:152]Contact:18:=<>zResp
	READ ONLY:C145([Purchase_Orders:11])
	$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=[Job_DieBoards:152]PO:16)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numFound=0)
		uConfirm("Could not find PO# "+[Job_DieBoards:152]PO:16; "Try Again"; "Help")
	End if 
End if 