//(S) [CONTROL]RMEvent'ibPick
app_Log_Usage("log"; "FG"; "Release Picks List")
uSpawnProcess("REL_PickFGforShipment"; <>lMidMemPart; "Release Picks List"; True:C214; False:C215)
If (False:C215)  //list called procedures for 4D Insider
	REL_PickFGforShipment
End if 
//EOS