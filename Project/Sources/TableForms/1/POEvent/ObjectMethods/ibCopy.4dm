// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/08/13, 10:33:04
// ----------------------------------------------------
// Method: [zz_control].POEvent.ibCopy
// ----------------------------------------------------

If (User in group:C338(Current user:C182; "Purchasing"))
	uSpawnProcess("mCopyPO"; 48000; "Copy:PURCHASE ORDER"; True:C214; True:C214)
Else 
	uNotAuthorized
End if 