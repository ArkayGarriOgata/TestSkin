//%attributes = {}
//Method:  Tgsn_Verify_SendViaSftp(patPipedInvoice)
//Description:  This method will send via SFTP

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patPipedInvoice)
	C_LONGINT:C283($nInvoice; $nNumberOfInvoices)
	C_TEXT:C284($tPipedInvoice)
	
	$patPipedInvoice:=$1
	
	$nNumberOfInvoices:=Size of array:C274($patPipedInvoice->)
	
End if   //Done Initialize

For ($nInvoice; 1; $nNumberOfInvoices)  //Loop thru invoices
	
	$tPipedInvoice:=$patPipedInvoice->{$nInvoice}  //Create one piped invoice
	
End for   //Done looping thru invoices

//Make sure ExpanDrive is set up