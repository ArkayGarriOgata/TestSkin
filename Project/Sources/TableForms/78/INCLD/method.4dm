Case of 
	: (Form event code:C388=On Load:K2:1)
		//If (Record number([ColorSubmission])=-3)
		//[ColorSubmission]ProjectNo:=[JobMasterLog]ProjectNo
		//End if 
		
		//: (During)
		//If (In=!00/00/00!)
		//SET COLOR(In;-(12+(256*0)))
		//Else 
		//SET COLOR(In;-(15+(256*0)))
		//End if 
		//If (Out=!00/00/00!)
		//SET COLOR(Out;-(12+(256*0)))
		//Else 
		//SET COLOR(Out;-(15+(256*0)))
		//End if 
		//If (Returned=!00/00/00!)
		//SET COLOR(Returned;-(12+(256*0)))
		//Else 
		//SET COLOR(Returned;-(15+(256*0)))
		//End if 
End case 
//