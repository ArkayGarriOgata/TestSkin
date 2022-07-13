//(S) [CONTROL]RMEvent'ibMove
uSpawnProcess("RM_xfer"; 32000; "Transfer:RAW_MATERIALS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	RM_xfer
End if 
//EOS