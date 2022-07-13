//(S) [CONTROL]POEvent'ibCopy
If (User in group:C338(Current user:C182; "Purchasing"))
	uSpawnProcess("mCopyPO"; 48000; "Copy:PURCHASE ORDER"; True:C214; True:C214)
Else 
	uNotAuthorized
End if 
If (False:C215)  //list called procedures for 4D Insider
	mCopyPO
End if 
//EOS