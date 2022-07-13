//%attributes = {}
//Method:  Rprt_Acnt_FillReportBy(patDropDown;patDropDownQuery)
//Description:  This method will fill in report by options

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown; $2; $patDropDownQuery)
	
	$patDropDown:=$1
	$patDropDownQuery:=$2
	
End if   //Done initialize

APPEND TO ARRAY:C911($patDropDown->; "Monthly")
APPEND TO ARRAY:C911($patDropDown->; "Yearly")

APPEND TO ARRAY:C911($patDropDownQuery->; "Monthly")
APPEND TO ARRAY:C911($patDropDownQuery->; "Yearly")

