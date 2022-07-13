//%attributes = {"executedOnServer":true}
// _______
// Method: INV_RightClickToExcel_eos   ( ) ->
// By: MelvinBohince @ 03/21/22, 10:29:01
// Description
// run the csv build on the server
// see INV_RightClickToExcel 
// ----------------------------------------------------
// Modified by: MelvinBohince (3/24/22) can't receive entity selection, change to array object

C_TEXT:C284($0)  //retrun $csvText

//use the currently displayed invoices
C_OBJECT:C1216($invoice_e; $invoices_es; $1; $selectionArray_o)
//$invoices_es:=$1
$selectionArray_o:=$1  // Modified by: MelvinBohince (3/24/22) can't receive entity selection, change to array object
ARRAY LONGINT:C221($_recordNumbers; 0)
OB GET ARRAY:C1229($selectionArray_o; "recordNumbers"; $_recordNumbers)
CREATE SELECTION FROM ARRAY:C640([Customers_Invoices:88]; $_recordNumbers)
$invoices_es:=Create entity selection:C1512([Customers_Invoices:88])

C_BOOLEAN:C305($listingWYSIWYG; $2)
$listingWYSIWYG:=$2  //either whats shown on the invoice listing or like the ytd billing style

C_TEXT:C284($fieldDelimitor; $recordDelimitor)
$fieldDelimitor:=","
$recordDelimitor:="\r"

If (Not:C34($listingWYSIWYG))  //options from existing INV_YTD_Billings_Export_EOS, to minimize server calls
	C_OBJECT:C1216($quarters_o)  //hash to find quarter month belongs in
	$quarters_o:=New object:C1471("1"; "Q1"; "2"; "Q1"; "3"; "Q1"; "4"; "Q2"; "5"; "Q2"; "6"; "Q2"; "7"; "Q3"; "8"; "Q3"; "9"; "Q3"; "10"; "Q4"; "11"; "Q4"; "12"; "Q4")  //key-value pairs
	
	C_COLLECTION:C1488($customers_c; $customer_c; $billTos_c; $shipTos_c)  //cache values for name etc.
	C_TEXT:C284($id)  //used as iterator
	
	//build hash tables to minimize calls to related tables
	//build a cache of customer name objects for each distinct customer id
	$customers_c:=$invoices_es.distinct("CustomerID")
	//build the key-value object like  custname:=$customerNames_o["00050"]
	$customerNames_o:=New object:C1471
	
	For each ($id; $customers_c)
		If (Length:C16($id)=5)
			$customerNames_o[$id]:=CUST_getName($id; "elc")
		Else 
			//why no custid? spl billing mistake?
		End if 
	End for each 
	
	//addresses like customername method above
	$billTos_c:=$invoices_es.distinct("BillTo")
	$billToNames_o:=New object:C1471
	$billToCountry_o:=New object:C1471
	$billToState_o:=New object:C1471
	$billToCity_o:=New object:C1471
	For each ($id; $billTos_c)
		$billToNames_o[$id]:=ADDR_getName($id)
		$billToCountry_o[$id]:=txt_Trim(ADDR_getCountry($id))
		$billToState_o[$id]:=txt_Trim(ADDR_getState($id))
		$billToCity_o[$id]:=txt_Trim(ADDR_getCity($id))
	End for each 
	
	$shipTos_c:=$invoices_es.distinct("ShipTo")
	$shipToCountry_o:=New object:C1471
	$shipToState_o:=New object:C1471
	$shipToCity_o:=New object:C1471
	For each ($id; $shipTos_c)
		$shipToCountry_o[$id]:=txt_Trim(ADDR_getCountry($id))
		$shipToState_o[$id]:=txt_Trim(ADDR_getState($id))
		$shipToCity_o[$id]:=txt_Trim(ADDR_getCity($id))
	End for each 
	
End if 


C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
$rows_c:=New collection:C1472  //there will be a row for each invoice


