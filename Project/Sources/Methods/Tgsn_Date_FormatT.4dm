//%attributes = {}
//Method:  Tgsn_Date_FormatT(dDate)=>tTungstenDateFormat
//Description:  This method will format the dates to the date format Tungsten likes
//   YYYY-MM-DD

If (True:C214)  //Initialize
	
	C_DATE:C307($1; $dDate)
	C_TEXT:C284($0; $tTungstenDateFormat)
	C_TEXT:C284($tTungstenSeparator)
	
	$dDate:=$1
	
	$tTungstenDateFormat:=CorektBlank
	$tTungstenSeparator:=CorektDash
	
End if   //Done Initialize

$tTungstenDateFormat:=Core_Date_yyyymmddT($dDate; $tTungstenSeparator)

$0:=$tTungstenDateFormat