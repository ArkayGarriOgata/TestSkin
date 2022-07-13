//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/03/11, 14:12:15
// ----------------------------------------------------
// Method: FG_is_Contract_Item
// Description
// NOT: determine if product code has a contract price
//INSTEAD: see if line has a contractPV
// ----------------------------------------------------

C_BOOLEAN:C305($0; $is_contract)
C_TEXT:C284($1)  //custid
C_TEXT:C284($2)  //line

$is_contract:=False:C215
READ ONLY:C145([Customers_Brand_Lines:39])
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$1; *)
QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=$2)
If (Records in selection:C76([Customers_Brand_Lines:39])=1)
	If ([Customers_Brand_Lines:39]ContractPV:7>0)
		$is_contract:=True:C214
	End if 
	REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)
End if 
$0:=$is_contract