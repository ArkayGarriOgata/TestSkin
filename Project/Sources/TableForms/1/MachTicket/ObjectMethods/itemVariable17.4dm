$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
$jobit:=JMI_makeJobIt(sMAJob; iMaItemNo)
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
If ($numFound=0)
	uConfirm($jobit+" is not a valid job item."; "Try Again"; "Help")
	iMaItemNo:=0
	GOTO OBJECT:C206(iMaItemNo)
End if 