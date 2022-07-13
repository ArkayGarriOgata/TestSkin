
//check for requirements to change status
Case of 
	: (astat=0)
		//nothing selected
	: (astat{astat}="")
		//list currently contains spaces for readablility
		
	: (astat{astat}=[Process_Specs:18]Status:2)
		//no change requested
		
	Else   //pre requisites have been met
		[Process_Specs:18]Status:2:=astat{astat}
		
End case 

//eop