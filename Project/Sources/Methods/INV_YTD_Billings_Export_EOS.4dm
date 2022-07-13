//%attributes = {"executedOnServer":true}
// _______
// Method: INV_YTD_Billings_Export_EOS   ( ) ->
// By: Mel Bohince @ 10/25/21, 10:07:33
// Description
// prep the export on the server and return invoices as a csv file
// ----------------------------------------------------
// Modified by: Mel Bohince (10/30/21) switch for text concatenation to collection join
// Modified by: MelvinBohince (4/28/22) add CoGS and Contribution
// Modified by: MelvinBohince (5/6/22) add Throughput
// Modified by: MelvinBohince (5/17/22) renamed CoGS_Material
ON ERR CALL:C155("e_ExeOnServerError")

C_DATE:C307($dateBegin; $1; $2; $dateEnd)
$dateBegin:=$1
$dateEnd:=$2

C_LONGINT:C283($startMillisec; $durationSec)  //timing for console log
$startMillisec:=Milliseconds:C459  //benchmark
$testComment:="collection join"  //for console log when intial benchmarking was done

C_OBJECT:C1216($quarters_o)  //hash to find quarter month belongs in
$quarters_o:=New object:C1471("1"; "Q1"; "2"; "Q1"; "3"; "Q1"; "4"; "Q2"; "5"; "Q2"; "6"; "Q2"; "7"; "Q3"; "8"; "Q3"; "9"; "Q3"; "10"; "Q4"; "11"; "Q4"; "12"; "Q4")  //key-value pairs

C_OBJECT:C1216($invoice_e; $invoices_es)
$invoices_es:=ds:C1482.Customers_Invoices.query("Invoice_Date >=:1 and Invoice_Date <= :2"; $dateBegin; $dateEnd).orderBy("InvoiceNumber")

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

//now build the report
C_TEXT:C284($0; $fieldDelimitor; $recordDelimitor)
$fieldDelimitor:=","
$recordDelimitor:="\r"

C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
$rows_c:=New collection:C1472  //there will be a row for each invoice


If (True:C214)  //start with the column headings  // Modified by: Mel Bohince (10/30/21) switch for text concatenation to collection join
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
	$columns_c.push("CoGS_bud")  // Modified by: MelvinBohince (4/28/22) add CoGS
	$columns_c.push("CoGS_act")  // Modified by: MelvinBohince (5/6/22) 
	$columns_c.push("Contrib_act")  // Modified by: MelvinBohince (5/6/22) 
	$columns_c.push("Matl_act")  // Modified by: MelvinBohince (4/28/22) add Contribution
	$columns_c.push("Throughput")  // Modified by: MelvinBohince (5/6/22) 
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if   //headings

For each ($invoice_e; $invoices_es)  //add a row for each invoice   // Modified by: Mel Bohince (10/30/21) switch for text concatenation to collection join
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
	$columns_c.push(String:C10($invoice_e.CoGS))  // Modified by: MelvinBohince (4/28/22) add CoGS
	$columns_c.push(String:C10($invoice_e.CoGS_Actual))
	$columns_c.push(String:C10($invoice_e.ExtendedPrice-$invoice_e.CoGS_Actual))  //contribution actual
	$columns_c.push(String:C10($invoice_e.CoGS_Material))
	$columns_c.push(String:C10($invoice_e.ExtendedPrice-$invoice_e.CoGS_Material))  //throughput
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$0:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText

$durationSec:=(Milliseconds:C459-$startMillisec)/1000  //benchmark
utl_Logfile("benchmark.log"; "YTD_Billings+"+$testComment+" took "+String:C10($durationSec)+" seconds")

ON ERR CALL:C155("")
