//(S) [CONTROL]fgEvent'ibMove
app_Log_Usage("log"; "FG"; "Scrap FGs")
$id:=uSpawnProcess("FG_destroy"; 32000; "Scrap:FINISHED_GOODS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	FG_destroy
End if 
//EOS
