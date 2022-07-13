//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 3/03/00, 12:56:11
// ----------------------------------------------------
// Method: Batch_Bookings(void)  --> 
// Description
// populate the CusomerBookings Table
//
// ----------------------------------------------------
//•3/21/00  mlb  deal with SplBilling in UOM of each
//•3/27/00  mlb  fiscal year roll over
//•3/30/00  mlb biggest movers was > 0, missed cancellations
//• mlb - 3/7/03  11:36 add billings
// • mel (4/16/05, 11:26:51) extend calendar
// Modified by: Mel Bohince (3/31/14) remove "rentals" exclusion
// Modified by: Mel Bohince (9/18/15) lay groundwork for SQL conversion
// Modified by: Mel Bohince (11/19/18) this is because someone forgot to book a big order, now that want it reported, status new and open means not booked.
// Modified by: MelvinBohince (4/5/22) remove cust id from email portion
// ----------------------------------------------------

C_TEXT:C284($t; $cr)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xText:=""
//*move last run into the t-1 field
zwStatusMsg("Booking"; "Moving YTD to a Yesterday bucket")
READ WRITE:C146([Customers_Bookings:93])
READ ONLY:C145([Customers:16])
C_LONGINT:C283($fiscalYear)  //•3/27/00  mlb  fiscal year roll over
C_DATE:C307($fiscalStart; $fiscalEnd; $targetDate; $1)
If (Count parameters:C259=0)
	$targetDate:=Date:C102(Request:C163("Bookings for what date?"; String:C10(Current date:C33; Internal date short special:K1:4); "Ok"; "Use today"))
	If (ok=0)
		$targetDate:=Current date:C33
	End if 
	distributionList:="mel.bohince@arkay.com"
	
Else 
	$targetDate:=$1
End if 

$fiscalYear:=Num:C11(FiscalYear("year"; $targetDate))
$fiscalStart:=Date:C102(FiscalYear("start"; $targetDate))
$fiscalEnd:=Add to date:C393($fiscalStart; 1; 0; -1)

//*rebuild the year to date
zwStatusMsg("Booking"; "Getting >= "+String:C10($fiscalStart; System date short:K1:1)+" orders")


//ARRAY TEXT($aCustid;0)
//ARRAY LONGINT($aQty;0)
//ARRAY REAL($aPrice;0)
//ARRAY DATE($aDate;0)
//ARRAY REAL($aCost;0)
// Modified by: Mel Bohince (9/18/15) lay groundwork for SQL conversion
//Begin SQL
//SELECT CustID, Quantity, Price_Extended, DateOpened, Cost_Extended 
//from Customers_Order_Lines
//where DateOpened >= :$fiscalStart and
//      DateOpened <= :$fiscalEnd and
//      UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
//ORDER BY CustID

//into :$aCustid, :$aQty, :$aPrice, :$aDate, :$aCost
//End SQL


QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=$fiscalStart; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=$fiscalEnd; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"New"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Contract"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Open@"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected")
// Modified by: Mel Bohince (3/31/14) remove "rentals" exclusion
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]CustomerLine#"Rental";*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]CustID#"00614";*)  //LNK
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]CustID#"01585")  //THE OMNI GRoup

zwStatusMsg("Booking"; "Loading orders")
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustID:4; $aCustid; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]DateOpened:13; $aDate; [Customers_Order_Lines:41]Cost_Per_M:7; $aCost; [Customers_Order_Lines:41]SpecialBilling:37; $aSplBilling)
SORT ARRAY:C229($aCustid; $aQty; $aPrice; $aDate; $aCost; $aSplBilling; >)  //

//remove any cancellations that would zero out a customer

