//%attributes = {"executedOnServer":true}
// _______
// Method: Bookings_Pivot_EOS   ( ) -> collection of customers by month with totals
// By: Mel Bohince @ 11/22/21, 13:31:45
// Description
// representation of bookings as a 12 month grid
// ----------------------------------------------------

C_DATE:C307($1; $2; $dateBegin; $dateEnd)
C_COLLECTION:C1488($0)

If (Count parameters:C259=2)
	$dateBegin:=$1
	$dateEnd:=$2
	
Else   //testing
	$dateBegin:=Date:C102("01/01/"+FiscalYear("year"; Current date:C33))
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

If (True:C214)  //build the empty grid  //a row for each customer
	C_COLLECTION:C1488($bookings_c; $costs_c; $quantities_c)
	$bookings_c:=Customer_Pivot_Creation($orderlines_es)  //prep the booking pivot
	$costs_c:=$bookings_c.copy()  //cost totals will be used for PV calculations
	$quantities_c:=$bookings_c.copy()  //include the unit volumes
End if 

If (True:C214)  //tally the orders' price, cost and qty in 3 separate collections
	C_OBJECT:C1216($arg_o)  //pass the orderline entity selection and the grids to fill using a specifed attribute
	$arg_o:=New object:C1471("entitySelection"; $orderlines_es; \
		"gridCollections"; New collection:C1472(\
		New object:C1471("collection"; $bookings_c; "attribute"; "Price_Extended"); \
		New object:C1471("collection"; $costs_c; "attribute"; "Cost_Extended"); \
		New object:C1471("collection"; $quantities_c; "attribute"; "Quantity"))\
		)
	
	Customer_Pivot_Population($arg_o)
	
	//$cust_c:=$bookings_c.query("id = :1";"00015")  //should be single hit
	//If ($cust_c.length>0)
	//$febBooking:=$cust_c[0]["02"]  //could all be on same line as query
	//End if 
End if 

If (True:C214)  //get (column) totals for each period and (row) totals for each customer
	
	$lastRow:=$bookings_c.length  //add blank row here so Excel table command works correctly without including the totals row
	
	C_OBJECT:C1216($footer_o)
	//bookings
	$footer_o:=Customer_Pivot_Totals($bookings_c; "BOOKINGS")  //returns an object with booked Sales monthly totals
	$bookings_c.push($footer_o)
	
	//costs
	$footer_o:=Customer_Pivot_Totals($costs_c; "COSTS")
	$bookings_c.push($footer_o)
	
	$footer_o:=Customer_Pivot_Totals($quantities_c; "QTY")
	$bookings_c.push($footer_o)
	
	$footer_o:=New object:C1471  //need to insert a blank row
	$bookings_c:=$bookings_c.insert($lastRow; $footer_o)
	
	
End if 

If (True:C214)  //calc the pv and avg_unit
	$ytdBooking:=0
	$ytdQty:=0
	
	C_OBJECT:C1216($object)
	For each ($object; $bookings_c)
		If (Not:C34(OB Is empty:C1297($object)))
			
			Case of 
				: ($object.name#"TOTALS:")  //look in the costs collection for that customer's total cost
					$cost:=0
					$cust_c:=$costs_c.query("id = :1"; $object.id)  //should be single hit
					If ($cust_c.length>0)
						$cost:=$cust_c[0]["total"]  //could all be on same line as query
					End if 
					
					$object.pv:=Round:C94(fProfitVariable("pv"; $cost; $object.total; 0)*100; 0)
					
					$qty:=0
					$cust_c:=$quantities_c.query("id = :1"; $object.id)  //should be single hit
					If ($cust_c.length>0)
						$qty:=$cust_c[0]["total"]  //could all be on same line as query
					End if 
					If ($qty>0)
						$object.avg_unit:=Round:C94($object.total/$qty*1000; 2)
					Else 
						$object.avg_unit:=0
					End if 
					
					
				: ($object.id="BOOKINGS")
					$cost:=0
					$custCost_c:=$bookings_c.query("id = :1"; "COSTS")  //should be single hit
					If ($custCost_c.length>0)
						$cost:=$custCost_c[0]["total"]
					End if 
					
					$object.pv:=Round:C94(fProfitVariable("pv"; $cost; $object.total; 0)*100; 0)
					
					$ytdBooking:=$object.total  //save for later
					
				: ($object.id="QTY")
					$booked:=0
					$custCost_c:=$bookings_c.query("id = :1"; "BOOKINGS")  //should be single hit
					If ($custCost_c.length>0)
						$booked:=$custCost_c[0]["total"]  //
					End if 
					
					$object.avg_unit:=$booked/$object.total*1000
					
					$ytdQty:=$object.total
			End case   //not a total line
			
		End if   //not a blank line
		
	End for each 
	
	For each ($object; $bookings_c)
		
		If (Not:C34(OB Is empty:C1297($object)))
			
			If ($object.name#"TOTALS:")  //set %participations
				$object.pctOfBkg:=Round:C94($object.total/$ytdBooking*100; 2)
				
				$qty:=0
				$cust_c:=$quantities_c.query("id = :1"; $object.id)  //should be single hit
				If ($cust_c.length>0)
					$qty:=$cust_c[0]["total"]  //could all be on same line as query
				End if 
				
				$object.pctOfQty:=Round:C94($qty/$ytdQty*100; 2)
				
			End if   //not a totals line
			
		End if   //not empty
	End for each 
	
End if 

$0:=$bookings_c
