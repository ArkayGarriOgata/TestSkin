//(S) [CONTROL]RMEvent'ibMove
uSpawnProcess("RM_Consignment_Receive"; 32000; "Transfer:Consignment Setup"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	RM_Consignment_Receive
End if 
//EOS