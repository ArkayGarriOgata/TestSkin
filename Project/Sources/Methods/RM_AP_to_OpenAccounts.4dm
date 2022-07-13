//%attributes = {}
// -------
// Method: RM_AP_to_OpenAccounts   ( ->$aPO;->$aJob;->$aDateRcd;->$aValue;->$aReceipts;->$aVendid ) ->
// By: Mel Bohince @ 11/01/17, 07:31:35
// Description
// send selection of receipts to OpenAccounts as csv file
// Modified by: Mel Bohince (12/1/17) change G/L codes to 10-10-000  51460- instead of suspense account
// ----------------------------------------------------
//ARRAY TEXT($aPO;0)
//ARRAY TEXT($aJob;0)
//ARRAY DATE($aDateRcd;0)
//ARRAY REAL($aValue;0)
//ARRAY LONGINT($aReceipts;0)

C_TEXT:C284($crlf; $d; $co; $curr; $doctype; $costCode; $expCode)
C_POINTER:C301($1; $2; $3; $4; $5; $6; $ptrPO; $ptrJob; $ptrDate; $ptrValue; $ptrReceipts; $ptrVendor)
$ptrPO:=$1
$ptrJob:=$2
$ptrDate:=$3
$ptrValue:=$4
$ptrReceipts:=$5
$ptrVendor:=$6

$crlf:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
$d:=","  //comma delimininated
$co:=<>OpenAcctsCompany
$curr:="USD"
$doctype:="APINOA"  //debit | credit?
$costCode:="10-10-000"  // Modified by: Mel Bohince (12/1/17) 
$expCode:="51460-"  // Modified by: Mel Bohince (12/1/17) 
$vendorCode:=""  //"LAS04526" see line 49
$vendorName:=""

C_TEXT:C284($text; $docName; $0)
C_TIME:C306($docRef)

$text:=""
$text:=$text+"Rectype,Company,Doctype,Account Number,Reference,Null,Originref,Date,Currency,Description,Document Value,VAT Value,Year,Period,Vat Code 1,Goods Value,VAT Amount"+$crlf
$text:=$text+",,Cost Code,Expense Code,Null,GL Value,VAT Code,Description,,,,,,,"+$crlf
$text:=$text+",,,,,,,,,,,,,,"+$crlf

$docName:="ap_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($ptrPO->)
	uThermoInit($numElements; "Exporting CSV")
	For ($i; 1; $numElements)
		If ($ptrVendor->{$i}="04526")
			$vendorCode:="3066"  //"LAS04526"
			$vendorName:="Lasercam Inc"
		Else 
			$vendorCode:="????"
			$vendorName:="fix this on line 52"
		End if 
		$text:=$text+"H"+$d+$co+$d+$doctype+$d+$vendorCode+$d+$ptrPO->{$i}+$d+""+$d+""+$d+String:C10($ptrDate->{$i}; Internal date short special:K1:4)+$d+$curr+$d+$vendorName+$d+String:C10($ptrValue->{$i})+$d+"0"+$d+String:C10(Year of:C25($ptrDate->{$i}))+$d+String:C10(Month of:C24($ptrDate->{$i}))+$d+"E"+$d+String:C10($ptrValue->{$i})+$d+"0"+$crlf
		$text:=$text+"D"+$d+$co+$d+$costCode+$d+$expCode+$d+""+$d+String:C10($ptrValue->{$i})+$d+"E"+$d+"Job "+$ptrJob->{$i}+(8*$d)+$crlf
		//$aStatus{$i}:="Posted"
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; $text)
	
	CLOSE DOCUMENT:C267($docRef)
	
	//ARRAY TO SELECTION($aStatus;[Customers_Invoices]Status)  //mark as sent
	
	$0:=$docName
	
	
Else 
	$0:=""
End if 