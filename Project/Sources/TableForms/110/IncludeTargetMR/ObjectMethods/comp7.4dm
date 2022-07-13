//OM: Duration() -> 
//@author mlb - 12/4/01  15:47
Case of 
	: (Form event code:C388=On Getting Focus:K2:7)
		//BEEP
		READ ONLY:C145([ProductionSchedules_MakeReady:126])
		RELATE ONE:C42([ProductionSchedules:110]JobSequence:8)
		
	: (Form event code:C388=On Data Change:K2:15)
		//SAVE RECORD([ProdSchdMakeReady])
		SAVE RECORD:C53([ProductionSchedules:110])
End case 