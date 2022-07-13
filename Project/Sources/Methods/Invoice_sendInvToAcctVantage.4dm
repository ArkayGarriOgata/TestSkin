//%attributes = {}
// Method: Invoice_sendInvToAcctVantage () -> 
// ----------------------------------------------------
// by: mel: 02/25/05, 16:18:43
// ----------------------------------------------------
// Description:
//  Invoice_sending adaptor
// Updates:
// • mel (4/22/05, 10:59:23) add po to export
// • mel (4/27/05, 12:23:56) other changes to rev AVExtDef20050421
//mel 10/25/05 "Invoice Import" removed from header
// Modified by Mel Bohince on 12/22/06 at 11:24:18 : make dept -000 for all
//mel 031909 separte rejects from other credits with If (Position("reject";$aComments{$inv}) and remove old commented code, 
//    see Invoice_sendInvToAcctVantage_ol for original
// ----------------------------------------------------
//based on PM: Invoice_sendInvToDynamics() -> 
//@author mlb - 8/2/01  11:27
// Modified by: Mel Bohince (3/10/17) send warning ot missing cogs-fifo
// Modified by: Mel Bohince (3/21/17) don't check credits for missing cogsfifo

C_TIME:C306($docDTL; $1)
If (Count parameters:C259>0)
	$docDTL:=$1
Else 
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7>!2017-01-01!)
	$suffix:=fYYMMDD(4D_Current_date; 4)+"."+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")
	$docDTL:=Create document:C266(<>DynamicsPath+<>DynamicsInvoiceHdrFilename+$suffix+".txt")  // add .txt Modified by: Mel Bohince (5/31/13)
End if 
C_TEXT:C284($header; $detail)
C_LONGINT:C283($numInvoices; $i; $numCodes; $version)
$version:=<>AcctVantageVersion
C_TEXT:C284($t)
C_TEXT:C284($cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284($glARcode)
$glARcode:="11110-000-000"

ARRAY TEXT:C222($aSalesCodes; 0)
ARRAY TEXT:C222($aSalesCodesByLocation; 0)
ARRAY REAL:C219($aSalesCodesDebit; 0)
ARRAY REAL:C219($aSalesCodesCredit; 0)

ALL RECORDS:C47([Finished_Goods_Classifications:45])
DISTINCT VALUES:C339([Finished_Goods_Classifications:45]AcctVantageGLcode:6; $aSalesCodes)
//append the location segment to the end of the g/l code
//see Invoice_getGLcode  =[Finished_Goods_Classifications]AcctVantageGLcode+"000"
$numCodes:=Size of array:C274($aSalesCodes)
ARRAY TEXT:C222($aSalesCodesByLocation; $numCodes)
For ($salesCode; 1; Size of array:C274($aSalesCodes))
	$aSalesCodesByLocation{$salesCode}:=$aSalesCodes{$salesCode}+"-000"
End for 
//create buckets for tally
ARRAY REAL:C219($aSalesCodesDebit; $numCodes)
ARRAY REAL:C219($aSalesCodesCredit; $numCodes)


//*Load the data    scoop up approved invoices
SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $aInvoNum; [Customers_Invoices:88]GL_CODE:23; $aGL; [Customers_Invoices:88]InvType:13; $aType; [Customers_Invoices:88]ExtendedPrice:19; $aAmount; [Customers_Invoices:88]CustomerID:6; $aCust; [Customers_Invoices:88]Status:22; $aStatus)
SELECTION TO ARRAY:C260([Customers_Invoices:88]BillTo:10; $aBillto; [Customers_Invoices:88]Invoice_Date:7; $aDocDate; [Customers_Invoices:88]SalesPerson:8; $aSalesRep; [Customers_Invoices:88]CommissionPayable:21; $aCommission; [Customers_Invoices:88]CustomersPO:11; $aPO; [Customers_Invoices:88]Terms:18; $aTerms; [Customers_Invoices:88]InvComment:12; $aComments)
//SELECTION TO ARRAY([Customers_Invoices]ProductCode;$aCPN;[Customers_Invoices]CoGS_FiFo;$aCOGS)  // Modified by: Mel Bohince (3/10/17) 

$numInvoices:=Size of array:C274($aInvoNum)

//summary for the Header section
$arTotalDebit:=0
$arTotalCredit:=0
$salesTotalDebit:=0
$salesTotalCredit:=0
$salesRejects:=0

//tally to each sales 
For ($i; 1; $numInvoices)  //get summary data for head section
	$amountDollars:=Round:C94($aAmount{$i}; 2)
	
	$salesCode:=Find in array:C230($aSalesCodesByLocation; $aGL{$i})  //now always 000, was 100 & 200
	If ($salesCode<0)
		$salesCode:=1
	End if 
	
	If ($amountDollars>0)  //positive amounts are invoices
		$arTotalDebit:=$arTotalDebit+$amountDollars
		$aSalesCodesCredit{$salesCode}:=$aSalesCodesCredit{$salesCode}+$amountDollars
		
	Else   //amount will be negative on credit memos
		$arTotalCredit:=$arTotalCredit+Abs:C99($amountDollars)
		
		If (Position:C15("reject"; $aComments{$i})>0)
			$salesRejects:=$salesRejects+Abs:C99($amountDollars)
			
		Else 
			$aSalesCodesDebit{$salesCode}:=$aSalesCodesDebit{$salesCode}+Abs:C99($amountDollars)
		End if 
	End if 
End for 

//*   Send the Headers and Details
$header:="AVExtDef20050421"+$cr  // • mel (4/27/05, 12:25:06) version 2
$header:=$header+"Date"+$t+"Memo"+$cr
$header:=$header+String:C10(4D_Current_date; System date short:K1:1)+$t+"    "+$cr  //Invoice Import
$header:=$header+"GL Account Code"+$t+"Debit"+$t+"Credit"+$cr

