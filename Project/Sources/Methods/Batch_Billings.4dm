//%attributes = {"publishedWeb":true}
//PM: Batch_Billings(date) -> 
//@author mlb - 3/7/03  11:10
// Modified by: Mel Bohince (9/30/13) convert processing to sql while looking for error

C_TEXT:C284($0; $text)
C_DATE:C307($date; $1)
C_REAL:C285($total)
C_LONGINT:C283($i)

//utl_LogIt ("init")
$text:=""
If (Count parameters:C259=1)
	$date:=$1
Else 
	$date:=Date:C102(Request:C163("Billings for what date?"; String:C10(4D_Current_date; System date short:K1:1); "Ok"; "Go"))
End if 

//get billings for the day by customer
ARRAY TEXT:C222(aCust; 0)
ARRAY REAL:C219(aPrice; 0)
Begin SQL
	SELECT CustomerID, sum(ExtendedPrice)
	from Customers_Invoices
	where Invoice_Date = :$date group by CustomerID
	into :aCust, :aPrice
End SQL

//READ ONLY([Customers_Invoices])
//QUERY([Customers_Invoices];[Customers_Invoices]Invoice_Date=$date)
//$numRecs:=Records in selection([Customers_Invoices])
//If ($numRecs>0)
//SELECTION TO ARRAY([Customers_Invoices]CustomerID;$aCustid;[Customers_Invoices]ExtendedPrice;$aExtPrice)
//SORT ARRAY($aCustid;$aExtPrice;>)
//$currentCust:=""
//ARRAY TEXT(aCust;$numRecs)
//ARRAY REAL(aPrice;$numRecs)
//$cursor:=0
//For ($i;1;$numRecs)
//If ($currentCust#$aCustid{$i})
//$cursor:=$cursor+1
//aCust{$cursor}:=$aCustid{$i}
//$currentCust:=$aCustid{$i}
//End if 
//aPrice{$cursor}:=aPrice{$cursor}+$aExtPrice{$i}
//End for 
//
//ARRAY TEXT(aCust;$cursor)
//ARRAY REAL(aPrice;$cursor)

If (Size of array:C274(aCust)>0)
	//Total and replace custid with custname
	$total:=0
	For ($i; 1; Size of array:C274(aCust))
		$text:=$text+String:C10(Round:C94(aPrice{$i}; 0); "$###,###,##0")+Char:C90(9)+CUST_getName(aCust{$i}; "el")+Char:C90(13)
		$total:=$total+aPrice{$i}
	End for 
	$text:=$text+"--------------"+Char:C90(9)+"------------------"+Char:C90(13)
	$text:=$text+String:C10(Round:C94($total; 0); "###,###,##0")+Char:C90(9)+" TOTAL"+Char:C90(13)
	
Else 
	$text:="No invoices on "+String:C10($date; System date short:K1:1)
End if 

//utl_LogIt ($text)
//utl_LogIt("show")
$0:=$text