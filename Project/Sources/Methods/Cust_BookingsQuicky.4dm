//%attributes = {}

// Method: Cust_BookingsQuicky ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/05/15, 13:06:45
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_LONGINT:C283($fiscalYear)  //•3/27/00  mlb  fiscal year roll over
C_DATE:C307($fiscalStart; $fiscalEnd; $targetDate; $1)
If (Count parameters:C259=0)
	$targetDate:=Current date:C33
Else 
	$targetDate:=$1
End if 

$fiscalYear:=Num:C11(FiscalYear("year"; $targetDate))
$fiscalStart:=Date:C102(FiscalYear("start"; $targetDate))
$fiscalEnd:=Add to date:C393($fiscalStart; 1; 0; -1)

//$daysIncluded:=$targetDate-$fiscalStart
//$tMinus1Start:=Add to date($fiscalStart;-1;0;0)
//$tMinus1End:=$tMinus1Start+$daysIncluded
//$tMinus2Start:=Add to date($fiscalStart;-2;0;0)
//$tMinus2SEnd:=$tMinus2Start+$daysIncluded


ARRAY TEXT:C222(aCust; 0)
ARRAY REAL:C219(aPrice; 0)
Begin SQL
	SELECT CustID, sum(Price_Extended)
	from Customers_Order_Lines
	where DateOpened >= :$fiscalStart and
	DateOpened <= :$fiscalEnd and
	UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
	group by CustID
	into :aCust, :aPrice
End SQL

SORT ARRAY:C229(aPrice; aCust; <)
$text:=""
$ttl:=0
For ($i; 1; Size of array:C274(aCust))
	$ttl:=$ttl+Round:C94(aPrice{$i}; 0)
	$text:=$text+aCust{$i}+" "+String:C10(Round:C94(aPrice{$i}; 0); "^^^,^^^,^^^")+" "+CUST_getName(aCust{$i}; "el")+"\r"
End for 

If (Count parameters:C259=0)
	utl_LogIt("init")
	utl_LogIt($text)
	utl_LogIt("TOTAL "+String:C10($ttl; "^^^,^^^,^^^"))
	utl_LogIt("show")
End if 