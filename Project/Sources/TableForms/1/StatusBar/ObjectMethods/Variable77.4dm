$idx:=<>aPrcsName
$pid:=<>aPrcsNum{$idx}
SHOW PROCESS:C325($pid)
BRING TO FRONT:C326($pid)

If (Process state:C330($pid)=Paused:K13:6)
	$hit:=Find in array:C230(<>lReportPrcs; $pid)
	If ($hit>-1)
		BEEP:C151
		CONFIRM:C162(<>aPrcsName{$idx}+" is waiting until "+TS2String(<>lReportTime{$hit})+"."+Char:C90(13)+"Do you wish to kill it?"; "Kill"; "Let Live")
		If (ok=1)
			While (Semaphore:C143("$RptMngr"))  //another process is updating, must wait
				DELAY PROCESS:C323(Current process:C322; 60)  //wait a second, this isn't critical
			End while 
			
			<>delayCanceled:=True:C214
			RESUME PROCESS:C320($pid)
			
			<>lReportTime{$hit}:=0
			<>lReportPrcs{$hit}:=0
			CLEAR SEMAPHORE:C144("$RptMngr")
			
			uProcessLookup($pid)
			
		End if 
	End if 
End if 
//