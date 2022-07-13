//%attributes = {}
// -------
// Method: Invoice_sendInvToOpenAccounts   ( ) ->
// By: Mel Bohince @ 10/31/17, 16:15:55
// Description
// send A/R doc as CSV to OpenAccounts
//Company SupplierAcct# Currency Document_type CustomerInv# Document_Date Year Period Doc_Total Cost_Code Expense_Code GL_Value
// ----------------------------------------------------
//If (True)
//QUERY([Customers_Invoices];[Customers_Invoices]Invoice_Date=!09/20/2017!)  // Modified by: Mel Bohince (11/1/17) 
//End if 
// Modified by: Mel Bohince (11/9/17) Differentiate between debit and credit doctypes
// Modified by: Mel Bohince (12/1/17) use exp code on invoice
// Modified by: Mel Bohince (2/8/18) truncate the amount to 2 decimals
// Modified by: Mel Bohince (6/20/18) add CPN to export
// Modified by: MelvinBohince (5/12/22) sort by invoice#

C_TEXT:C284($1; $crlf; $d; $co; $curr; $doctype; $costCode; $expCode; $0; $debitDoc; $creditDoc)
$crlf:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
$d:=","  //comma delimininated
$co:=<>OpenAcctsCompany
$curr:="USD"
$doctype:=""  //debit | credit?
$debitDoc:="ARINOA"  // Modified by: Mel Bohince (11/9/17) 
$creditDoc:="ARCNOA"  // Modified by: Mel Bohince (11/9/17) 
$costCode:="10-10-000"  //substring($aGL{$i};1;5)? see also Invoice_getGLcode
$expCode:="40100-"  //substring($aGL{$i};1;6) // Modified by: Mel Bohince (12/1/17) 

C_TEXT:C284($text; $docName)
C_TIME:C306($docRef)

$text:=""
$text:=$text+"Rectype,Company,Doctype,Account Number,Reference,Item,Originref,Date,Currency,Document Value,VAT Value,Year,Period,Vat Code 1,Goods Value,VAT Amount"+$crlf
$text:=$text+",,Cost Code,Expense Code,Null,GL Value,VAT Code,Description,,,,,,,"+$crlf
$text:=$text+",,,,,,,,,,,,,,"+$crlf

$docName:="ar_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	//*Load the data    scoop up approved invoices
	ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)  // Modified by: MelvinBohince (5/12/22) sort by invoice#, beware of array to selection later
	SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $aInvoNum; [Customers_Invoices:88]GL_CODE:23; $aGL; [Customers_Invoices:88]InvType:13; $aType; [Customers_Invoices:88]ExtendedPrice:19; $aAmount; [Customers_Invoices:88]CustomerID:6; $aCust; [Customers_Invoices:88]Status:22; $aStatus; [Customers_Invoices:88]ProductCode:14; $aCPN)
	SELECTION TO ARRAY:C260([Customers_Invoices:88]BillTo:10; $aBillto; [Customers_Invoices:88]Invoice_Date:7; $aDocDate; [Customers_Invoices:88]SalesPerson:8; $aSalesRep; [Customers_Invoices:88]CommissionPayable:21; $aCommission; [Customers_Invoices:88]CustomersPO:11; $aPO; [Customers_Invoices:88]Terms:18; $aTerms; [Customers_Invoices:88]InvComment:12; $aComments)
	//SORT ARRAY($aInvoNum;$aGL;$aType;$aAmount;$aCust;$aStatus;$aCPN;$aBillto;$aDocDate;$aSalesRep;$aCommission;$aPO;$aTerms;$aComments;>)// Modified by: MelvinBohince (5/12/22) sort by invoice#
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aInvoNum)
	uThermoInit($numElements; "Exporting CSV")
	For ($i; 1; $numElements)
		$term:=Invoice_mapTerms($aTerms{$i})
		$expCode:=Substring:C12($aGL{$i}; 1; 6)  // Modified by: Mel Bohince (12/1/17) 
		
		If ($aAmount{$i}>0)  // Modified by: Mel Bohince (11/9/17) 
			$doctype:=$debitDoc
		Else 
			$doctype:=$creditDoc
		End if 
		$amount:=Trunc:C95($aAmount{$i}; 2)  // Modified by: Mel Bohince (2/8/18) 
		$text:=$text+"H"+$d+$co+$d+$doctype+$d+Invoice_CustomerMapping($aBillto{$i})+$d+String:C10($aInvoNum{$i})+$d+$aCPN{$i}+$d+$aPO{$i}+$d+String:C10($aDocDate{$i}; Internal date short special:K1:4)+$d+"USD"+$d+String:C10($amount)+$d+"0"+$d+String:C10(Year of:C25($aDocDate{$i}))+$d+String:C10(Month of:C24($aDocDate{$i}))+$d+"E"+$d+String:C10($aAmount{$i})+$d+"0"+$crlf
		$text:=$text+"D"+$d+$co+$d+$costCode+$d+$expCode+$d+""+$d+String:C10($amount)+$d+"E"+$d+"Sales"+(8*$d)+$crlf
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
	
	$0:=$docName
End if 