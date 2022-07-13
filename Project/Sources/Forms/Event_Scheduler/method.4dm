
Case of 
	: (Form event code:C388=On Outside Call:K2:11)
		//REDRAW LIST(list_box)
		BEEP:C151
		BEEP:C151
		
	: (Form event code:C388=On Load:K2:1)
		<>kill_event_scheduler:=False:C215
		
	: (Form event code:C388=On Close Box:K2:21)
		<>kill_event_scheduler:=True:C214
		
End case 

