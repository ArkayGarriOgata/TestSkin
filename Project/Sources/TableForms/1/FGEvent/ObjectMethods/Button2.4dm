//(s) THC
<>ThcBatchDat:=!00-00-00!
<>InvCalcDone:=False:C215
<>JobCalcDone:=False:C215
<>JobBatchDat:=!00-00-00!
app_Log_Usage("log"; "FG"; "Manual THC")
$pid:=Execute on server:C373("BatchTHCcalc"; <>lMinMemPart; "BatchTHCcalc"; "no log")
//$id:=uSpawnProcess ("BatchTHCcalc";64000;"TimeHorizonCalc";True;False)
If (False:C215)
	BatchTHCcalc
End if 

DELAY PROCESS:C323(Current process:C322; 60*12)
uConfirm("Time Horizon Calcultion is finished, run the report?."; "Report"; "Done")
If (ok=1)
	FG_THC_Report
End if 

//