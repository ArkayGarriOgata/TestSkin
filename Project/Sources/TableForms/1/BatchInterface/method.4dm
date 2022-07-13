Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Not:C34(debug))
			$ticksBetweenCheck:=60*60*5
		Else 
			$ticksBetweenCheck:=60*60*1
		End if 
		SET TIMER:C645($ticksBetweenCheck)
		zwStatusMsg("BatchRunner"; "Will run in "+String:C10((delayUntil-TSTimeStamp)/60; "###,##0.0")+" minutes.")
		
		For ($i; 1; Size of array:C274(asBull))
			asBull{$i}:=""
		End for 
		
		i1:=rememberI1
		i2:=rememberI2
		i3:=rememberI3
		$windowTitle:="Configured for "
		If (i1=1)
			//Batch_runnerDaily ("√")
			Batch_RunnerGetSet(->[y_batches:10]Daily:5; "X")
			$windowTitle:=$windowTitle+"Daily "
		Else 
			//Batch_runnerDaily ("")
			Batch_RunnerGetSet(->[y_batches:10]Daily:5; "")
		End if 
		
		If (i2=1)
			//Batch_runnerWeekly ("√")
			Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "X")
			$windowTitle:=$windowTitle+"Weekly "
		Else 
			//Batch_runnerWeekly ("")
			Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "")
		End if 
		
		If (i3=1)
			//Batch_runnerMonthly ("√")
			Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "X")
			$windowTitle:=$windowTitle+"Monthly "
		Else 
			//Batch_runnerMonthly ("")
			Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "")
		End if 
		//SET WINDOW TITLE($windowTitle)
		
	: (Form event code:C388=On Timer:K2:25)
		$tickle_server:=4D_Current_date
		$now:=TSTimeStamp
		If ($now>=delayUntil)
			ok:=1
			ACCEPT:C269
			zwStatusMsg("BatchRunner"; "Starting")
			BEEP:C151
			BEEP:C151
		Else 
			
			zwStatusMsg("BatchRunner"; "Will run in "+String:C10((delayUntil-TSTimeStamp)/60; "###,##0.0")+" minutes.")
		End if 
End case 