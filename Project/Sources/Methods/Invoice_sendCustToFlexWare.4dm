//%attributes = {"publishedWeb":true}
//PM: Invoice_sendCustToFlexWare() -> 
//@author mlb - 8/1/01  14:22
C_TIME:C306($docCust; $1)
If (Count parameters:C259>0)
	$docCust:=$1
Else 
	$docCust:=Create document:C266("test4")
End if 

C_TEXT:C284($custUpdate; $temp)
$custUpdate:=""
$temp:=""
C_LONGINT:C283($numAddresses; $i)
C_TEXT:C284($t)
C_TEXT:C284($cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
//Customer ID XXXXXXXX(8)
//Bill Name XXXXXXXXXXXXXXXXXXXXX(28)
//Bill Address XXXXXXXXXXXXXXXXXX(28)
//Bill Address 2 XXXXXXXXXXXXXXXX(28)
//Bill City XXXXXXXXXXXXXXXXXXXXX(28)
//Bill State XX(2)
//Bill Zip 999999999(9)
//Bill Country XXXXXXXXXXXXXXXXXX(28)
//Salesperson*XXX(3)
//Customer Type*XX(2)
//Tax Code*XXX(3)
//Term Code*XX(2)
//Contact XXXXXXXXXXXXXXXXXXXXXXX(28)
//Telephone 9999999999(10)
//FAX 9999999999(10)
//Dunning Type X(1)
//Resale Number XXXXXXXXXXXXXXXX(16)
//Credit Limit 9999999999.99(13)

//$custUpdate:="CustomerId"+$t+"BillName"+$t+"Address1"+$t+"Address2"+$t+"City"
//«+$t+"State"+$t+"Zip"+$t+"Country"+$t+"Salesperson"+$t+"CustomerType"+$t+
//«"TaxCode"+$t+"TermCode"+$t+"Contact"+$t+"Phone1"+$t+"Fax"+$t+"DunningType"+$t+
//«"ResaleNumber"+$t+"CreditLimit"+$cr
$custUpdate:=""
$numAddresses:=Records in selection:C76([Addresses:30])
FIRST RECORD:C50([Addresses:30])

READ ONLY:C145([Customers:16])
For ($i; 1; $numAddresses)
	If (Length:C16($custUpdate)>32000)
		SEND PACKET:C103($docCust; $custUpdate)
		$custUpdate:=""
	End if 
	
	$custUpdate:=$custUpdate+Invoice_CustomerMapping([Addresses:30]ID:1)+$t  //$aCustid{$i};
	$custUpdate:=$custUpdate+txt_ReplaceString(Substring:C12([Addresses:30]Name:2; 1; 28); 142; 101)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Address1:3; 1; 28)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Address2:4; 1; 28)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]City:6; 1; 28)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]State:7; 1; 2)+$t
	$custUpdate:=$custUpdate+Substring:C12(Replace string:C233([Addresses:30]Zip:8; "-"; ""); 1; 9)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Country:9; 1; 28)+$t
	QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
	RELATE ONE:C42([Customers_Addresses:31]CustID:1)
	
	$custUpdate:=$custUpdate+Substring:C12([Customers:16]SalesmanID:3; 1; 3)+$t
	$custUpdate:=$custUpdate+"XX"+$t  //[CUSTOMER]Type+$t
	$custUpdate:=$custUpdate+"NO"+$t  //TaxCode+$t
	$custUpdate:=$custUpdate+INV_getTermsCode([Customers:16]Std_Terms:13)+$t  //[CUSTOMER]TermCode+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]AttentionOf:14; 1; 28)+$t
	
	$temp:=Replace string:C233([Addresses:30]Phone:10; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	
	$temp:=Replace string:C233([Addresses:30]Fax:11; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	
	$custUpdate:=$custUpdate+"1"+$t  //DunningType+$t
	$custUpdate:=$custUpdate+""+$t  //Resale Number+$t
	$custUpdate:=$custUpdate+""+$cr  //Creditlimit+$cr
	
	[Addresses:30]UpdateDynamics:35:=0  //*mark as sent
	SAVE RECORD:C53([Addresses:30])
	NEXT RECORD:C51([Addresses:30])
End for 

SEND PACKET:C103($docCust; $custUpdate)
$custUpdate:=""

If (Count parameters:C259=0)
	CLOSE DOCUMENT:C267($docCust)
End if 
//