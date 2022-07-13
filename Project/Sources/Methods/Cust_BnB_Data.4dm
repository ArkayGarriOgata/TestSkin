//%attributes = {}

// Method: Cust_BnB_Data ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/06/15, 14:42:34
// ----------------------------------------------------
// Description
// provide date to assist on B&B Spreadsheet
//
// ----------------------------------------------------
//build a collection of rows then style them as html table and pass off to the html responsive method
//--------------------------------------------------

C_LONGINT:C283($fiscalYear)  //•3/27/00  mlb  fiscal year roll over
C_DATE:C307($fiscalStart; $fiscalEnd; $targetDate; $1)
If (Count parameters:C259=0)
	distributionList:=Email_WhoAmI
	//distributionList:="garri.ogata@arkay.com"
	$targetDate:=Date:C102(Request:C163("Based on what date?"; String:C10(Current date:C33; Internal date short:K1:7)))
	If (ok=0)
		$targetDate:=!00-00-00!
	End if 
Else 
	$targetDate:=$1
End if 

If ($targetDate>!00-00-00!)
	//Make arrays for each column of the table to be built
	$row:=18
	ARRAY TEXT:C222($aFISCAL_YEAR; $row)  //YEAR   PERIOD   DAYS  BOOKINGS COSTS  CONTRIBUTION  PV   VARIANCE QUANTITY  AVG/M 
	ARRAY TEXT:C222($aPERIOD; $row)
	ARRAY TEXT:C222($aDAYS; $row)
	ARRAY TEXT:C222($aBOOKINGS; $row)
	ARRAY TEXT:C222($aCOSTS; $row)
	ARRAY TEXT:C222($aCONTRIBUTION; $row)
	ARRAY TEXT:C222($aPV; $row)
	ARRAY TEXT:C222($aVARIANCE; $row)
	ARRAY TEXT:C222($aQUANTITY; $row)
	ARRAY TEXT:C222($aAVE; $row)
	//Column Labels
	$row:=1
	$aFISCAL_YEAR{$row}:="YEAR"
	$aPERIOD{$row}:="PERIOD"
	$aDAYS{$row}:="DAYS"
	$aBOOKINGS{$row}:="BOOKINGS"
	$aCOSTS{$row}:="COSTS"
	$aCONTRIBUTION{$row}:="CONTRIB"
	$aPV{$row}:="PV"
	$aVARIANCE{$row}:="VARIANCE"
	$aQUANTITY{$row}:="QUANTITY"
	$aAVE{$row}:="AVG/M"
	
	C_REAL:C285($booked; $cost; $billed)
	C_LONGINT:C283($qty)
	
	$targetMonth:=String:C10(Month of:C24($targetDate))
	$targetDay:=String:C10(Day of:C23($targetDate))
	$firstOfMonth:=Add to date:C393($targetDate; 0; 0; 1-Day of:C23($targetDate))
	$numMthDays:=String:C10(util_NumberBusinessDays($targetDate; $firstOfMonth))
	
	//THE CURRENT YEAR
	$fiscalYear:=Num:C11(FiscalYear("year"; $targetDate))
	$fiscalStart:=Date:C102(FiscalYear("start"; $targetDate))
	$fiscalEnd:=Add to date:C393($fiscalStart; 1; 0; -1)
	$fiscalMthStart:=Date:C102($targetMonth+"/1/"+String:C10($fiscalYear))
	$fiscalMthEnd:=$targetDate
	
	$daysIncluded:=util_NumberBusinessDays($targetDate; $fiscalStart)  //$targetDate-$fiscalStart
	
	
	//THE PRIOR YEAR
	$minus1Fical:=$fiscalYear-1
	$minus1Start:=Add to date:C393($fiscalStart; -1; 0; 0)
	$minus1End:=Date:C102($targetMonth+"/"+$targetDay+"/"+String:C10($fiscalYear-1))  //$minus1Start+$daysIncluded
	$minus1MthStart:=Date:C102($targetMonth+"/1/"+String:C10($fiscalYear-1))
	$minus1MthEnd:=Date:C102($targetMonth+"/"+$targetDay+"/"+String:C10($fiscalYear-1))
	
	//TWO AGO YEAR
	$minus2Fical:=$fiscalYear-2
	$minus2Start:=Add to date:C393($fiscalStart; -2; 0; 0)
	$minus2End:=Date:C102($targetMonth+"/"+$targetDay+"/"+String:C10($fiscalYear-2))  //$minus2Start+$daysIncluded
	$minus2MthStart:=Date:C102($targetMonth+"/1/"+String:C10($fiscalYear-2))
	$minus2MthEnd:=Date:C102($targetMonth+"/"+$targetDay+"/"+String:C10($fiscalYear-2))
	
	
	
	//ARRAY REAL($aPrice;0)
	//ARRAY REAL($aCost;0)
	//ARRAY LONGINT($aQty;0)
	
	
	//The current month
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$fiscalMthStart and
		DateOpened <= :$fiscalMthEnd and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
		into :$booked, :$cost, :$qty
	End SQL
	$mthBooked:=Round:C94($booked; 0)
	
	$row:=2
	$aFISCAL_YEAR{$row}:=String:C10($fiscalYear)
	$aPERIOD{$row}:="CUR_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	//The current month last year
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$minus1MthStart and
		DateOpened <= :$minus1MthEnd and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
		into :$booked, :$cost, :$qty
	End SQL
	
	
	$numMthDays:=String:C10(util_NumberBusinessDays($minus1MthEnd; $minus1MthStart))
	
	$row:=3
	$aFISCAL_YEAR{$row}:=String:C10($minus1Fical)
	$aPERIOD{$row}:="LY_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($mthBooked-Round:C94($booked; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	
	//The current month 2 years ago
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$minus2MthStart and
		DateOpened <= :$minus2MthEnd and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
		into :$booked, :$cost, :$qty
	End SQL
	
	$numMthDays:=String:C10(util_NumberBusinessDays($minus2MthEnd; $minus2MthStart))
	
	$row:=4
	$aFISCAL_YEAR{$row}:=String:C10($minus2Fical)
	$aPERIOD{$row}:="-2_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($mthBooked-Round:C94($booked; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	
	$row:=5
	$aFISCAL_YEAR{$row}:=" "
	$aPERIOD{$row}:=" "
	$aDAYS{$row}:=" "
	$aBOOKINGS{$row}:=" "
	$aCOSTS{$row}:=" "
	$aCONTRIBUTION{$row}:=" "
	$aPV{$row}:=" "
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=" "
	$aAVE{$row}:=" "
	
	//The current YTD
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$fiscalStart and
		DateOpened <= :$fiscalEnd and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
		into :$booked, :$cost, :$qty
	End SQL
	$yrBooked:=Round:C94($booked; 0)
	
	$row:=6
	$aFISCAL_YEAR{$row}:=String:C10($fiscalYear)
	$aPERIOD{$row}:="CUR_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	
	//The prior YTD
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$minus1Start and
		DateOpened <= :$minus1End and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
		into :$booked, :$cost, :$qty
	End SQL
	
	$daysIncluded:=util_NumberBusinessDays($minus1End; $minus1Start)
	
	$row:=7
	$aFISCAL_YEAR{$row}:=String:C10($minus1Fical)
	$aPERIOD{$row}:="LY_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBooked-Round:C94($booked; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	
	//The YTD 2 yrs ago
	$booked:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= :$minus2Start and
		DateOpened <= :$minus2End and
		UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD')
		into :$booked, :$cost, :$qty
	End SQL
	
	$daysIncluded:=util_NumberBusinessDays($minus2End; $minus2Start)
	
	$row:=8
	$aFISCAL_YEAR{$row}:=String:C10($minus2Fical)
	$aPERIOD{$row}:="-2_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($booked; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($booked; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($booked; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBooked-Round:C94($booked; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($booked/$qty*1000; 0))
	
	$row:=9
	$aFISCAL_YEAR{$row}:=" "
	$aPERIOD{$row}:=" "
	$aDAYS{$row}:=" "
	$aBOOKINGS{$row}:=" "
	$aCOSTS{$row}:=" "
	$aCONTRIBUTION{$row}:=" "
	$aPV{$row}:=" "
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=" "
	$aAVE{$row}:=" "
	
	$row:=10
	$aFISCAL_YEAR{$row}:=" "
	$aPERIOD{$row}:=" "
	$aDAYS{$row}:=" "
	$aBOOKINGS{$row}:=" "
	$aCOSTS{$row}:=" "
	$aCONTRIBUTION{$row}:=" "
	$aPV{$row}:=" "
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=" "
	$aAVE{$row}:=" "
	
	$row:=11
	$aFISCAL_YEAR{$row}:="YEAR"
	$aPERIOD{$row}:="PERIOD"
	$aDAYS{$row}:="DAYS"
	$aBOOKINGS{$row}:="BILLING"
	$aCOSTS{$row}:="COST"
	$aCONTRIBUTION{$row}:=""
	$aPV{$row}:="PV"
	$aVARIANCE{$row}:="VARIANCE"
	$aQUANTITY{$row}:="QUANTITY"
	$aAVE{$row}:="AVG/M"
	
	//BILLINGS
	//MONTH To DATE
	$numMthDays:=String:C10(util_NumberBusinessDays($targetDate; $firstOfMonth))
	
	$billed:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$fiscalMthStart and
		Invoice_Date <= :$fiscalMthEnd
		into :$billed, :$cost, :$qty
	End SQL
	$yrBilled:=Round:C94($billed; 0)
	
	$row:=12
	$aFISCAL_YEAR{$row}:=String:C10($fiscalYear)
	$aPERIOD{$row}:="CUR_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$billed:=0
	$cost:=0
	$qty:=0
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$minus1MthStart and
		Invoice_Date <= :$minus1MthEnd
		into :$billed, :$cost, :$qty
	End SQL
	
	$numMthDays:=String:C10(util_NumberBusinessDays($minus1MthEnd; $minus1MthStart))
	$row:=13
	$aFISCAL_YEAR{$row}:=String:C10($minus1Fical)
	$aPERIOD{$row}:="LY_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBilled-Round:C94($billed; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$billed:=0
	$cost:=0
	$qty:=0
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$minus2MthStart and
		Invoice_Date <= :$minus2MthEnd
		into :$billed, :$cost, :$qty
	End SQL
	
	$numMthDays:=String:C10(util_NumberBusinessDays($minus2MthEnd; $minus2MthStart))
	$row:=14
	$aFISCAL_YEAR{$row}:=String:C10($minus2Fical)
	$aPERIOD{$row}:="-2_MTH"
	$aDAYS{$row}:=$numMthDays
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBilled-Round:C94($billed; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$row:=15
	$aFISCAL_YEAR{$row}:=" "
	$aPERIOD{$row}:=" "
	$aDAYS{$row}:=" "
	$aBOOKINGS{$row}:=" "
	$aCOSTS{$row}:=" "
	$aCONTRIBUTION{$row}:=" "
	$aPV{$row}:=" "
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=" "
	$aAVE{$row}:=" "
	
	//YEAR TO DATE
	$billed:=0
	$cost:=0
	$qty:=0
	
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$fiscalStart and
		Invoice_Date <= :$fiscalEnd
		into :$billed, :$cost, :$qty
	End SQL
	$yrBilled:=Round:C94($billed; 0)
	
	$daysIncluded:=util_NumberBusinessDays($targetDate; $fiscalStart)
	$row:=16
	$aFISCAL_YEAR{$row}:=String:C10($fiscalYear)
	$aPERIOD{$row}:="CUR_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=" "
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$billed:=0
	$cost:=0
	$qty:=0
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$minus1Start and
		Invoice_Date <= :$minus1End
		into :$billed, :$cost, :$qty
	End SQL
	
	$daysIncluded:=util_NumberBusinessDays($minus1End; $minus1Start)
	$row:=17
	$aFISCAL_YEAR{$row}:=String:C10($minus1Fical)
	$aPERIOD{$row}:="LY_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBilled-Round:C94($billed; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$billed:=0
	$cost:=0
	$qty:=0
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo), sum(Quantity)
		from Customers_Invoices
		where Invoice_Date >= :$minus2Start and
		Invoice_Date <= :$minus2End
		into :$billed, :$cost, :$qty
	End SQL
	
	$daysIncluded:=util_NumberBusinessDays($minus2End; $minus2Start)
	$row:=18
	$aFISCAL_YEAR{$row}:=String:C10($minus2Fical)
	$aPERIOD{$row}:="-2_YTD"
	$aDAYS{$row}:=String:C10($daysIncluded)
	$aBOOKINGS{$row}:=String:C10(Round:C94($billed; 0); "###,###,##0")
	$aCOSTS{$row}:=String:C10(Round:C94($cost; 0); "###,###,##0")
	$aCONTRIBUTION{$row}:=String:C10((Round:C94($billed; 0)-Round:C94($cost; 0)); "###,###,##0")
	$aPV{$row}:=String:C10(Round:C94((1-(Round:C94($cost; 0)/Round:C94($billed; 0)))*100; 0))
	$aVARIANCE{$row}:=String:C10($yrBilled-Round:C94($billed; 0); "###,###,##0")
	$aQUANTITY{$row}:=String:C10($qty; "###,###,##0")
	$aAVE{$row}:=String:C10(Round:C94($billed/$qty*1000; 0))
	
	$subject:="B & B "+String:C10($targetDate; System date long:K1:3)
	$prehead:="Comparison of current Bookings and Billings to the prior 2 years showing both year-to-date and month-to-date. "
	$tableData:=""
	
	$r:="</td></tr>"+Char:C90(13)
	
	$stmt_of_position:=Ord_backlog("summary")
	$b:="<tr style=\"background-color:#ffffff\"><td colspan=\"9\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300\">"
	$tableData:=$tableData+$b+$stmt_of_position+$r
	
	For ($i; 1; Size of array:C274($aFISCAL_YEAR))
		
		Case of 
			: ($aFISCAL_YEAR{$i}="YEAR")
				$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
				$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
				
			: (Position:C15("CUR"; $aPERIOD{$i})>0)
				$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				
			: (Position:C15("LY"; $aPERIOD{$i})>0)
				$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				
			: (Position:C15("-2"; $aPERIOD{$i})>0)
				$b:="<tr style=\"background-color:#e5e4e2\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
				
			Else 
				$b:="<tr style=\"background-color:#D1D0CE\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
				$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		End case 
		
		$tableData:=$tableData+$b+$aFISCAL_YEAR{$i}+$t+$aPERIOD{$i}+$t+$aDAYS{$i}+$t+$aBOOKINGS{$i}+$t+$aCOSTS{$i}+$t+$aCONTRIBUTION{$i}+$t+$aPV{$i}+$t+$aVARIANCE{$i}+$t+$aQUANTITY{$i}+$t+$aAVE{$i}+$r
	End for 
	
	Email_html_table($subject; $prehead; $tableData; 690; distributionList)  //685 works
	
	If (False:C215)
		C_TEXT:C284(xTitle; xText; docName)
		C_TIME:C306($docRef)
		C_TEXT:C284($t; $r)
		xText:=""
		$t:=Char:C90(9)
		$r:=Char:C90(13)
		For ($i; 1; Size of array:C274($aFISCAL_YEAR))
			xText:=xText+$aFISCAL_YEAR{$i}+$t+$aPERIOD{$i}+$t+$aDAYS{$i}+$t+$aBOOKINGS{$i}+$t+$aCOSTS{$i}+$t+$aCONTRIBUTION{$i}+$t+$aPV{$i}+$t+$aVARIANCE{$i}+$t+$aQUANTITY{$i}+$t+$aAVE{$i}+$r
		End for 
		
		xTitle:="BOOKINGS & BILLINGS "+String:C10($targetDate; System date long:K1:3)
		
		docName:="BnB_Data_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->docName)
		
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; xTitle+$r+$r)
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
			If (Count parameters:C259=0)
				$err:=util_Launch_External_App(docName)
			End if 
		End if 
	End if   //false
	
Else   //no basis date
	BEEP:C151
End if   //got a target date

