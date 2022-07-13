If (Current user:C182="Administrator")  //Modified by: Mark Zinke (11/19/12)(Current user="Designer") | Removed
	//uConfirm ("Start process to exchange WIP data with FLEX?";"Yes";"No")
	//If (ok=1)
	//uConfirm ("Where do you want the process to run?";"Locally";"On Server")
	//If (ok=1)
	PS_Exchange_Data_with_Flex
	//Else 
	//$pid_server:=Execute on server("PS_Exchange_Data_with_Flex";1024*64;"PS_Exchange_Data_with_Flex_launch")
	//End if 
	//End if 
	CANCEL:C270
Else 
	BEEP:C151
	uConfirm("Not Designer or Administrator, ehh?"; "Ohh"; "Well then")
End if 

