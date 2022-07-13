If ([Job_Forms_Machine_Tickets:61]DownHrs:11>0.083)
	[Job_Forms_Machine_Tickets:61]DownHrs:11:=Round:C94([Job_Forms_Machine_Tickets:61]DownHrs:11-0.083; 2)
Else 
	BEEP:C151
End if 
