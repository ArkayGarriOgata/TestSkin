//%attributes = {}
//Method:  Tgsn_Send (tPipedInvoice)
//Description: This methods sends a Tungsten piped invoices document

If (True:C214)
	
	C_TEXT:C284($1; $tPipedInvoice)
	
	$tPipedInvoice:=$1
	
End if 

If (Not:C34(Tgsn_ExDr_PutB($tPipedInvoice)))
	
End if 

