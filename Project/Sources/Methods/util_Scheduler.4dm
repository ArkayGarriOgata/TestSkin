//%attributes = {"publishedWeb":true}
//PM: util_Scheduler() -> called bu uNowOrDelay
//fromerly `(P) uReportProcess: starts manager of delayed report execution
//• 8/13/97 cs inssure that if this is called again (re-run /re loggin) 
//  that this does NOT get created 2 or more times

C_LONGINT:C283($pid; $1; $2; $newElement)

If (Count parameters:C259=0)
	$pid:=uProcessID("$SchedulerDaemon")  //• 8/13/97 cs 
	If ($pid=Aborted:K13:1)  //• 8/13/97 cs this process does not exist yet  
		$pid:=New process:C317("util_SchedulerDaemon"; <>lMinMemPart; "$SchedulerDaemon")  //start the report manager process
		If (False:C215)
			util_SchedulerDaemon
		End if 
	End if 
	
Else 
	While (Semaphore:C143("$RptMngr"))  //another report or the manager is updating
		DELAY PROCESS:C323($PrcsID; 5)  //wait till free
	End while 
	
	$newElement:=Size of array:C274(<>lReportPrcs)+1
	ARRAY LONGINT:C221(<>lReportPrcs; $newElement)  //holds number of the process generating the report
	ARRAY LONGINT:C221(<>lReportTime; $newElement)  //holds time the report is to begin  
	<>lReportPrcs{$newElement}:=$1
	<>lReportTime{$newElement}:=$2
	
	CLEAR SEMAPHORE:C144("$RptMngr")
	zwStatusMsg("SCHEDULER"; "PROCESS: "+uProcessName($1)+" delayed until "+TS2String($2))
End if 