// Modified by: Mel Bohince (9/18/15) lay groundwork for SQL conversion
//ARRAY TEXT($custHasBooking;0)  //distinct list of id's from prior select
//For ($i;1;Size of array($aCustid))
//$hit:=Find in array($custHasBooking;$aCustid{$i})
//If ($hit<0)
//APPEND TO ARRAY($custHasBooking;$aCustid{$i})
//end if
//end for
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	DISTINCT VALUES:C339([Customers_Order_Lines:41]CustID:4; $custHasBooking)
	QUERY WITH ARRAY:C644([Customers_Bookings:93]Custid:1; $custHasBooking)
	QUERY SELECTION:C341([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	CREATE SET:C116([Customers_Bookings:93]; "Haves")
	ARRAY TEXT:C222($custHasBooking; 0)
	
	QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	CREATE SET:C116([Customers_Bookings:93]; "All_fiscal")
	
Else 
	
	
	DISTINCT VALUES:C339([Customers_Order_Lines:41]CustID:4; $custHasBooking)
	QUERY WITH ARRAY:C644([Customers_Bookings:93]Custid:1; $custHasBooking)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Haves")
	QUERY SELECTION:C341([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "All_fiscal")
	QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	ARRAY TEXT:C222($custHasBooking; 0)
	
End if   // END 4D Professional Services : January 2019 query selection

DIFFERENCE:C122("All_fiscal"; "Haves"; "HaveNots")
USE SET:C118("HaveNots")
util_DeleteSelection(->[Customers_Bookings:93])
CLEAR SET:C117("All_fiscal")
CLEAR SET:C117("Haves")
CLEAR SET:C117("HaveNots")

QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
SELECTION TO ARRAY:C260([Customers_Bookings:93]BookedYTD:3; $aBookings)
ARRAY TO SELECTION:C261($aBookings; [Customers_Bookings:93]BookedYesterday:4)  //move last bkgs to yesterday bucket
//*Reset the current   and change
For ($i; 1; Size of array:C274($aBookings))
	$aBookings{$i}:=0
End for 
zwStatusMsg("Booking"; "Clearing YTD")
ARRAY TO SELECTION:C261($aBookings; [Customers_Bookings:93]BookedYTD:3)  //clear current bucket
ARRAY TO SELECTION:C261($aBookings; [Customers_Bookings:93]BookedChange:5)  //clear current bucket


$numCust:=Size of array:C274($aCustid)
ARRAY REAL:C219($aBookings; 0)
ARRAY REAL:C219($aBookings; $numCust)
ARRAY REAL:C219($aExpectedCost; $numCust)
ARRAY LONGINT:C221($aQtyYTD; $numCust)
For ($i; 1; $numCust)
	$aBookings{$i}:=0
	$aExpectedCost{$i}:=0
	$aQtyYTD{$i}:=0
End for 
ARRAY TEXT:C222($aCustBuck; $numCust)
ARRAY REAL:C219($aPeriods; $numCust; 12)

ARRAY INTEGER:C220($aFiscalPeriod; 12)  //enumerate fiscal convertion
//$aFiscalPeriod{monthNumber}:=fiscalperiod
//on 1/1/07 fiscal month 1 changed from April to January

$aFiscalPeriod{1}:=1
$aFiscalPeriod{2}:=2
$aFiscalPeriod{3}:=3
$aFiscalPeriod{4}:=4
$aFiscalPeriod{5}:=5
$aFiscalPeriod{6}:=6
$aFiscalPeriod{7}:=7
$aFiscalPeriod{8}:=8
$aFiscalPeriod{9}:=9
$aFiscalPeriod{10}:=10
$aFiscalPeriod{11}:=11
$aFiscalPeriod{12}:=12

ARRAY POINTER:C280($aFiscalField; 12)  //enumerate fiscal convertion
$aFiscalField{1}:=->[Customers_Bookings:93]Period1:6
$aFiscalField{2}:=->[Customers_Bookings:93]Period2:7
$aFiscalField{3}:=->[Customers_Bookings:93]Period3:8
$aFiscalField{4}:=->[Customers_Bookings:93]Period4:9
$aFiscalField{5}:=->[Customers_Bookings:93]Period5:10
$aFiscalField{6}:=->[Customers_Bookings:93]Period6:11
$aFiscalField{7}:=->[Customers_Bookings:93]Period7:12
$aFiscalField{8}:=->[Customers_Bookings:93]Period8:13
$aFiscalField{9}:=->[Customers_Bookings:93]Period9:14
$aFiscalField{10}:=->[Customers_Bookings:93]Period10:15
$aFiscalField{11}:=->[Customers_Bookings:93]Period11:16
$aFiscalField{12}:=->[Customers_Bookings:93]Period12:17
//TRACE
zwStatusMsg("Booking"; "Tallying orders")
$cursor:=0
$lastCust:=""
For ($i; 1; $numCust)
	If (Not:C34($aSplBilling{$i}))
		$rev:=$aQty{$i}/1000*$aPrice{$i}
		$cost:=$aQty{$i}/1000*$aCost{$i}
	Else 
		$rev:=$aQty{$i}*$aPrice{$i}
		$cost:=$aQty{$i}*$aCost{$i}
	End if 
	$bucket:=$aFiscalPeriod{Month of:C24($aDate{$i})}
	If ($aCustid{$i}#$lastCust)
		$cursor:=$cursor+1
		$aCustBuck{$cursor}:=$aCustid{$i}
		$lastCust:=$aCustid{$i}
	End if 
	$aBookings{$cursor}:=$aBookings{$cursor}+$rev
	$aExpectedCost{$cursor}:=$aExpectedCost{$cursor}+$cost
	$aQtyYTD{$cursor}:=$aQtyYTD{$cursor}+$aQty{$i}
	$aPeriods{$cursor}{$bucket}:=$aPeriods{$cursor}{$bucket}+$rev
End for 



ARRAY REAL:C219($aBookings; $cursor)
ARRAY REAL:C219($aExpectedCost; $cursor)
ARRAY LONGINT:C221($aQtyYTD; $cursor)
ARRAY TEXT:C222($aCustBuck; $cursor)
ARRAY REAL:C219($aPeriods; $cursor; 12)
ARRAY REAL:C219($aChange; $cursor)
ARRAY REAL:C219($aPV; $cursor)
ARRAY REAL:C219($aContribution; $cursor)

uThermoInit($cursor; "Saving bookings")
For ($i; 1; $cursor)
	uThermoUpdate($i)
	QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]Custid:1=$aCustBuck{$i}; *)
	QUERY:C277([Customers_Bookings:93];  & ; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	
	If (Records in selection:C76([Customers_Bookings:93])=0)
		CREATE RECORD:C68([Customers_Bookings:93])
		[Customers_Bookings:93]Custid:1:=$aCustBuck{$i}
		[Customers_Bookings:93]FiscalYear:2:=$fiscalYear
		[Customers_Bookings:93]BookedYesterday:4:=0
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustBuck{$i})
		[Customers_Bookings:93]CustomerName:18:=[Customers:16]Name:2
	End if 
	[Customers_Bookings:93]BookedYTD:3:=Round:C94($aBookings{$i}; 0)
	[Customers_Bookings:93]CostYTD:19:=Round:C94($aExpectedCost{$i}; 0)
	[Customers_Bookings:93]PV_YTD:20:=Round:C94(fProfitVariable("PV"; [Customers_Bookings:93]CostYTD:19; [Customers_Bookings:93]BookedYTD:3; 0); 2)
	$aPV{$i}:=[Customers_Bookings:93]PV_YTD:20
	$aChange{$i}:=[Customers_Bookings:93]BookedYTD:3-[Customers_Bookings:93]BookedYesterday:4
	$aContribution{$i}:=$aBookings{$i}-$aExpectedCost{$i}
	[Customers_Bookings:93]BookedChange:5:=$aChange{$i}
	For ($month; 1; 12)
		$aFiscalField{$month}->:=Round:C94($aPeriods{$i}{$month}; 0)
	End for 
	[Customers_Bookings:93]QuantityYTD:23:=$aQtyYTD{$i}
	SAVE RECORD:C53([Customers_Bookings:93])
End for 

FLUSH CACHE:C297
uThermoClose

Cust_BookingsRpt($fiscalYear)

//Rank biggest change
$billings:=Batch_Billings($targetDate)
xText:=$cr+"BILLINGS for "+String:C10($targetDate; System date short:K1:1)+$cr
xText:=xText+$billings+$cr+$cr+"BOOKINGS:"+$cr
xText:=xText+"Biggest movers since last:"+$cr
SORT ARRAY:C229($aChange; $aCustBuck; $aBookings; $aExpectedCost; $aPV; $aContribution; <)
$dollarChg:=0
For ($i; 1; $cursor)
	If ($aChange{$i}#0)  //•3/30/00  mlb was > 0, missed cancellations
		$dollarChg:=$dollarChg+$aChange{$i}
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustBuck{$i})  //xText:=xText+String($aChange{$i};"$^^,^^^,^^0")+"   "+$aCustBuck{$i}+"   "+[CUSTOMER]Name+$cr
		xText:=xText+txt_Pad(String:C10($aChange{$i}; "$##,###,##0"); "_"; -1; 11)+"  - "+[Customers:16]Name:2+$cr  //+$aCustBuck{$i}
		
		//Else   `break
		//$i:=$i+$cursor
	End if 
End for 

If (Size of array:C274($aContribution)<20)
	$max:=Size of array:C274($aContribution)
Else 
	$max:=20
End if 
xText:=xText+$cr+$cr+"Top "+String:C10($max)+" by Contribution:"+$cr
xText:=xText+"    Contribution   PV       Booking    id   Customer"+$cr
SORT ARRAY:C229($aContribution; $aChange; $aCustBuck; $aBookings; $aExpectedCost; $aPV; <)

For ($i; 1; $max)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustBuck{$i})
	xText:=xText+txt_Pad(String:C10($i; "##"); "_"; -1; 2)+") "+txt_Pad(String:C10($aContribution{$i}; "$##,###,##0"); "_"; -1; 11)+"   "+txt_Pad(String:C10($aPV{$i}*100; "##0"); "_"; -1; 3)+"%   "+txt_Pad(String:C10($aBookings{$i}; "$##,###,##0"); "_"; -1; 11)+" - "+[Customers:16]Name:2+Char:C90(13)  //+"   "+$aCustBuck{$i}
	//xText:=xText+String($i;"^^")+") "+String($aContribution{$i};"$^^,^^^,^^0")+"   "+String($aPV{$i}*100;"^^0")+"   "+String($aBookings{$i};"$^^,^^^,^^0")+"   "+$aCustBuck{$i}+" - "+[CUSTOMER]Name+Char(13)
End for 

xText:=xText+Char:C90(13)+Char:C90(13)+"Top "+String:C10($max)+" by PV:"+$cr
xText:=xText+"    Contribution   PV       Booking      Customer"+$cr
SORT ARRAY:C229($aPV; $aContribution; $aChange; $aCustBuck; $aBookings; $aExpectedCost; <)

For ($i; 1; $max)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustBuck{$i})
	xText:=xText+txt_Pad(String:C10($i; "##"); "_"; -1; 2)+") "+txt_Pad(String:C10($aContribution{$i}; "$##,###,##0"); "_"; -1; 11)+"   "+txt_Pad(String:C10($aPV{$i}*100; "##0"); "_"; -1; 3)+"%   "+txt_Pad(String:C10($aBookings{$i}; "$##,###,##0"); "_"; -1; 11)+" - "+[Customers:16]Name:2+Char:C90(13)  //+"   "+$aCustBuck{$i}
	
	//xText:=xText+String($i;"^^")+") "+String($aContribution{$i};"$^^,^^^,^^0")+"   "+String($aPV{$i}*100;"^^0")+"   "+String($aBookings{$i};"$^^,^^^,^^0")+"   "+$aCustBuck{$i}+" - "+[CUSTOMER]Name+Char(13)
