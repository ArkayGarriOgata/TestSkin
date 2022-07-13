// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/08/13, 10:32:05
// ----------------------------------------------------
// Method: [zz_control].POEvent.bRev
// ----------------------------------------------------

Case of 
	: (User in group:C338(Current user:C182; "AccountsPayable"))
		$id:=uSpawnProcess("PoAcctReview"; 0; "Review Purchase Orders"; True:C214; True:C214)
	Else 
		ViewSetter(3; ->[Purchase_Orders:11])
End case 