//accounts summary records debit & credit
If ($arTotalDebit>0)  //$glARcode:="11110-000-000"
	$header:=$header+$glARcode+$t+String:C10($arTotalDebit)+$t+"0"+$cr
End if 
If ($arTotalCredit>0)
	$header:=$header+$glARcode+$t+"0"+$t+String:C10($arTotalCredit)+$cr
End if 

//breakdown of sales codes involved
For ($i; 1; Size of array:C274($aSalesCodesByLocation))
	If ($aSalesCodesDebit{$i}>0)
		$header:=$header+$aSalesCodesByLocation{$i}+$t+String:C10($aSalesCodesDebit{$i})+$t+"0"+$cr
	End if 
	If ($aSalesCodesCredit{$i}>0)
		$header:=$header+$aSalesCodesByLocation{$i}+$t+"0"+$t+String:C10($aSalesCodesCredit{$i})+$cr
	End if 
End for 

If ($salesRejects>0)  //debit haup rejects
	$header:=$header+"41100-000-000"+$t+String:C10($salesRejects)+$t+"0"+$cr
End if 

//now get the details
$detail:=$header+"GL Account Code"+$t+"Client/Vendor/Part"+$t+"Client/Vendor Number"+$t+"AV ID"+$t+"Invoice/Lot Number"+$t  // • mel (4/27/05, 12:25:06)
$detail:=$detail+"Doc Date"+$t+"Due Date"+$t+"Debit"+$t+"Credit"+$t
$detail:=$detail+"Product Qty"+$t+"Warehouse"+$t+"Location"+$t+"Memo"+$cr  // • mel (4/22/05, 10:59:23) add po to export

For ($i; 1; $numInvoices)
	If (Length:C16($detail)>28000)
		SEND PACKET:C103($docDTL; $detail)
		$detail:=""
	End if 
	
	//references, and Document Date, DueDate
	$termCode:=Num:C11(INV_getTermsCode($aTerms{$i}))
	//$parentID:=Invoice_CustomerMapping ($aBillto{$i})
	$parentID:=""  //they say they don't want this
	$clientVendorNumber:=Invoice_CustomerMapping($aBillto{$i})  // • mel (4/27/05, 12:25:06)
	$subAccountParent:=[Addresses:30]Name:2
	$amount:=String:C10(Round:C94(Abs:C99($aAmount{$i}); 2); "########0.00")  // needs to be  ` Debit | Credit
	
	$detail:=$detail+$glARcode+$t+$subAccountParent+$t+$clientVendorNumber+$t+$parentID+$t+String:C10($aInvoNum{$i})+$t+String:C10($aDocDate{$i}; System date short:K1:1)+$t+String:C10(($aDocDate{$i}+$termCode); System date short:K1:1)+$t
	If ($aAmount{$i}>0)  //Debit        
		$detail:=$detail+$amount+$t+"0"+$t
	Else   //Credit
		$detail:=$detail+"0"+$t+$amount+$t
	End if 
	$detail:=$detail+""+$t+""+$t+""+$t+$aPO{$i}+$cr  // • mel (4/22/05, 11:01:26) added PO
	
	
	
	$aStatus{$i}:="Posted"
End for 

$detail:=$detail+"EOF"+$cr
SEND PACKET:C103($docDTL; $detail)
$detail:=""

ARRAY TO SELECTION:C261($aStatus; [Customers_Invoices:88]Status:22)  //*Mark as sent

If (Count parameters:C259=0)
	CLOSE DOCUMENT:C267($docDTL)
End if 


//moved to Invoice_ZeroFiFoCoGS and run in daily batch
//  // Modified by: Mel Bohince (3/10/17) 
//$numMissingCost:=0
//$subject:="Invoice Posted without FiFO Cost"
//$prehead:=$subject
//$tBody:=""
//$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
//$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
//$r:="</td></tr>"+Char(13)

//$tBody:=$tBody+$b+"Customer"+$t+"Invoice"+$t+"Dated"+$t+"ProductCode"+$t+"ExtendedPrice"+$r

//$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
//$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"

//For ($i;1;$numInvoices)
//If ($aCOGS{$i}=0) & ($aAmount{$i}>0)  // Modified by: Mel Bohince (3/21/17) don't check credits
//$numJIC:=0
//If (True)
//SET QUERY DESTINATION(Into variable;$numJIC)
//QUERY([Job_Forms_Items_Costs];[Job_Forms_Items_Costs]FG_Key=$aCust{$i}+":"+$aCPN{$i};*)
//QUERY([Job_Forms_Items_Costs]; & ;[Job_Forms_Items_Costs]RemainingQuantity>0)
//SET QUERY DESTINATION(Into current selection)
//Else 
//$numJIC:=qryJIC ("";$aCust{$i}+":"+$aCPN{$i})
//End if 

//If ($numJIC>0)
//$numMissingCost:=$numMissingCost+1
//$aCust{$i}:=CUST_getName ($aCust{$i};"elc")
//$tBody:=$tBody+$b+$aCust{$i}+$t+String($aInvoNum{$i})+$t+String($aDocDate{$i};Internal date short special)+$t+$aCPN{$i}+$t+String($aAmount{$i})+$r
//End if 
//End if 
//End for 

//If ($numMissingCost>0)
//$distributionList:=Batch_GetDistributionList ("";"A/R")
//Email_html_table ($subject;$prehead;$tBody;960;$distributionList)
//End if 
//  // Modified by: Mel Bohince (3/10/17) end of change
