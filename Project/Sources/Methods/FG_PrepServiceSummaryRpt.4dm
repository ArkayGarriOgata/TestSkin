//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceSummaryRpt() -> 

//@author mlb - 12/4/02  16:15

//• mlb - 1/15/03  09:40 only show bookings that have been billed

MESSAGES OFF:C175
C_DATE:C307(dDateBegin; $2; dDateEnd; $3)
C_LONGINT:C283($i; $j)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284($custid)
C_TEXT:C284(docName; xTitle; xText; distributionList; $1)
distributionList:=$1

C_TIME:C306($docRef)
C_REAL:C285($qtyQuote; $qtyAct; $priceQuote; $priceActual; $variance)
READ ONLY:C145([Finished_Goods_Specifications:98])
READ ONLY:C145([Prep_Charges:103])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Invoices:88])
READ ONLY:C145([Customers_Order_Lines:41])

//*get prep done this week (past 7 days)

If (Count parameters:C259=1)
	dDateEnd:=4D_Current_date
	dDateBegin:=dDateEnd-7
Else 
	dDateBegin:=$2
	dDateEnd:=$3
End if 
xTitle:="Prep Service Summary Rpt for period beginning "+String:C10(dDateBegin; System date short:K1:1)+" and ending on "+String:C10(dDateEnd; System date short:K1:1)
docName:="PrepServiceSummary"+fYYMMDD(4D_Current_date)
$docRef:=util_putFileName(->docName)

xText:="Attached in document: "+docName+$cr+$cr

//*Find which customers have had prepDone, prepBilled, or prepOrdered within date 

//     range

zwStatusMsg("QUERY"; "[FG_Specification]")

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin)
	$numSpecs:=Records in selection:C76([Finished_Goods_Specifications:98])
	CREATE SET:C116([Finished_Goods_Specifications:98]; "fgs")
	
Else 
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin)
	$numSpecs:=Records in selection:C76([Finished_Goods_Specifications:98])
	
End if   // END 4D Professional Services : January 2019 query selection

ARRAY TEXT:C222($aDesc; 0)
ALL RECORDS:C47([Prep_CatalogItems:102])
SELECTION TO ARRAY:C260([Prep_CatalogItems:102]Description:2; $aDesc)
For ($i; 1; Size of array:C274($aDesc))
	$aDesc{$i}:=Substring:C12($aDesc{$i}; 1; 20)
End for 
//INSERT ELEMENT($aDesc;1;1)

//$aDesc{1}:="Preparatory"


zwStatusMsg("QUERY"; "[Invoices]")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7<=dDateEnd; *)
	QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>=dDateBegin)
	QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]ProductCode:14="Preparatory"; *)
	For ($i; 1; Size of array:C274($aDesc))
		QUERY SELECTION:C341([Customers_Invoices:88];  | ; [Customers_Invoices:88]ProductCode:14=$aDesc{$i}; *)
	End for 
	QUERY SELECTION:C341([Customers_Invoices:88])
	
	
Else 
	
	ARRAY TEXT:C222($aDesc1; 0)
	
	COPY ARRAY:C226($aDesc; $aDesc1)
	APPEND TO ARRAY:C911($aDesc1; "Preparatory")
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7<=dDateEnd; *)
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7>=dDateBegin)
	QUERY SELECTION WITH ARRAY:C1050([Customers_Invoices:88]ProductCode:14; $aDesc1)
	
End if   // END 4D Professional Services : January 2019 query selection
$numInvoice:=Records in selection:C76([Customers_Invoices:88])
CREATE SET:C116([Customers_Invoices:88]; "inv")

//• mlb - 1/15/03  09:40 only show bookings that have been billed

zwStatusMsg("QUERY"; "[OrderLines]")
RELATE ONE SELECTION:C349([Customers_Invoices:88]; [Customers_Order_Lines:41])
//QUERY([OrderLines];[OrderLines]DateOpened<=dDateEnd;*)

//QUERY([OrderLines]; & ;[OrderLines]DateOpened>=dDateBegin;*)

//QUERY([OrderLines];[OrderLines]SpecialBilling=True)

//QUERY SELECTION([OrderLines];[OrderLines]ProductCode="Preparatory";*)

//For ($i;1;Size of array($aDesc))

//QUERY SELECTION([OrderLines]; | ;[OrderLines]ProductCode=$aDesc{$i};*)

//End for 

//QUERY SELECTION([OrderLines])

$numOrderlines:=Records in selection:C76([Customers_Order_Lines:41])
CREATE SET:C116([Customers_Order_Lines:41]; "ord")

zwStatusMsg("QUERY"; "Consolidating Customers")
ARRAY TEXT:C222(aCustId; ($numSpecs+$numOrderlines+$numInvoice))
$cursor:=0
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustID:4; $aCust1)
SELECTION TO ARRAY:C260([Customers_Invoices:88]CustomerID:6; $aCust2)
SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $aCust3)
For ($i; 1; Size of array:C274($aCust1))
	$hit:=Find in array:C230(aCustId; $aCust1{$i})
	If ($hit=-1)
		$cursor:=$cursor+1
		aCustId{$cursor}:=$aCust1{$i}
	End if 
End for 

