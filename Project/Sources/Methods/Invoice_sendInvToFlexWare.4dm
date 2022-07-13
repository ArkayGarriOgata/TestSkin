//%attributes = {"publishedWeb":true}
//PM: Invoice_sendInvToFlexWare() -> 
//@author mlb - 8/1/01  14:22

C_TIME:C306($docDTL; $1)
$docDTL:=$1
C_TEXT:C284($detail)
C_LONGINT:C283($numInvoices; $i)
C_TEXT:C284($t)
C_TEXT:C284($cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)

//*Load the data      
SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $aInvoNum; [Customers_Invoices:88]GL_CODE:23; $aGL; [Customers_Invoices:88]InvType:13; $aType; [Customers_Invoices:88]ExtendedPrice:19; $aAmount; [Customers_Invoices:88]CustomerID:6; $aCust; [Customers_Invoices:88]Status:22; $aStatus)
SELECTION TO ARRAY:C260([Customers_Invoices:88]BillTo:10; $aBillto; [Customers_Invoices:88]Invoice_Date:7; $aDocDate; [Customers_Invoices:88]SalesPerson:8; $aSalesRep; [Customers_Invoices:88]CommissionPayable:21; $aCommission; [Customers_Invoices:88]CustomersPO:11; $aPO; [Customers_Invoices:88]Terms:18; $aTerms)

$numInvoices:=Size of array:C274($aInvoNum)
//Customer ID XXXXXXXX(8)
//Invoice Number 9999999(7)
//    (if this value is zero, or a dup will take the next invoice numb instead.)
//Customer Order Number XXXXXXXXX(15)
//Salesperson*XXX(3)
//Term Code*XX(2)
//Tax Code*XXX(3)
//Ship Date 999999(6)
//Invoice Date 999999(6)
//Tax Amount 9999999.99(10)
//Freight Amount 9999999.99(10)
//Materials Amount 9999999.99(10)
//Department XX(2)

//*   Send the Details
//$detail:="CustomerID"+$t+"InvoiceNumber"+$t+"CustOrderNumber"+$t+"SalesPerson"
//«+$t+"TermsCode"+$t+"TaxCode"+$t+"ShipDate"+$t+"InvoiceDate"+$t+"TaxAmt"+$t+
//«"FreightAmt"+$t+"MatlAmt"+$t+"Dept"+$cr
$detail:=""
For ($i; 1; $numInvoices)
	If (Length:C16($detail)>32000)
		SEND PACKET:C103($docDTL; $detail)
		$detail:=""
	End if 
	
	$amount:=String:C10(Round:C94($aAmount{$i}; 2); "########0.00")
	$date:=Replace string:C233(String:C10($aDocDate{$i}; Internal date short special:K1:4); "/"; "")
	$termCode:=INV_getTermsCode($aTerms{$i})
	$dept:=Substring:C12($aGL{$i}; 1; 1)
	$GLcode:=txt_Pad(Substring:C12($aGL{$i}; 3); "0"; -1; 12)
	
	$detail:=$detail+Invoice_CustomerMapping($aBillto{$i})+$t+String:C10($aInvoNum{$i})+$t+Substring:C12($aPO{$i}; 1; 15)+$t+Substring:C12($aSalesRep{$i}; 1; 3)
	$detail:=$detail+$t+$termCode+$t+"NO"+$t+$date+$t+$date+$t+"0.00"+$t+"0.00"+$t+$amount+$t+$dept+$t+$GLcode+$cr
	
	$aStatus{$i}:="Posted"
End for 

SEND PACKET:C103($docDTL; $detail)
$detail:=""
//CONFIRM("DEBUG, mark as sent";"no";"mark")
//If (ok=0)
ARRAY TO SELECTION:C261($aStatus; [Customers_Invoices:88]Status:22)  //*Mark as sent




//End if 