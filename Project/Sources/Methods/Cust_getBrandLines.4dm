//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/24/06, 11:48:44
// ----------------------------------------------------
// Method: Cust_getBrandLines(custid;->arraystring20)
// ----------------------------------------------------

C_TEXT:C284($1)
C_POINTER:C301($2)

$custid:=$1
$brandArray:=$2
ARRAY TEXT:C222($brandArray->; 0)

READ ONLY:C145([Customers_Brand_Lines:39])
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$custid)
SELECTION TO ARRAY:C260([Customers_Brand_Lines:39]LineNameOrBrand:2; $brandArray->)
SORT ARRAY:C229($brandArray->; >)
REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)