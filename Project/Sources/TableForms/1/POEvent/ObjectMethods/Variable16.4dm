Case of 
	: (User in group:C338(Current user:C182; "AccountsPayable"))
		$id:=uSpawnProcess("PoAcctReview"; 0; "Review Purchase Orders"; True:C214; True:C214)
		If (False:C215)
			PoAcctReview
		End if 
	Else 
		ViewSetter(3; ->[Purchase_Orders:11])
End case 