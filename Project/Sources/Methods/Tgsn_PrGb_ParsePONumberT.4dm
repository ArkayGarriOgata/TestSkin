//%attributes = {}
//Method: Tgsn_PrGb_ParsePONumberT(tCustomersPO)=>tParsedPONumber
//Description: This method will parse out the PO Number from the customers PO number
// Currently we are getting the PO Numbers like this:  N6P-5500016993.02650.0405
//. The PO Number we need is N6P-5500016993 so it must be "N6P-(10digitnumber)"

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCustomersPO)
	C_TEXT:C284($0; $tParsedPONumber)
	
	C_LONGINT:C283($nEnd; $nStart)
	C_LONGINT:C283($nLengthCustomersPO; $nLengthPONumber)
	C_LONGINT:C283($nLengthTenDigitPO)
	
	C_TEXT:C284($tVerifyPONumber)
	
	$tCustomersPO:=$1
	$tParsedPONumber:=CorektBlank
	
End if   //Done Initialize

$nLengthCustomersPO:=Length:C16($tCustomersPO)
$nStart:=Position:C15("N6P-"; $tCustomersPO)  //N6P- is an SAP requirment according to Tungsten
$nEnd:=Position:C15(CorektPeriod; $tCustomersPO)-1

Case of   //Determine minimum requirements
		
	: ($nLengthCustomersPO<14)  //PO does not have N6P- and 10 digits minimum
	: ($nStart<0)  //Did not find N6P- so the PO Number is not good
	: ($nEnd<0)  //The line number is not going to work this is a double check
		
	Else   //Evaluate the PO Number
		
		$tVerifyPONumber:=Substring:C12($tCustomersPO; $nStart; $nEnd)
		
		$nLengthPONumber:=Length:C16($tVerifyPONumber)
		$nLengthTenDigitPO:=Length:C16(String:C10(Num:C11(Substring:C12($tVerifyPONumber; 5))))
		
		Case of   //Verify length of ParsedPONumber
			: ($nLengthPONumber<14)
			: ($nLengthTenDigitPO<10)
			Else   //Verified that starts with "N6p-" and a 10 digit PO number follows
				
				$tParsedPONumber:=$tVerifyPONumber
				
		End case   //Done verify length of ParsePONumber
		
End case   //Done determine minimum requirements

$0:=$tParsedPONumber
