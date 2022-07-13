//%attributes = {"executedOnServer":true}
// _______
// Method: Booking_EOS   ( $dateBegin ; $dateEnd) -> csv text
// By: Mel Bohince @ 10/30/21, 18:11:01
// Description
// export bookings data (orderlines that are accepted or closed, 
// based on method Bookings ( ) but executed on server and using ORDA + a few more columns
// ----------------------------------------------------
// Modified by: Mel Bohince (11/5/21) exclude status Hold to match Cust_BnB_Data's querys
// Modified by: Mel Bohince (11/17/21) add billto name to assist with Voyant segregation
// Modified by: Mel Bohince (11/24/21) add email warning if extended price exeeds $500,000

C_DATE:C307($dateBegin; $1; $dateEnd; $2)

Case of 
	: (Count parameters:C259=2)  //specified, should be the only usecase
		$dateBegin:=$1
		$dateEnd:=$2
		
	Else   //default to beginning fiscal to current date, testing
		$dateBegin:=!2021-08-01!  //Date(FiscalYear ("start";Current date))
		$dateEnd:=Current date:C33
End case 

C_LONGINT:C283($startMillisec; $durationSec)  //timing for console log
$startMillisec:=Milliseconds:C459  //benchmark
$testComment:="collection join"  //for console log when intial benchmarking was done

ON ERR CALL:C155("e_ExeOnServerError")

C_COLLECTION:C1488($ordStats_c)  //criterian for order status desired
$ordStats_c:=New collection:C1472  //going to ignore cancel, contract, hold, new, opened, and rejected
$ordStats_c.push("accepted")
$ordStats_c.push("closed")
//$ordStats_c.push("hold")// Modified by: Mel Bohince (11/5/21) 

$orderlines_es:=ds:C1482.Customers_Order_Lines.query("DateOpened >=  :1 and DateOpened <= :2 and Status in :3 "; \
$dateBegin; $dateEnd; $ordStats_c)\
.orderBy("OrderLine")

C_COLLECTION:C1488($customers_c)  //cache values for name etc.
C_TEXT:C284($id)  //used as iterator

//build hash tables to minimize calls to related tables
//build a cache of customer name objects for each distinct customer id
$customers_c:=$orderlines_es.distinct("CustID")
//build the key-value object like  custname:=$customerNames_o["00050"]
$customerNames_o:=New object:C1471

For each ($id; $customers_c)
	If (Length:C16($id)=5)
		$customerNames_o[$id]:=CUST_getName($id; "elc")
	End if 
End for each 

//now build the report
C_TEXT:C284($0; $fieldDelimitor; $recordDelimitor)
$fieldDelimitor:=","
$recordDelimitor:="\r"

C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
$rows_c:=New collection:C1472  //there will be a row for each invoice

If (True:C214)  //start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("OrderLine")
	$columns_c.push("SalesRep")
	$columns_c.push("CustomerName")
	$columns_c.push("CustomerLine")
	$columns_c.push("Quantity")
	$columns_c.push("Cost_Per_M")
	$columns_c.push("Price_Per_M")
	$columns_c.push("Net_Shipped")
	$columns_c.push("ExtendedPrice")
	$columns_c.push("specialBilling")
	$columns_c.push("DateOpened")
	$columns_c.push("Period")
	$columns_c.push("CustomerShortName")
	$columns_c.push("ExtendedCost")
	$columns_c.push("AnticipatedMargin")
	$columns_c.push("PV")
	$columns_c.push("Bill-to-Name")
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if   //headings

For each ($order_e; $orderlines_es)
	
	$columns_c:=New collection:C1472
	$columns_c.push($order_e.OrderLine)
	$columns_c.push($order_e.SalesRep)
	$columns_c.push(txt_quote($order_e.CustomerName))
	$columns_c.push(txt_quote($order_e.CustomerLine))
	$columns_c.push(String:C10($order_e.Quantity))
	$columns_c.push(String:C10($order_e.Cost_Per_M))
	$columns_c.push(String:C10($order_e.Price_Per_M))
	$columns_c.push(String:C10($order_e.Qty_Shipped-$order_e.Qty_Returned))
	$columns_c.push(String:C10($order_e.Price_Extended))
	$columns_c.push(Choose:C955($order_e.SpecialBilling; "True"; "False"))
	$columns_c.push(String:C10($order_e.DateOpened; Internal date short special:K1:4))
	$columns_c.push(fYYYYMM($order_e.DateOpened))
	$columns_c.push(txt_quote($customerNames_o[$order_e.CustID]))
	$columns_c.push(String:C10($order_e.Cost_Extended))
	$columns_c.push(String:C10($order_e.Price_Extended-$order_e.Cost_Extended))
	$columns_c.push(String:C10(Round:C94(fProfitVariable("PV"; $order_e.Cost_Extended; $order_e.Price_Extended; 0)*100; 0)))
	$columns_c.push(txt_quote(ADDR_getName($order_e.defaultBillto)))  // Modified by: Mel Bohince (11/17/21) 
	
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
	If ($order_e.Price_Extended>500000)  // Modified by: Mel Bohince (11/24/21) 
		If (Not:C34($order_e.VerifiedBig))
			$distribList:=Batch_GetDistributionList("ACCTG")
			$distribList:=$distribList+"\tkristopher.koertge@arkay.com"
			$subject:="OrderLine "+$order_e.OrderLine+" exceeds $500,000"
			$body:="Please verify that orderline "+$order_e.OrderLine+" is correct at "+String:C10($order_e.Price_Extended; "###,###,###,###,##0")+" dollars, check quantity, pricing uom, splBill, and price."
			
			EMAIL_Sender($subject; ""; $body; $distribList)
		End if 
	End if 
	
End for each 

$0:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText

$durationSec:=(Milliseconds:C459-$startMillisec)/1000  //benchmark
utl_Logfile("benchmark.log"; "YTD_Bookings+"+$testComment+" took "+String:C10($durationSec)+" seconds")

ON ERR CALL:C155("")
