//%attributes = {}
//Methd:  OrLn_Rprt_VoyantRvlnBooking
//Description:  This method will run the Voyant Revlon Booking report

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bTitle)
	
	C_COLLECTION:C1488($cBillTo)
	C_COLLECTION:C1488($cStatus)
	C_COLLECTION:C1488($cAttribute)
	
	C_DATE:C307($dFirstOfYear)
	
	C_OBJECT:C1216($esCustomers_Order_Lines)
	
	C_TEXT:C284($tViewProArea)
	C_TEXT:C284($tQuery)
	
	ARRAY TEXT:C222($atAttribute; 0)
	
	$bTitle:=True:C214
	
	$cBillTo:=New collection:C1472("09827"; "09919"; "02408"; "09080")
	
	$cStatus:=New collection:C1472("closed"; "accepted")
	
	$cAttribute:=New collection:C1472(\
		"OrderNumber"; \
		"CustID"; \
		"CustomerName"; \
		"defaultBillto"; \
		"DateOpened"; \
		"ORDER.EnteredBy"; \
		"ORDER.PONumber"; \
		"CustomerLine"; \
		"PRODUCT_CODE.ProductCode"; \
		"PRODUCT_CODE.CartonDesc"; \
		"Quantity"+CorektPipe+"#"; \
		"Price_Per_M"+CorektPipe+"$"; \
		"Price_Extended"+CorektPipe+"$")
	
	$dFirstOfYear:=Core_Date_UsePhraseD("Begin Year")
	
	$tViewProArea:="ViewProArea"
	
	$tQuery:="defaultBillto IN :1 AND "+\
		"Status IN :2 AND "+\
		"DateOpened >= :3"
	
End if   //Done initialize

$esCustomers_Order_Lines:=ds:C1482.Customers_Order_Lines.query($tQuery; $cBillTo; $cStatus; $dFirstOfYear)

VwPr_SetRow($tViewProArea; $cAttribute; $esCustomers_Order_Lines; $bTitle)