End for 

// Modified by: Mel Bohince (11/19/18) this is because someone forgot to book a big order, now that want it reported, status new and open means not booked.
ARRAY TEXT:C222($aOLstatus; 0)
ARRAY REAL:C219($aPriceExt; 0)
ARRAY REAL:C219($aCostExt; 0)
ARRAY LONGINT:C221($aQtyOrdered; 0)

Begin SQL
	SELECT Status, round(sum(Price_Extended),0), round(sum(Cost_Extended),0), sum(Quantity)
	from Customers_Order_Lines
	where DateOpened >= :$fiscalStart group by Status
	into :$aOLstatus, :$aPriceExt, :$aCostExt, :$aQtyOrdered
End SQL
//utl_LogIt("init")
xText:=xText+$cr+$cr+"ORDERLINE STATUS SUMMARY "+$cr
//$line:=txt_Pad ("STATUS";" ";1;10)+txt_Pad ("PRICE_EXD";" ";-1;13)+txt_Pad ("COST_EXD";" ";-1;13)+txt_Pad ("QUANTITY";" ";-1;13)
//utl_LogIt($line)
xText:=xText+txt_Pad("STATUS"; "_"; 1; 10)+txt_Pad("PRICE_EXD"; "_"; -1; 13)+txt_Pad("COST_EXD"; "_"; -1; 13)+txt_Pad("QUANTITY"; "_"; -1; 13)+$cr
For ($i; 1; Size of array:C274($aOLstatus))
	//$line:=txt_Pad ($aOLstatus{$i};" ";1;10)+txt_Pad (String(Round($aPriceExt{$i};0);"###,###,##0");" ";-1;13)+txt_Pad (String(Round($aCostExt{$i};0);"###,###,##0");" ";-1;13)+txt_Pad (String($aQtyOrdered{$i};"###,###,##0");" ";-1;13)
	//utl_LogIt($line)
	xText:=xText+txt_Pad($aOLstatus{$i}; "_"; 1; 12)+txt_Pad(String:C10(Round:C94($aPriceExt{$i}; 0); "###,###,##0"); "_"; -1; 13)+txt_Pad(String:C10(Round:C94($aCostExt{$i}; 0); "###,###,##0"); "_"; -1; 13)+txt_Pad(String:C10($aQtyOrdered{$i}; "###,###,##0"); "_"; -1; 13)+$cr
End for 
//utl_LogIt ("show")
//utl_LogIt("init")

xTitle:="Customer Bookings and Billings"
//rPrintText ("Bookings"+fYYMMDD (4D_Current_date)+"_"+Replace string
//«(String(4d_Current_time;◊HHMM);":";""))
//distributionList:="mel.bohince@arkay.com"
EMAIL_Sender(String:C10($dollarChg; "$##,###,##0")+"=Booking Chg"; ""; xText; distributionList; docName)
util_deleteDocument(docName)
xTitle:=""
xText:=""

BEEP:C151