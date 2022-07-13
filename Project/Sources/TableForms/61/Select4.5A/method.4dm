//FM: Select4.5A() -> 
//@author mlb - 1/31/03  10:11
If (Form event code:C388=On Load:K2:1)
	cb1:=0
	dFrom:=UtilGetDate(Current date:C33; "ThisMonth")  //!00/00/00!
	$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dTo)  //!00/00/00!
End if 