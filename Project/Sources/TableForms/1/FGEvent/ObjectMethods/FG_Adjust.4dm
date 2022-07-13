//Script: bCCount()  120996  mBohince
//allow cycle count adjustments



If (Not:C34(Shift down:C543))  // Modified by: Mel Bohince (10/9/20) option to new form
	app_Log_Usage("log"; "FG"; "F/G FGL_UI")
	FGL_UI
	
Else 
	app_Log_Usage("log"; "FG"; "F/G Adjustment")
	$id:=uSpawnProcess("doAdjustFGinv"; 32000; "F/G Adjustment")
	If (False:C215)
		doAdjustFGinv
	End if 
	
End if 
