//(S) [CONTROL]RMEvent'ibRec
uSpawnProcess("RM_Receive"; 32000; "Receive:RAW_MATERIALS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	RM_Receive
End if 
//EOS