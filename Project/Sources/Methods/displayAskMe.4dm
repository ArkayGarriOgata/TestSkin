//%attributes = {"publishedWeb":true}
If (vAskMePID=0)
	If (Count parameters:C259=1)
		vAskMePID:=uSpawnProcess("sAskMe"; 64000; "AskMe:F/G")
	End if 
	
Else 
	SHOW PROCESS:C325(vAskMePID)
	$state:=Process state:C330(vAskMePID)
	Case of 
		: ($State<0)  //process doesn't exist anymore
			If (Count parameters:C259=1)  //told to create it
				vAskMePID:=uSpawnProcess("sAskMe"; 64000; "AskMe:F/G")
			End if 
			
		: ($State=5)  //process is currently paused
			RESUME PROCESS:C320(vAskMePID)
			POST OUTSIDE CALL:C329(vAskMePID)
			
			
		Else   //process exists, so just resend current info      
			POST OUTSIDE CALL:C329(vAskMePID)
	End case 
End if 