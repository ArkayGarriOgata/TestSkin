//%attributes = {}
// _______
// Method: Booking_Data_Structure   ( ) ->
// By: Mel Bohince @ 11/22/21, 13:31:45
// Description
// explore representation of bookings
// ----------------------------------------------------

If (True:C214)  //get the date range
	C_LONGINT:C283($1; $fiscalYear)
	
	If (Count parameters:C259=1)
		$fiscalYear:=$1
	Else 
		$fiscalYear:=2021  //Num(FiscalYear ("year";Current date))
	End if 
	
	$dateBegin:=Date:C102("01/01/"+String:C10($fiscalYear))
	$dateEnd:=Add to date:C393($dateBegin; 1; 0; -1)
End if 

If (True:C214)  //get all the orderlines for the requested year
	C_COLLECTION:C1488($ordStats_c)  //criterian for order status desired
	$ordStats_c:=New collection:C1472  //going to ignore cancel, contract, hold, new, opened, and rejected
	$ordStats_c.push("accepted")
	$ordStats_c.push("closed")
	
	C_OBJECT:C1216($orderlines_es)
	$orderlines_es:=ds:C1482.Customers_Order_Lines.query("DateOpened >=  :1 and DateOpened <= :2 and Status in :3 "; \
		$dateBegin; $dateEnd; $ordStats_c)
End if 


If (True:C214)  //build the grid
	//a row for each customer
	$customers_c:=$orderlines_es.distinct("CustID")
	
	C_COLLECTION:C1488($bookings_c; $costs_c; $quantities_c)
	$bookings_c:=New collection:C1472
	$costs_c:=New collection:C1472
	$quantities_c:=New collection:C1472
	
	C_TEXT:C284($id)
	For each ($id; $customers_c)
		//if periods are collections: //$bookings_c.push(New object("id";$id;"name";CUST_getName ($id;"elc");"months";New collection(0;0;0;0;0;0;0;0;0;0;0;0;0)))
		//or
		$bookings_c.push(New object:C1471("id"; $id; "name"; CUST_getName($id; "elc"); "01"; 0; "02"; 0; "03"; 0; "04"; 0; "05"; 0; "06"; 0; "07"; 0; "08"; 0; "09"; 0; "10"; 0; "11"; 0; "12"; 0; "total"; 0))
		$costs_c.push(New object:C1471("id"; $id; "name"; CUST_getName($id; "elc"); "01"; 0; "02"; 0; "03"; 0; "04"; 0; "05"; 0; "06"; 0; "07"; 0; "08"; 0; "09"; 0; "10"; 0; "11"; 0; "12"; 0; "total"; 0))
		$quantities_c.push(New object:C1471("id"; $id; "name"; CUST_getName($id; "elc"); "01"; 0; "02"; 0; "03"; 0; "04"; 0; "05"; 0; "06"; 0; "07"; 0; "08"; 0; "09"; 0; "10"; 0; "11"; 0; "12"; 0; "total"; 0))
	End for each 
	
End if 



If (True:C214)  //tally the orders
	
	C_OBJECT:C1216($orderline_e)
	For each ($orderline_e; $orderlines_es)
		$index_c:=$bookings_c.indices("id = :1"; $orderline_e.CustID)
		$index:=$index_c[0]
		
		$mth:=Month of:C24($orderline_e.DateOpened)
		//if periods are collections: $bookings_c[$index].months[$mth]:=$bookings_c[$index].months[$mth]+$orderline_e.Price_Extended
		$bookings_c[$index][String:C10($mth; "00")]:=$bookings_c[$index][String:C10($mth; "00")]+$orderline_e.Price_Extended
		$costs_c[$index][String:C10($mth; "00")]:=$costs_c[$index][String:C10($mth; "00")]+$orderline_e.Cost_Extended
		$quantities_c[$index][String:C10($mth; "00")]:=$quantities_c[$index][String:C10($mth; "00")]+$orderline_e.Quantity
	End for each 
	
	//VP SET VALUES (VP Cell ($viewProAreaName;0;0);$bookings_c)
	
End if 

If (True:C214)  //get (column) totals for each period and (row) totals for each customer
	
	ARRAY LONGINT:C221($periodTotals; 13)  //buckets for month totals
	For ($mth; 1; 12)  //initialize
		$periodTotals{$mth}:=0
	End for 
	
	ARRAY LONGINT:C221($customerTotals; $bookings_c.length)  //buckets for customer totals
	
	C_LONGINT:C283($customerCounter)
	$customerCounter:=0
	C_OBJECT:C1216($cust_o)
	
	For each ($cust_o; $bookings_c)
		$customerCounter:=$customerCounter+1
		
		//$cust_o.months[0]:=$cust_o.months.sum()
		For ($mth; 1; 12)  //
			$customerTotals{$customerCounter}:=$customerTotals{$customerCounter}+$cust_o[String:C10($mth; "00")]
		End for 
		
		For ($mth; 1; 12)
			$periodTotals{$mth}:=$periodTotals{$mth}+$cust_o[String:C10($mth; "00")]
		End for 
		
		
	End for each 
	
End if 

//print it



C_COLLECTION:C1488($periods_c)
$periods_c:=New collection:C1472("ID"; "Name"; "Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun"; "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec"; "Total")



