Case of 
	: (Form event code:C388=On Load:K2:1)  //(LP)AskMe  
		AskMe_OnLoad
		AskMeHistory("LoadAll")  // Modified by: Mark Zinke (3/6/13) Changed to LoadAll.
		
	: (Form event code:C388=On Outside Call:K2:11)
		If (<>AskMeCust="KILL")
			CANCEL:C270
		Else 
			AskMe_OnLoad
			BRING TO FRONT:C326(Current process:C322)
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
End case 