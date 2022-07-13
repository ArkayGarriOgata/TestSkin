//%attributes = {}
// -------
// Method: Invoice_initInvOpenAccounts   ( ) ->
// By: Mel Bohince @ 07/12/17, 16:15:55
// Description
// send A/R doc as CSV to OpenAccounts
//Company SupplierAcct# Currency Document_type CustomerInv# Document_Date Year Period Doc_Total Cost_Code Expense_Code GL_Value
// ----------------------------------------------------
//
//
//
// no clue why I was to write this, see Invoice_sendInvToOpenAccounts
//
//
//
//

C_TEXT:C284($1; $crlf; $d; $co; $curr; $doctype; $costCode; $expCode)
$crlf:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
$d:=","  //comma delimininated
$co:=<>OpenAcctsCompany
$curr:="USD"
$doctype:="ZARINV"  //debit | credit?
$costCode:="11110"  //substring($aGL{$i};1;5)?
$expCode:="000"  //substring($aGL{$i};6)?

C_TEXT:C284($text; $docName)
C_TIME:C306($docRef)

$text:="AR Data take-on - Open Items,,,,,,,,,,,,,"+$crlf+",,,,,,,,,,,,,"+$crlf
$text:=$text+"Company,Supplier,Currency,Document,Customer,Document Date,Year,Period,Doc Total,Cost Code,Expense Code,GL Value,,"+$crlf
$text:=$text+",Account Number,,Type,Invoice Number ,,,,Including VAT,,,,,"+$crlf
$text:=$text+",,,,,,,,,,,,,"+$crlf

$docName:="ar_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	//*Load the data    scoop up approved invoices
	SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $aInvoNum; [Customers_Invoices:88]GL_CODE:23; $aGL; [Customers_Invoices:88]InvType:13; $aType; [Customers_Invoices:88]ExtendedPrice:19; $aAmount; [Customers_Invoices:88]CustomerID:6; $aCust; [Customers_Invoices:88]Status:22; $aStatus)
	SELECTION TO ARRAY:C260([Customers_Invoices:88]BillTo:10; $aBillto; [Customers_Invoices:88]Invoice_Date:7; $aDocDate; [Customers_Invoices:88]SalesPerson:8; $aSalesRep; [Customers_Invoices:88]CommissionPayable:21; $aCommission; [Customers_Invoices:88]CustomersPO:11; $aPO; [Customers_Invoices:88]Terms:18; $aTerms; [Customers_Invoices:88]InvComment:12; $aComments)
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aInvoNum)
	uThermoInit($numElements; "Exporting CSV")
	For ($i; 1; $numElements)
		$term:=Invoice_mapTerms($aTerms{$i})
		$text:=$text+$co+$d+Invoice_CustomerMapping($aBillto{$i})+$d+$curr+$d+$doctype+$d+String:C10($aInvoNum{$i})+$d+String:C10($aDocDate{$i}; Internal date short special:K1:4)+$d+String:C10(Year of:C25($aDocDate{$i}))+$d+String:C10(Month of:C24($aDocDate{$i}))+$d+String:C10($aAmount{$i})+$d+Substring:C12($aGL{$i}; 1; 5)+$d+Substring:C12($aGL{$i}; 6)+$d+String:C10($aAmount{$i})+$crlf
		$aStatus{$i}:="Posted"
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; $text)
	
	CLOSE DOCUMENT:C267($docRef)
	
	ARRAY TO SELECTION:C261($aStatus; [Customers_Invoices:88]Status:22)  //mark as sent
	
	//// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
	If (Count parameters:C259>0)
		$err:=util_Launch_External_App($docName)
	End if 
End if 