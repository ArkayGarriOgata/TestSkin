//%attributes = {}
//Method: Tgsn_Verify_Send
//Description:  This method will send invoices to Tungsten

If (True:C214)
	
	C_LONGINT:C283($nInvoice; $nNumberOfInvoices)
	C_TEXT:C284($tPipedInvoice)
	
	ARRAY TEXT:C222($atPipedInvoice; 0)
	ARRAY LONGINT:C221($anInvoice; 0)
	
End if 

Case of   //Send via
		
	: (Tgsn_nVerify_Tungsten=1)
		
		For ($nInvoice; 1; $nNumberOfInvoices)  //Loop thru invoices
			
			If (Tgsn_abVerify_Send{$nInvoice})  //Send
				
				$nInvoiceNumber:=Tgsn_anVerify_InvoiceNumber{$nInvoice}
				$tPipedInvoice:=CorektBlank
				
				$tPipedInvoice:=Tgsn_PrGb_CreatePipedInvoiceT($nInvoiceNumber)
				
				APPEND TO ARRAY:C911($atPipedInvoice; $tPipedInvoice)
				APPEND TO ARRAY:C911($anInvoice; $nInvoiceNumber)
				
			End if   //Done send
			
		End for   //Done looping thru invoices
		
		Tgsn_Verify_SendViaSftp(->$atPipedInvoice)
		
	: (Tgsn_nVerify_EDI=1)
		
		//Tgsn_Verify_SendViaEdi(->$anInvoice)
		
End case   //Done send via


