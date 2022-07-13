//(S) [CONTROL]RMEvent'ibMove
uSpawnProcess("RM_Consignment_Conver"; 32000; "Transfer:Consignment Receipt"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	RM_Consignment_Conver
End if 
//EOS