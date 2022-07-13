//%attributes = {}
//Method:  Tgsn_PrGb_Send(panInvoiceNumber)
//Description:  This method will send them to Proctor and Gamble

If (True:C214)  //Initializaton
	
	C_POINTER:C301($1; $panInvoiceNumber)
	
	C_LONGINT:C283($nInvoiceNumber; $nNumberOfInvoices)
	C_TEXT:C284($tPipedInvoice; $tTungstenSeparator)
	
	$panInvoiceNumber:=$1
	
	$nNumberOfInvoices:=Size of array:C274($panInvoiceNumber->)
	
	$tPipedInvoice:=CorektBlank
	
	$tTungstenSeparator:=CorektCR+Char:C90(Line feed:K15:40)
	
End if   //Done initializaton

SORT ARRAY:C229($panInvoiceNumber->; >)

For ($nInvoiceNumber; 1; $nNumberOfInvoices)  //Loop thru invoices
	
	$tPipedInvoice:=$tPipedInvoice+Tgsn_PrGb_CreatePipedInvoiceT($panInvoiceNumber->{$nInvoiceNumber})+$tTungstenSeparator
	
End for   //Done looping thru invoices

Tgsn_Send($tPipedInvoice)
