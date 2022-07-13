//%attributes = {}
// _______
// Method: Booking_Collection_To_CSV   ( $bookings_c ) -> csv text
// By: Mel Bohince @ 12/01/21, 10:13:42
// Description
// 
// ----------------------------------------------------
C_COLLECTION:C1488($bookings_c; $1)
$bookings_c:=$1

C_TEXT:C284($0; $fieldDelimitor; $recordDelimitor; $title; $2)
$title:=$2

$fieldDelimitor:=","
$recordDelimitor:="\r"

C_COLLECTION:C1488($rows_c; $columns_c; $viewRow; $viewCol)  //build each row so they can be joined at the end
$rows_c:=New collection:C1472  //there will be a row for each invoice

If (True:C214)  //start with the column headings //CSV FILE
	$columns_c:=New collection:C1472
	$columns_c.push("Rep")
	$columns_c.push("CustID")
	$columns_c.push("Name")
	
	For ($mth; 1; 12)
		$columns_c.push(Substring:C12(String:C10(Date:C102(String:C10($mth)+"/01/2021"); Internal date abbreviated:K1:6); 1; 3))
	End for 
	
	$columns_c.push("Totals")
	$columns_c.push("PV")
	$columns_c.push("AVG_Unit")
	$columns_c.push("PctOfBkg")
	$columns_c.push("PctOfQty")
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if   //headings

If (True:C214)  //CSV FILE
	C_OBJECT:C1216($obj)
	$customerCounter:=0
	For each ($obj; $bookings_c)
		If (Not:C34(OB Is empty:C1297($obj)))
			
			$customerCounter:=$customerCounter+1
			$columns_c:=New collection:C1472
			
			$columns_c.push($obj.salesRep)
			$columns_c.push($obj.id)
			$columns_c.push($obj.name)
			
			For ($mth; 1; 12)
				$columns_c.push(txt_quote(String:C10($obj[String:C10($mth; "00")]; "###,###,##0")))
			End for 
			
			$columns_c.push(txt_quote(String:C10($obj["total"]; "###,###,##0")))
			
			$columns_c.push(txt_quote(String:C10($obj["pv"]; "##0")))
			
			$columns_c.push(txt_quote(String:C10($obj["avg_unit"]; "###,##0.00")))
			
			$columns_c.push(txt_quote(String:C10($obj["pctOfBkg"]; "##0.00")))
			
			$columns_c.push(txt_quote(String:C10($obj["pctOfQty"]; "##0.00")))
			
			
		Else   //empty obj
			$columns_c:=New collection:C1472
			$columns_c.push("")
		End if 
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
End if   //CSV FILE

$text:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText

$text:=$text+"\r\r\t"+$title+"\r\r\t------ EOF,\t\t see Bookings_UI( ) ------"  // add some distance so excel has room for totals

$0:=$text

