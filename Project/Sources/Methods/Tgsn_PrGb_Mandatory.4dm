//%attributes = {}
//Method:  Tgsn_PrGb_Mandatory(nInvoiceNumber{;ptReason})
//Description:  This method contains the mandatory information for P&G 
//  Information was pulled from [Customers_Invoices];"InvoiceForBlankPaper"

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nInvoiceNumber)
	C_POINTER:C301($2; $ptReason)
	C_BOOLEAN:C305($bSaveEDI)
	
	$nInvoiceNumber:=$1
	
	$bSaveEDI:=True:C214
	
	If (Count parameters:C259>=2)
		$ptReason:=$2
		$bSaveEDI:=False:C215
		
	End if 
	
	C_OBJECT:C1216($oAddress)
	
End if   //Done Initialize

Case of   //Verified
	: (Not:C34(Core_Query_UniqueRecordB(->[Customers_Invoices:88]InvoiceNumber:1; ->$nInvoiceNumber)))  //Found a unique invoice number
		
		$ptReason->:="Invoice Number is not unique"
		
	: ([Customers_Invoices:88]CustomerID:6#"00199")
		
		$ptReason->:="Customer ID is not 00199"
		
	: (Not:C34((Position:C15("N6P"; [Customers_Invoices:88]CustomersPO:11)>0) | (Position:C15("G4P"; [Customers_Invoices:88]CustomersPO:11)>0)))
		
		$ptReason->:="Customer PO is not N6P or G4P"
		
	Else   //Set values
		
		$oAddress:=New object:C1471()
		$oAddress:=Adrs_GetAddressO([Customers_Invoices:88]ShipTo:9)
		
		OB SET:C1220(TgsnoColumn; "InvoiceNumber"; String:C10([Customers_Invoices:88]InvoiceNumber:1))
		OB SET:C1220(TgsnoColumn; "InvoiceDate"; Tgsn_Date_FormatT([Customers_Invoices:88]Invoice_Date:7))  //YYYY – MM – DD
		OB SET:C1220(TgsnoColumn; "InvoiceType"; Tgsn_InvoiceTypeT([Customers_Invoices:88]InvType:13))
		OB SET:C1220(TgsnoColumn; "BuyerID"; Tgsn_PrGb_GetBuyerIdT([Customers_Invoices:88]BillTo:10))
		
		OB SET:C1220(TgsnoColumn; "PO Number"; Tgsn_PrGb_ParsePONumberT([Customers_Invoices:88]CustomersPO:11))
		OB SET:C1220(TgsnoColumn; "Delivery Note Number"; CorektBlank)
		OB SET:C1220(TgsnoColumn; "ShipToName"; OB Get:C1224($oAddress; "Name"))
		OB SET:C1220(TgsnoColumn; "ShipToAdd1"; OB Get:C1224($oAddress; "Address1"))
		OB SET:C1220(TgsnoColumn; "ShipToAdd2"; OB Get:C1224($oAddress; "Address2"))
		OB SET:C1220(TgsnoColumn; "ShipToCity"; OB Get:C1224($oAddress; "City"))
		OB SET:C1220(TgsnoColumn; "ShipToPostalCode"; OB Get:C1224($oAddress; "Zip"))
		OB SET:C1220(TgsnoColumn; "ShipToState"; OB Get:C1224($oAddress; "State"))
		OB SET:C1220(TgsnoColumn; "ShipToCountry"; OB Get:C1224($oAddress; "Country"))
		
		OB SET:C1220(TgsnoColumn; "InvoiceNetAmount"; String:C10([Customers_Invoices:88]ExtendedPrice:19))
		OB SET:C1220(TgsnoColumn; "InvoiceGrossAmount"; String:C10([Customers_Invoices:88]ExtendedPrice:19))
		OB SET:C1220(TgsnoColumn; "Currency"; "USD")
		
		OB SET:C1220(TgsnoColumn; "POLineNum"; Tgsn_PrGb_POLineNumberT([Customers_Invoices:88]CustomersPO:11))
		OB SET:C1220(TgsnoColumn; "Quantity"; String:C10([Customers_Invoices:88]Quantity:15))
		OB SET:C1220(TgsnoColumn; "UnitOfMeasure"; "EA")
		OB SET:C1220(TgsnoColumn; "UnitPrice"; String:C10(Round:C94(([Customers_Invoices:88]ExtendedPrice:19/[Customers_Invoices:88]Quantity:15); 5)))
		OB SET:C1220(TgsnoColumn; "LineNetAmount"; String:C10([Customers_Invoices:88]ExtendedPrice:19))
		OB SET:C1220(TgsnoColumn; "SupplierPartNum"; [Customers_Invoices:88]ProductCode:14)
		OB SET:C1220(TgsnoColumn; "SupplierPartDescr"; Tgsn_PrGb_GetDescriptionT([Customers_Invoices:88]ProductCode:14))
		
		OB SET:C1220(TgsnoColumn; "BillOfLading"; String:C10([Customers_Invoices:88]BillOfLadingNumber:3))
		
		If ($bSaveEDI)
			
			[Customers_Invoices:88]EDI_Prep:33:=EDI_GetNextIDfromPreferences((TgsnktAcronym+"_PrGb"); "000000")
			
			SAVE RECORD:C53([Customers_Invoices:88])
			
		End if 
		
End case   //Done verified