For ($i; 1; Size of array:C274($aCust2))
	$hit:=Find in array:C230(aCustId; $aCust2{$i})
	If ($hit=-1)
		$cursor:=$cursor+1
		aCustId{$cursor}:=$aCust2{$i}
	End if 
End for 

For ($i; 1; Size of array:C274($aCust3))
	$custid:=Substring:C12($aCust3{$i}; 1; 5)
	$hit:=Find in array:C230(aCustId; $custid)
	If ($hit=-1)
		$cursor:=$cursor+1
		aCustId{$cursor}:=$custid
	End if 
End for 

zwStatusMsg("QUERY"; "[CUSTOMER]")
ARRAY TEXT:C222(aCustId; $cursor)
QUERY WITH ARRAY:C644([Customers:16]ID:1; aCustId)
$numRecs:=Records in selection:C76([Customers:16])

ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)

//*Tally dollars of interest by customer.

$bookedTT:=0
$billedTT:=0
$quotedTT:=0
$revQuotedTT:=0
$incurredTT:=0

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Customers:16])
xText:=xText+"Customer"+$t+"Quoted"+$t+"Revised"+$t+"Incurred"+$t+"Booked"+$t+"Billed"+$cr

uThermoInit($numRecs; "Summarizing Data")
For ($i; 1; $numRecs)
	$booked:=0
	$billed:=0
	$quoted:=0
	$revQuoted:=0
	$incurred:=0
	
	If ($break)
		$i:=$i+$numRecs
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		USE SET:C118("fgs")
		USE SET:C118("ord")
		USE SET:C118("inv")
		QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=([Customers:16]ID:1+"@"))
		
	Else 
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd; *)
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=([Customers:16]ID:1+"@"))
		
		USE SET:C118("ord")
		USE SET:C118("inv")
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	RELATE MANY SELECTION:C340([Prep_Charges:103]ControlNumber:1)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		For ($j; 1; Records in selection:C76([Prep_Charges:103]))
			$quoted:=$quoted+[Prep_Charges:103]PriceQuoted:6
			$revQuoted:=$revQuoted+[Prep_Charges:103]PriceRevised:11
			$incurred:=$incurred+[Prep_Charges:103]PriceActual:5
			NEXT RECORD:C51([Prep_Charges:103])
		End for 
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Customers:16]ID:1)
		For ($j; 1; Records in selection:C76([Customers_Order_Lines:41]))
			$booked:=$booked+([Customers_Order_Lines:41]Quantity:6*[Customers_Order_Lines:41]Price_Per_M:8)
			NEXT RECORD:C51([Customers_Order_Lines:41])
		End for 
		
		QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6=[Customers:16]ID:1)
		For ($j; 1; Records in selection:C76([Customers_Invoices:88]))
			$billed:=$billed+[Customers_Invoices:88]ExtendedPrice:19
			NEXT RECORD:C51([Customers_Invoices:88])
		End for 
		
	Else 
		
		$quoted:=$quoted+Sum:C1([Prep_Charges:103]PriceQuoted:6)
		$revQuoted:=$revQuoted+Sum:C1([Prep_Charges:103]PriceRevised:11)
		$incurred:=$incurred+Sum:C1([Prep_Charges:103]PriceActual:5)
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Customers:16]ID:1)
		
		ARRAY LONGINT:C221($_Quantity; 0)
		ARRAY REAL:C219($_Price_Per_M; 0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $_Quantity; \
			[Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M)
		
		For ($j; 1; Records in selection:C76([Customers_Order_Lines:41]))
			$booked:=$booked+($_Quantity{$j}*$_Price_Per_M{$j})
		End for 
		
		QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6=[Customers:16]ID:1)
		
		$billed:=$billed+Sum:C1([Customers_Invoices:88]ExtendedPrice:19)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	xText:=xText+[Customers:16]Name:2+$t+String:C10($quoted)+$t+String:C10($revQuoted)+$t+String:C10($incurred)+$t+String:C10($booked)+$t+String:C10($billed)+$cr
	$bookedTT:=$bookedTT+$booked
	$billedTT:=$billedTT+$billed
	$quotedTT:=$quotedTT+$quoted
	$revQuotedTT:=$revQuotedTT+$revQuoted
	$incurredTT:=$incurredTT+$incurred
	NEXT RECORD:C51([Customers:16])
	uThermoUpdate($i)
End for 
xText:=xText+"------"+$t+"------"+$t+"------"+$t+"------"+$t+"------"+$t+"------"+$cr
xText:=xText+"TOTALS:"+$t+String:C10($quotedTT)+$t+String:C10($revQuotedTT)+$t+String:C10($incurredTT)+$t+String:C10($bookedTT)+$t+String:C10($billedTT)+$cr

uThermoClose
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
	
	CLEAR SET:C117("fgs")
	
	
Else 
	
	
	
End if   // END 4D Professional Services : January 2019 query selection
CLEAR SET:C117("ord")
CLEAR SET:C117("inv")
REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
REDUCE SELECTION:C351([Prep_Charges:103]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)

SEND PACKET:C103($docRef; xTitle)
SEND PACKET:C103($docRef; $cr)
SEND PACKET:C103($docRef; xText)
CLOSE DOCUMENT:C267($docRef)
EMAIL_Sender(xTitle; ""; xText; distributionList; docName)
util_deleteDocument(docName)

//

