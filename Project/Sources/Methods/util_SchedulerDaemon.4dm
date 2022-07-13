//%attributes = {"publishedWeb":true}
//PM: util_SchedulerDaemon() -> 
// fromerly`(P) uReportManager: manages delayed report execution
//When used with the procedure uNowOrDelay, the user can have report
//execution delayed until a later time

C_LONGINT:C283($i)
C_TIME:C306($StartTime)
ARRAY LONGINT:C221(<>lReportPrcs; 0)  //holds number of the process generating the report
ARRAY LONGINT:C221(<>lReportTime; 0)  //holds time the report is to begin
C_BOOLEAN:C305(<>delayCanceled)  //hook to abort a scheduled process

zwStatusMsg("PLS WAIT"; "Launching Schedule Manager")
//setup arrays to handle timing of report generation

<>delayCanceled:=False:C215

Repeat 
	While (Semaphore:C143("$RptMngr"))  //another process is updating, must wait
		DELAY PROCESS:C323(Current process:C322; 60)  //wait a second, this isn't critical
	End while 
	
	$now:=TSTimeStamp
	
	SORT ARRAY:C229(<>lReportTime; <>lReportPrcs; >)  //fifo
	For ($i; 1; Size of array:C274(<>lReportPrcs))
		If (<>lReportTime{$i}#0)
			If (<>lReportTime{$i}<=$now)  //go ahead and wake that pid up
				RESUME PROCESS:C320(<>lReportPrcs{$i})  //resume the process, it will continue on its own
				<>lReportTime{$i}:=0
				<>lReportPrcs{$i}:=0
			End if 
		End if 
	End for 
	
	//clean up the queue  
	SORT ARRAY:C229(<>lReportTime; <>lReportPrcs; <)
	$hit:=Find in array:C230(<>lReportTime; 0)
	If ($hit>-1)
		$hit:=$hit-1
		ARRAY LONGINT:C221(<>lReportPrcs; $hit)  //holds number of the process generating the report
		ARRAY LONGINT:C221(<>lReportTime; $hit)  //holds time the report is to begin      
	End if 
	
	CLEAR SEMAPHORE:C144("$RptMngr")
	
	DELAY PROCESS:C323(Current process:C322; 3600)  //only scan every minute
Until (<>delayCanceled)