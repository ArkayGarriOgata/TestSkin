//(S) [CONTROL]fgEvent'ibMove
uSpawnProcess("FG_xfer"; 32000; "Transfer:FINISHED_GOODS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	FG_xfer
End if 
//EOS