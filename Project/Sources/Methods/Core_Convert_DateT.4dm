//%attributes = {}
//Method:  Core_Convert_DateT(dDate)=> "mm/dd/yyyy"
//Description:  This function converts a date to a string representaion

If (True:C214)  //Initialize
	
	C_DATE:C307($1; $dDate)
	C_TEXT:C284($tDate; $0)
	C_TEXT:C284($tMonth; $tDay; $tYear)
	
	$dDate:=$1
	
	$tDate:=CorektBlank
	
	$tMonth:=String:C10(Month of:C24($dDate))
	$tDay:=String:C10(Day of:C23($dDate))
	$tYear:=String:C10(Year of:C25($dDate))
	
	$tDate:=$tMonth+"/"+$tDay+"/"+$tYear
	
End if   //Done Initialize

If (Not:C34(Core_Date_ValidB($tDate)))  //Valid date
	$tDate:="00/00/00"
End if   //Done valid date

$0:=$tDate
