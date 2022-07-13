//%attributes = {}
//Method:  Core_Date_yyyymmddT({dDate}{;tSeparator))=>tYYYYMMDD
//Description:  This method will return a date in the YYYYMMDD format

If (True:C214)  //Initialize
	
	C_DATE:C307($1; $dDate)
	C_TEXT:C284($2; $tSeparator)
	C_TEXT:C284($0; $tYYYYMMDD)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_TEXT:C284($tYear; $tMonth; $tDay)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$dDate:=Current date:C33(*)
	$tSeparator:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Optional parameters
		$dDate:=$1
		If ($nNumberOfParameters>=2)
			$tSeparator:=$2
		End if 
	End if   //Done optional parameters
	
	$tYear:=CorektBlank
	$tMonth:=CorektBlank
	$tDay:=CorektBlank
	
	$tYYYYMMDD:=CorektBlank
	
End if   //Done Initialize

$tYear:=String:C10(Year of:C25($dDate))
$tMonth:=String:C10(Month of:C24($dDate); "0#")
$tDay:=String:C10(Day of:C23($dDate); "0#")

$tYYYYMMDD:=$tYear+$tSeparator+$tMonth+$tSeparator+$tDay

$0:=$tYYYYMMDD