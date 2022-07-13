//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/03/11, 16:46:01
// ----------------------------------------------------
// Method: ELC_getContractPV
// Description
// return the contract pv
// ----------------------------------------------------

QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$1; *)
QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=$2)
If (Records in selection:C76([Customers_Brand_Lines:39])=1)
	$0:=[Customers_Brand_Lines:39]ContractPV:7
Else 
	$0:=0
End if 
REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)