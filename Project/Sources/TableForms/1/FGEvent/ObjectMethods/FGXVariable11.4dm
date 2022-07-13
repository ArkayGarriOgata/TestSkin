//(S) [CONTROL]fgEvent'ibMove
uSpawnProcess("FG_return_dialog"; 32000; "Return:FINISHED_GOODS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	FG_return_dialog
End if 
//EOS