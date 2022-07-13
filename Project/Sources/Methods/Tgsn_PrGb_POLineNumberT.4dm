//%attributes = {}
//Method:  Tgsn_PrGb_POLineNumberT(tCustomerPONumber)=>tLineNumber
//Description:  This method returns the line number parsed out of P&G's PO Number
//.   Example of a P&G PO Number: N6P-5500020453.01280.0015
//.     here the line number is 01280

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPrGbPONumber)
	C_TEXT:C284($0; $tLineNumber)
	
	C_LONGINT:C283($nStart; $nEnd)
	
	$tPrGbPONumber:=$1
	$tLineNumber:=CorektBlank
	
End if   //Done Initialize

$nStart:=Position:C15(CorektPeriod; $tPrGbPONumber)

If ($nStart>1)
	
	$tLineNumber:=Substring:C12($tPrGbPONumber; ($nStart+1))  //"01280.0015"
	
	$nEnd:=Position:C15(CorektPeriod; $tLineNumber)
	
	$tLineNumber:=Substring:C12($tLineNumber; 1; $nEnd-1)  //"01280"
	
End if 

$0:=$tLineNumber