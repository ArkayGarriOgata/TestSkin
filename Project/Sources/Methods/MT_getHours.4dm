//%attributes = {}
// -------
// Method: MT_getHours   ( MR | Run | DT | ALL; ) -> hours
// By: Mel Bohince @ 09/22/16, 13:19:11
// Description
// 
// ----------------------------------------------------

If (Length:C16($2)=11)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=$2)
Else 
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$2)
End if 


Case of 
	: (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
		$0:=0
	: ($1="MR")
		$0:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
	: ($1="Run")
		$0:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
	: ($1="DT")
		$0:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
	Else 
		$0:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)+Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)+Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
End case 
