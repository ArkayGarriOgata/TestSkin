//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/17/08, 14:15:59
// ----------------------------------------------------
// Method: Batch_Bookings_by_Line(date)
// Description
// report a days bookings by customer line
//
// Parameters - target date
// ----------------------------------------------------
// Modified by: Mel Bohince (3/31/14) remove "rentals" exclusion
// Modified by: Mel Bohince (3/25/15) html'ize the mailing
// Modified by: Mel Bohince (9/18/15) change to SQL, kill the distribution list
// Modified by: Mel Bohince (9/10/21) add group by and sort by clauses and fix loop terminator

C_DATE:C307($1; $date)
$tableData:=""

If (Count parameters:C259=0)
	$date:=Date:C102(Request:C163("What date?"; String:C10(Current date:C33; System date short:K1:1); "OK"; "Cancel"))
	distributionList:=Request:C163("Send to:"; "mel.bohince@arkay.com"; "OK"; "Cancel")
Else 
	$date:=$1
End if 

//QUERY([Customers_Order_Lines];[Customers_Order_Lines]DateOpened=$date;*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"Cancel@";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"Kill";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"New";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"Contract";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"Open@";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]Status#"Rejected")

//$numRecs:=Records in selection([Customers_Order_Lines])

ARRAY TEXT:C222($aCust_Total; 0)
ARRAY TEXT:C222($aLine_Total; 0)
ARRAY LONGINT:C221($aQty_Total; 0)
ARRAY REAL:C219($aCost_total; 0)
ARRAY REAL:C219($aPrice_Total; 0)
// Modified by: Mel Bohince (9/10/21) add group by clause
Begin SQL
	SELECT CustomerName, CustomerLine, sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
	from Customers_Order_Lines
	where DateOpened = :$date and
	UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
	order by CustomerName, CustomerLine 
	group by CustomerName, CustomerLine 
	into :$aCust_Total, :$aLine_Total, :$aPrice_Total, :$aCost_total, :$aQty_Total
End SQL

$numRecs:=Size of array:C274($aCust_Total)
C_TEXT:C284($t; $r)


If ($numRecs>0)
	//SELECTION TO ARRAY([Customers_Order_Lines]CustomerName;$aCust;[Customers_Order_Lines]CustomerLine;$aLine;[Customers_Order_Lines]Quantity;$aQty;[Customers_Order_Lines]Cost_Per_M;$aCost;[Customers_Order_Lines]Price_Per_M;$aPrice;[Customers_Order_Lines]SpecialBilling;$aSplBill)
	//MULTI SORT ARRAY($aCust;>;$aLine;>;$aQty;$aCost;$aPrice;$aSplBill)
	//ARRAY TEXT($aCust_Total;0)
	//ARRAY TEXT($aLine_Total;0)
	//ARRAY LONGINT($aQty_Total;0)
	//ARRAY REAL($aCost_total;0)
	//ARRAY REAL($aPrice_Total;0)
	//$cursor:=0
	//$currentCust:=""
	//$currentLine:=""
	//uThermoInit ($numRecs;"Saving bookings by line")
	//For ($i;1;$numRecs)
	//If ($currentCust#$aCust{$i})
	//$currentCust:=$aCust{$i}
	//$currentLine:=$aLine{$i}
	//APPEND TO ARRAY($aCust_Total;$currentCust)
	//APPEND TO ARRAY($aLine_Total;$currentLine)
	//APPEND TO ARRAY($aQty_Total;0)
	//APPEND TO ARRAY($aCost_total;0)
	//APPEND TO ARRAY($aPrice_Total;0)
	//$cursor:=Size of array($aCust_Total)
	//End if 
	//If ($currentLine#$aLine{$i})
	//$currentLine:=$aLine{$i}
	//APPEND TO ARRAY($aCust_Total;$currentCust)
	//APPEND TO ARRAY($aLine_Total;$currentLine)
	//APPEND TO ARRAY($aQty_Total;0)
	//APPEND TO ARRAY($aCost_total;0)
	//APPEND TO ARRAY($aPrice_Total;0)
	//$cursor:=Size of array($aCust_Total)
	//End if 
	
	//$aQty_Total{$cursor}:=$aQty_Total{$cursor}+$aQty{$i}
	//If ($aSplBill{$i})
	//$aCost_total{$cursor}:=$aCost_total{$cursor}+($aQty{$i}*$aCost{$i})
	//$aPrice_Total{$cursor}:=$aPrice_Total{$cursor}+($aQty{$i}*$aPrice{$i})
	//Else 
	//$aCost_total{$cursor}:=$aCost_total{$cursor}+($aQty{$i}/1000*$aCost{$i})
	//$aPrice_Total{$cursor}:=$aPrice_Total{$cursor}+($aQty{$i}/1000*$aPrice{$i})
	//End if 
	
	//uThermoUpdate ($i)
	//End for 
	//uThermoClose 
	
	
	$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$r:="</td></tr>"+Char:C90(13)
	$tableData:=$tableData+$b+"Customer Name"+$t+"Line"+$t+"Quantity"+$t+"Cost"+$t+"Price"+$t+"PV"+$r
	
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
	$totalUnits:=0
	$totalCost:=0
	$totalPrice:=0
	For ($i; 1; $numRecs)  // Modified by: Mel Bohince (9/10/21) change $cursor to $numRec
		$totalUnits:=$totalUnits+$aQty_Total{$i}
		$totalCost:=$totalCost+$aCost_total{$i}
		$totalPrice:=$totalPrice+$aPrice_Total{$i}
		
		If (($i%2)#0)  //alternate row color
			$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
		Else 
			$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
		End if 
		
		$tableData:=$tableData+$b+$aCust_Total{$i}+$t+$aLine_Total{$i}+$t+String:C10($aQty_Total{$i}; "#,###,###")+$t+String:C10(Round:C94($aCost_total{$i}; 0); "#,###,###")+$t+String:C10(Round:C94($aPrice_Total{$i}; 0); "#,###,###")+$t+String:C10(Round:C94(fProfitVariable("PV"; $aCost_total{$i}; $aPrice_Total{$i}; 0)*100; 1))+$r
		
	End for 
	
	$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$tableData:=$tableData+$b+"TOTALS"+$t+" "+$t+String:C10($totalUnits; "##,###,###")+$t+String:C10(Round:C94($totalCost; 0); "##,###,###")+$t+String:C10(Round:C94($totalPrice; 0); "##,###,###")+$t+String:C10(Round:C94(fProfitVariable("PV"; $totalCost; $totalPrice; 0)*100; 1))+$r
	
Else 
	//SEND PACKET($docRef;"No bookings found for "+String($date;System date short)+$r)
End if 


If (Length:C16($tableData)>0)
	xTitle:="Customer Bookings By Line "+String:C10($date; Internal date short:K1:7)
	xText:="Summary of orders booked by Customers' Lines as of "+String:C10($date; Internal date short:K1:7)  //+$r+"Open the attached with Excel"
	
	$distributionList:="mel.bohince@arkay.com"
	
	Email_html_table(xTitle; xText; $tableData; 600; $distributionList)
End if 
xTitle:=""
xText:=""