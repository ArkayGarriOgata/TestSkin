//(S) [CONTROL]CIDEvent'ibMod
//• 3/27/97 cs Mellisa's suggestion, make Adj screens have ONLY 'Phys Inv' reason
If (User in group:C338(Current user:C182; "Physical Inv")) | (Current user:C182="Design@") | (User in group:C338(Current user:C182; "INV Mgr"))
	<>fPiActive:=True:C214  //•3/27/97 cs
	$id:=uSpawnProcess("doAdjustFGinv"; 32000; "F/G Adjustment")
	If (False:C215)
		doAdjustFGinv
	End if 
Else 
	uNotAuthorized
End if 
//EOS