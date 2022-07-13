//(S) aMonthYear
C_LONGINT:C283($MM)
//---------------------------------------------------------------
If ([x_fiscal_calendars:63]Year_Month:4#"")
	$MM:=Num:C11(Substring:C12([x_fiscal_calendars:63]Year_Month:4; 3; 2))
	//If ($MM<4)
	//$MM:=$MM+9
	//Else 
	//$MM:=$MM-3
	//End if 
	aMonthYear:=<>ayMonth{$MM}+", 20"+Substring:C12([x_fiscal_calendars:63]Year_Month:4; 1; 2)
Else 
	aMonthYear:=""
End if 
//EOS