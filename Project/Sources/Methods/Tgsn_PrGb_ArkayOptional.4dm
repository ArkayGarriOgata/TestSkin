//%attributes = {}
//Method:  Tgsn_PrGb_ArkayOptional(nInvoiceNumber)
//Description:  This method contains the optional information for P&G 
//  Information was pulled from the form:  [Customers_Invoices];"InvoiceForBlankPaper"

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nInvoiceNumber)
	
	$nInvoiceNumber:=$1
	
End if   //Done Initialize

If (Core_Query_UniqueRecordB(->[Customers_Invoices:88]InvoiceNumber:1; ->$nInvoiceNumber))  //Found a unique invoice number
	
	OB SET:C1220(TgsnoColumn; "Order Date"; Tgsn_Date_FormatT(CuOr_GetDateOpenedD([Customers_Invoices:88]OrderLine:4)))  //Added per new pricing contract
	OB SET:C1220(TgsnoColumn; "ShipDate"; Tgsn_Date_FormatT([Customers_Invoices:88]Invoice_Date:7))
	OB SET:C1220(TgsnoColumn; "Payment Terms"; "Net 45")
	OB SET:C1220(TgsnoColumn; "Payment Due By Date"; Tgsn_Date_FormatT(Add to date:C393([Customers_Invoices:88]Invoice_Date:7; 0; 0; 45)))
	OB SET:C1220(TgsnoColumn; "BuyerContactName"; "Randall Robbins")
	OB SET:C1220(TgsnoColumn; "BuyerContactEmail"; "robbins.rr.2@pg.com")
	
End if   //Done found a unique invoice number
