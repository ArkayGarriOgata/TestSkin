//%attributes = {}
//Method:  Core_Date_NumberOfMonthsN(dStart;dEnd)=>nNumberOfMonths
//Description:  This method returns the number of months between two dates

If (True:C214)  //Initialize
	
	C_DATE:C307($1; $dStart; $2; $dEnd)
	C_LONGINT:C283($0; $nNumberOfMonths)
	
	C_DATE:C307($dTempSwitch)
	$dStart:=$1
	$dEnd:=$2
	
	$nNumberOfMonths:=0
	
	If ($dEnd<$dStart)  //Switch
		
		$dTempSwitch:=$dEnd
		$dStart:=$dEnd
		$dEnd:=$dTempSwitch
		
	End if   //Done switch
	
	$nStartMonth:=Month of:C24($dStart)
	$nStartYear:=Year of:C25($dStart)
	$nEndMonth:=Month of:C24($dEnd)
	$nEndYear:=Year of:C25($dEnd)
	
End if   //Done initialize

If ($nStartMonth<=$nEndMonth)  //Months
	
	$nMonths:=$nEndMonth-$nStartMonth
	
	$nYears:=$nEndYear-$nStartYear
	
Else 
	
	$nMonths:=(12-$nStartMonth)+$nEndMonth
	
	$nYears:=($nEndYear-$nStartYear)-1
	
End if   //Done months

$nNumberOfMonths:=$nMonths+($nYears*12)

$0:=$nNumberOfMonths