//%attributes = {}
//Method:  Tgsn_InvoiceTypeT(tCustomersInvoicesType)=>tTungstenInvoiceType
//Description:  This method will return the Invoice Type tungsten expects

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCustomersInvoicesType)
	C_TEXT:C284($0; $tTungstenInvoiceType)
	
	$tCustomersInvoicesType:=$1
	$tTungstenInvoiceType:=CorektBlank
	
End if   //Done Initialize

Case of   //Tungsten code
		
	: ($tCustomersInvoicesType="Debit")
		
		$tTungstenInvoiceType:="380"  //Invoice
		
	: ($tCustomersInvoicesType="Credit")
		
		$tTungstenInvoiceType:="381"  //Credit Note
		
End case   //Done Tungsten code

$0:=$tTungstenInvoiceType
