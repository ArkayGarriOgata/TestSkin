//(S) [CONTROL]RMEvent'ibPick
uSpawnProcess("RM_Pick"; 32000; "Pick:RAW_MATERIALS"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	RM_Pick
End if 
//EOS