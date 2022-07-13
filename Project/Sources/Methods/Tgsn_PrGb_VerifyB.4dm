//%attributes = {}
//Method:  Tgsn_PrGb_VerifyB(nInvoiceNumber;ptReason)=>bVerified
//Description:  This method verifies the mandatory data is filled in

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nInvoiceNumber)
	C_POINTER:C301($2; $ptReason)
	C_BOOLEAN:C305($0; $bVerified)
	
	$nInvoiceNumber:=$1
	$ptReason:=$2
	
	$bVerified:=False:C215  //Assume something will fail
	
	Tgsn_Data_Column  //Define TgsnoColumn
	
	Tgsn_PrGb_Mandatory($nInvoiceNumber; $ptReason)  //Fill Mandatory
	
End if   //Done initialize

Case of   //Verified
		
	: ($ptReason->#CorektBlank)  //Invoice is not valid
		
	: (OB Get:C1224(TgsnoColumn; "InvoiceNumber")=CorektBlank)
		
		$ptReason->:="Invoice Number missing"
		
	: (OB Get:C1224(TgsnoColumn; "InvoiceDate")=CorektBlank)
		
		$ptReason->:="Invoice Date missing"
		
	: (OB Get:C1224(TgsnoColumn; "InvoiceType")=CorektBlank)
		
		$ptReason->:="Invoice Type missing"
		
	: (OB Get:C1224(TgsnoColumn; "BuyerID")=CorektBlank)
		
		$ptReason->:="Buyer ID missing"
		
	: (OB Get:C1224(TgsnoColumn; "PO Number")=CorektBlank)
		
		$ptReason->:="PO Number missing"
		
	: (OB Get:C1224(TgsnoColumn; "ShipToName")=CorektBlank)
		
		$ptReason->:="Ship To  missing"
		
	: ((OB Get:C1224(TgsnoColumn; "ShipToAdd1")=CorektBlank) & (OB Get:C1224(TgsnoColumn; "ShipToAdd2")=CorektBlank))
		
		$ptReason->:="Ship To Address missing"
		
	: (OB Get:C1224(TgsnoColumn; "ShipToCity")=CorektBlank)
		
		$ptReason->:="Ship To City missing"
		
	: (OB Get:C1224(TgsnoColumn; "ShipToPostalCode")=CorektBlank)
		
		$ptReason->:="Ship To Postal Code missing"
		
	: (OB Get:C1224(TgsnoColumn; "ShipToState")=CorektBlank)
		
		$ptReason->:="Ship To State missing"
		
	: (OB Get:C1224(TgsnoColumn; "ShipToCountry")=CorektBlank)
		
		$ptReason->:="Ship To Country missing"
		
	: (OB Get:C1224(TgsnoColumn; "InvoiceNetAmount")=CorektBlank)
		
		$ptReason->:="Invoice Net Amount missing"
		
	: (OB Get:C1224(TgsnoColumn; "InvoiceGrossAmount")=CorektBlank)
		
		$ptReason->:="Invoice Gross Amount missing"
		
	: (OB Get:C1224(TgsnoColumn; "Currency")=CorektBlank)
		
		$ptReason->:="Currency missing"
		
	: (OB Get:C1224(TgsnoColumn; "POLineNum")=CorektBlank)
		
		$ptReason->:="PO Line Number missing"
		
	: (OB Get:C1224(TgsnoColumn; "Quantity")=CorektBlank)
		
		$ptReason->:="Quantity missing"
		
	: (OB Get:C1224(TgsnoColumn; "UnitOfMeasure")=CorektBlank)
		
		$ptReason->:="Unit of Measure missing"
		
	: (OB Get:C1224(TgsnoColumn; "UnitPrice")=CorektBlank)
		
		$ptReason->:="Unit Price missing"
		
	: (OB Get:C1224(TgsnoColumn; "LineNetAmount")=CorektBlank)
		
		$ptReason->:="Line Net Amount missing"
		
	: (OB Get:C1224(TgsnoColumn; "SupplierPartNum")=CorektBlank)
		
		$ptReason->:="Supplier Part Number missing"
		
	: (OB Get:C1224(TgsnoColumn; "SupplierPartDescr")=CorektBlank)
		
		$ptReason->:="Supplier Part Desc missing"
		
	: ((OB Get:C1224(TgsnoColumn; "BillOfLading")=CorektBlank) & (OB Get:C1224(TgsnoColumn; "Delivery Note Number")=CorektBlank))
		
		$ptReason->:="Shipping Document missing"
		
	Else 
		
		$bVerified:=True:C214
		
End case   //Done Verified

$0:=$bVerified
