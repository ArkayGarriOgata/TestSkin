//(S) [FISCAL_CALENDAR]Period
C_LONGINT:C283($MM; $YY)
$MM:=Num:C11(Substring:C12([x_fiscal_calendars:63]Period:1; 5; 2))
$YY:=Num:C11(Substring:C12([x_fiscal_calendars:63]Period:1; 3; 2))
If ($MM<10)
	$YY:=$YY-1
End if 
If ($MM>9)
	$MM:=$MM-9
Else 
	$MM:=$MM+3
End if 
[x_fiscal_calendars:63]Year_Month:4:=String:C10($YY; "00")+String:C10($MM; "00")
//---------------------------------------------------------------
$MM:=Num:C11(Substring:C12([x_fiscal_calendars:63]Year_Month:4; 3; 2))
//If ($MM<4)
//$MM:=$MM+9
//Else 
//$MM:=$MM-3
//End if 
aMonthYear:=<>ayMonth{$MM}+", 19"+Substring:C12([x_fiscal_calendars:63]Year_Month:4; 1; 2)
//EOS