//%attributes = {}
//Method:  Core_Date_ddhhmmssT({dDate}{;hTime}{;tSeparator))=tDDHHMMSS
//Description:  This method will return a date in the DDHHMMSS format

If (True:C214)  //Initialize
	
	C_DATE:C307($1; $dDate)
	C_TIME:C306($2; $hTime)
	C_TEXT:C284($3; $tSeparator)
	C_TEXT:C284($0; $tDDHHMMSS)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_TEXT:C284($tYear; $tMonth; $tDay)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$dDate:=Current date:C33(*)
	$hTime:=Current time:C178(*)
	$tSeparator:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Optional parameters
		$dDate:=$1
		If ($nNumberOfParameters>=2)
			$hTime:=$2
			If ($nNumberOfParameters>=3)
				$tSeparator:=$3
			End if 
		End if 
	End if   //Done optional parameters
	
	$tDay:=CorektBlank
	$tDDHHMMSS:=CorektBlank
	
End if   //Done Initialize

$tDay:=String:C10(Day of:C23($dDate); "0#")
$tTime:=Replace string:C233(String:C10($hTime); CorektColon; CorektBlank; *)

$tDDHHMMSS:=$tDay+$tSeparator+$tTime

$0:=$tDDHHMMSS