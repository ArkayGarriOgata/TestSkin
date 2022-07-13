ARRAY TEXT:C222($clients; 0)
ARRAY LONGINT:C221($methods; 0)
GET REGISTERED CLIENTS:C650($clients; $methods)
$numClients:=Size of array:C274($clients)
If ($numClients>0)
	zwStatusMsg("Clients"; $clients{1}+" available, backlog: "+String:C10($methods{1}))
	uConfirm(String:C10($numClients)+" are available to you."; "Great"; "ReGen FiFo")
	If (ok=0)  //try a test run
		EXECUTE ON CLIENT:C651($clients{1}; "JIC_Regenerate"; "@")
		
		Repeat 
			zwStatusMsg("Executing"; $clients{1}+" running JIC_Regenerate")
			GET REGISTERED CLIENTS:C650($clients; $methods)
		Until ($methods{1}=0)
		zwStatusMsg("Executing"; $clients{1}+" finished JIC_Regenerate")
		uConfirm("You may now run FIFO based reports with current data."; "Marvelous"; "Yeah")
	End if 
Else 
	uConfirm("No clients have been registered."; "Darn"; "Oh well")
End if 