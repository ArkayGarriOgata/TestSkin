//%attributes = {}
// -------
// Method: ORD_SpecialBillingUnBilled   ( ) ->
// By: Mel Bohince @ 07/22/16, 14:24:06
// Description
// report on unbilled special billings
// see also Invoice_NonShippingItem
// ----------------------------------------------------


ARRAY TEXT:C222($SalesRep; 0)
ARRAY TEXT:C222($CustID; 0)
ARRAY TEXT:C222($OrderLine; 0)
ARRAY TEXT:C222($ProductCode; 0)
ARRAY TEXT:C222($Status; 0)
ARRAY TEXT:C222($PONumber; 0)
ARRAY REAL:C219($Price_Extended; 0)
ARRAY DATE:C224($DateOpened; 0)
ARRAY TEXT:C222($custName; 0)

Begin SQL
	SELECT SalesRep, CustID, OrderLine, Status, ProductCode, PONumber, Price_Extended, DateOpened
	from Customers_Order_Lines
	where SpecialBilling = true and
	Qty_Open > 0 and
	UPPER(Status) not in ('CANCEL', 'CLOSED')
	into :$SalesRep, :$CustID, :$OrderLine, :$Status, :$ProductCode, :$PONumber, :$Price_Extended, :$DateOpened
End SQL

C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274($CustID)
ARRAY TEXT:C222($custName; $numElements)

For ($i; 1; $numElements)  //convert id to name
	$custName{$i}:=CUST_getName($CustID{$i}; "elc")
End for 

MULTI SORT ARRAY:C718($SalesRep; >; $custName; >; $OrderLine; >; $CustID; $Status; $ProductCode; $PONumber; $Price_Extended; $DateOpened)

C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)
C_LONGINT:C283($err)

$title:="Open special billing orderlines"
$text:="Rep\t"+"Customer\t"+"Orderline\t"+"Status\t"+"Product\t"+"PO\t"+"Price\t"+"Opened\r"
$docName:="UnbilledSplBill_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	
	For ($i; 1; $numElements)
		
		If (Length:C16($text)>25000)
			SEND PACKET:C103($docRef; $text)
			$text:=""
		End if   //len text
		
		$text:=$text+$SalesRep{$i}+"\t"+$custName{$i}+"\t"+$OrderLine{$i}+"\t"+$Status{$i}+"\t"+$ProductCode{$i}+"\t"+$PONumber{$i}+"\t"+String:C10($Price_Extended{$i})+"\t"+String:C10($DateOpened{$i}; Internal date short special:K1:4)+"\r"
		
	End for 
	
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	$distributionList:=Batch_GetDistributionList("deb"; "A/R")
	EMAIL_Sender($title; ""; "open attached with Excel"; $distributionList; $docName)
	util_deleteDocument($docName)
	
End if   //docref




