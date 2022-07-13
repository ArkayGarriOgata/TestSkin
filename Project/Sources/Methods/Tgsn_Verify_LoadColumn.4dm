//%attributes = {}
//Method: Tgsn_Verify_LoadColumn (panInvoiceNumber)
//Description:  This method will load the columns for Tgsn_Verify

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $panInvoiceNumber)
	
	$panInvoiceNumber:=$1
	
End if   //Done initializaton

Compiler_Tgsn_Array(Current method name:C684; 0)

COPY ARRAY:C226($panInvoiceNumber->; Tgsn_anVerify_InvoiceNumber)

$nNumberOfInvoices:=Size of array:C274(Tgsn_anVerify_InvoiceNumber)

For ($nInvoice; 1; $nNumberOfInvoices)  //Loop thru invoices
	
	$bVerfied:=Tgsn_PrGb_VerifyB(Tgsn_anVerify_InvoiceNumber{$nInvoice})
	
	APPEND TO ARRAY:C911(Tgsn_abVerify_Send; $bVerfied)
	APPEND TO ARRAY:C911(Tgsn_abVerify_Fix; Not:C34($bVerfied))
	
End for   //Done looping thru invoices
