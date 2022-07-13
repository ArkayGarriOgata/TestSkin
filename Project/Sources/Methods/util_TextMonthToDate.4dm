//%attributes = {}
// Method: util_TextMonthToDate
//former:  zTextMonthToDatebrv;current date)  090502  mlb
//convert a month abrieviation to a date
C_TEXT:C284($1)
C_TEXT:C284($year; $dayYr; $mth)
C_DATE:C307($0)
If (Count parameters:C259=2)
	$currentDate:=$2
Else 
	$currentDate:=Current date:C33
End if 
$year:=String:C10(Year of:C25($currentDate))
$dayYr:="/01/"+$year
$thisMonth:=String:C10(Month of:C24($currentDate); "00")
Case of 
	: ($1="Jan")
		$mth:="01"
	: ($1="Feb")
		$mth:="02"
	: ($1="Mar")
		$mth:="03"
	: ($1="Apr")
		$mth:="04"
	: ($1="May")
		$mth:="05"
	: ($1="Jun")
		$mth:="06"
	: ($1="Jul")
		$mth:="07"
	: ($1="Aug")
		$mth:="08"
	: ($1="Sep")
		$mth:="09"
	: ($1="Oct")
		$mth:="10"
	: ($1="Nov")
		$mth:="11"
	: ($1="Dec")
		$mth:="12"
	Else 
		$mth:=String:C10(Month of:C24(Current date:C33))
End case 

$0:=Date:C102($mth+$dayYr)
If (Num:C11($mth)<Num:C11($thisMonth))
	$0:=Add to date:C393($0; 1; 0; 0)
End if 
//
