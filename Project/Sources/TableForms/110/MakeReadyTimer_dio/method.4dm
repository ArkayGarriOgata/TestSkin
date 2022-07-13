//FM: CountDownTimer() -> 
//@author mlb - 07/16/03

Case of 
	: (Form event code:C388=On Timer:K2:25)
		C_TIME:C306($now)
		$now:=Current time:C178
		If (running)
			If (iLimit#0)
				tEnd:=tStart+iLimit  //these could have been reset
				iElapse:=$now-tStart
				iRemaining:=tEnd-$now
				sJobSeq:=sJobSeq
				
				If ($now<=tEnd)
					Core_ObjectSetColor(->tTime; -(Black:K11:16+(256*White:K11:1)))
					tTime:=tEnd-$now  //display count down
				Else 
					Core_ObjectSetColor(->tTime; -(Red:K11:4+(256*Black:K11:16)))
					tTime:=$now-tEnd  //display lateness as time
					If (makeSound)
						BEEP:C151
						makeSound:=False:C215
					End if 
					
				End if 
				
				xText:="running"+" Limit= "+Time string:C180(iLimit)+" Elapse= "+Time string:C180(iElapse)+" Start= "+String:C10(tStart; HH MM SS:K7:1)+" End= "+String:C10(tEnd; HH MM SS:K7:1)
				
			Else   //no limit
				tTime:=?00:00:00?
				Core_ObjectSetColor(->tTime; -(White:K11:1+(256*Grey:K11:15)))
				xText:="idle"+" Limit= "+Time string:C180(iLimit)+" Elapse= "+Time string:C180(iElapse)+" Start= "+String:C10(tStart; HH MM SS:K7:1)+" End= "+String:C10(tEnd; HH MM SS:K7:1)
			End if 
			
		Else   //not running
			xText:="idle"+" Limit= "+Time string:C180(iLimit)+" Elapse= "+Time string:C180(iElapse)+" Start= "+String:C10(tStart; HH MM SS:K7:1)+" End= "+String:C10(tEnd; HH MM SS:K7:1)
			If ($now<=tEnd)
				Core_ObjectSetColor(->tTime; -(White:K11:1+(256*Light blue:K11:8)))
			Else 
				Core_ObjectSetColor(->tTime; -(Red:K11:4+(256*Light blue:K11:8)))
			End if 
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		SET TIMER:C645(60*2)
		running:=False:C215
		sJobSeq:=""
		
	: (Form event code:C388=On Close Box:K2:21)
		HIDE PROCESS:C324(<>pidTimer)
		
	: (Form event code:C388=On Outside Call:K2:11)  //kill the process
		CANCEL:C270
End case 