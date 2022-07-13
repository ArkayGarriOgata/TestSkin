
Case of 
	: (rReal1<0)  //• 3/26/97 call from Mellisa problem when bin was not in existance
		BEEP:C151
		ALERT:C41("Please enter a a positive quantity.")
		REJECT:C38
		
	: (sCriterion2="")
		BEEP:C151
		ALERT:C41("Please enter a PO number to tag the bin.")
		REJECT:C38
		
	: (sCriterion3="")
		BEEP:C151
		ALERT:C41("Please enter a Location.")
		REJECT:C38
		
	: (dDate=!00-00-00!)
		BEEP:C151
		ALERT:C41("Please enter a Date.")
		REJECT:C38
End case 
//
//EOS