If ($listingWYSIWYG)  //currently displayed columns
	$columns_c:=New collection:C1472
	$columns_c.push("InvoiceNumber")
	$columns_c.push("InvoiceDate")
	$columns_c.push("Status")
	$columns_c.push("Line")
	$columns_c.push("Customer")
	$columns_c.push("SoldTo")
	$columns_c.push("Quantity")
	$columns_c.push("ExtendedPrice")
	$columns_c.push("ProductCode")
	$columns_c.push("Order")
	$columns_c.push("PurchaseOrder")
	$columns_c.push("EDImsgID")
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
Else   //custom columns
	
	$columns_c:=New collection:C1472
	$columns_c.push("CustomerID")
	$columns_c.push("Customer")
	$columns_c.push("Line")
	$columns_c.push("InvoiceNumber")
	$columns_c.push("InvoiceDate")
	$columns_c.push("Period")
	$columns_c.push("Quarter")
	$columns_c.push("Year")
	$columns_c.push("SalesPerson")
	$columns_c.push("Commission")
	$columns_c.push("BilltoUsed")
	$columns_c.push("City")
	$columns_c.push("State")
	$columns_c.push("Country")
	$columns_c.push("SoldTo")
	$columns_c.push("Quantity")
	$columns_c.push("ExtendedPrice")
	$columns_c.push("PV")
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
End if   //headings

For each ($invoice_e; $invoices_es)  //add a row for each invoice   // Modified by: Mel Bohince (10/30/21) switch for text concatenation to collection join
	
	If ($listingWYSIWYG)  //currently displayed columns
		$columns_c:=New collection:C1472
		$columns_c.push(String:C10($invoice_e.InvoiceNumber))
		$columns_c.push(String:C10($invoice_e.Invoice_Date; Internal date short special:K1:4))
		$columns_c.push($invoice_e.Status)
		$columns_c.push(txt_quote($invoice_e.CustomerLine))
		$columns_c.push(txt_quote(CUST_getName($invoice_e.CustomerID; "elc")))
		$columns_c.push(txt_quote(ADDR_getName($invoice_e.BillTo)))
		$columns_c.push(txt_quote(String:C10($invoice_e.Quantity; "##,###,##0")))
		$columns_c.push(txt_quote(String:C10($invoice_e.ExtendedPrice; "##,###,##0.00")))
		$columns_c.push(txt_quote($invoice_e.ProductCode))
		$columns_c.push($invoice_e.OrderLine)
		$columns_c.push(txt_quote($invoice_e.CustomersPO))
		$columns_c.push(String:C10($invoice_e.EDI_Prep))
		
	Else   //like YTD_Billings
		//resolve the destination, specail bill items do not have a ship-to and that is what the use tax liability needs.
		
		If (Length:C16($invoice_e.ShipTo)=5)
			$country:=$shipToCountry_o[$invoice_e.ShipTo]
			$state:=$shipToState_o[$invoice_e.ShipTo]
			$city:=$shipToCity_o[$invoice_e.ShipTo]
			$flag:=""
		Else 
			$country:=$billToCountry_o[$invoice_e.BillTo]
			$state:=$billToState_o[$invoice_e.BillTo]
			$city:=$billToCity_o[$invoice_e.BillTo]
			$flag:="*"
		End if 
		
		$billToName:=$billToNames_o[$invoice_e.BillTo]
		$custName:=$customerNames_o[$invoice_e.CustomerID]
		
		$columns_c:=New collection:C1472
		$columns_c.push($invoice_e.CustomerID)
		$columns_c.push(txt_quote($custName))
		$columns_c.push(txt_quote($invoice_e.CustomerLine))
		$columns_c.push(String:C10($invoice_e.InvoiceNumber))
		$columns_c.push(String:C10($invoice_e.Invoice_Date; Internal date short special:K1:4))
		$columns_c.push(fYYYYMM($invoice_e.Invoice_Date))
		$columns_c.push($quarters_o[String:C10(Month of:C24($invoice_e.Invoice_Date))])
		$columns_c.push(String:C10(Year of:C25($invoice_e.Invoice_Date)))
		$columns_c.push($invoice_e.SalesPerson)
		$columns_c.push(String:C10($invoice_e.CommissionPayable))
		$columns_c.push($flag)
		$columns_c.push(txt_quote($city))
		$columns_c.push(txt_quote($state))
		$columns_c.push($country)
		$columns_c.push(txt_quote($billToName))
		$columns_c.push(String:C10($invoice_e.Quantity))
		$columns_c.push(String:C10($invoice_e.ExtendedPrice))
		$columns_c.push(String:C10($invoice_e.ProfitVariable))
	End if   //($listingWYSIWYG)  //currently displayed columns
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$0:=$rows_c.join($recordDelimitor)  //return the csv text
