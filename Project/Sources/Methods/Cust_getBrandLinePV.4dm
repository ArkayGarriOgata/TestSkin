//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/28/11, 09:34:22
// ----------------------------------------------------
// Method: Cust_getBrandLinePV
// Description
// return the fixed PV for contract orders

//tests for quick report:
//fProfitVariable ("cost";0;[Finished_Goods]RKContractPrice;Cust_getBrandLinePV ([Finished_Goods]Line_Brand;[Finished_Goods]CustID))
//fProfitVariable ("pv";C2;[Finished_Goods]RKContractPrice;0)
//fProfitVariable ("price";C2;0;C3)

C_TEXT:C284($1)  //brand/line
C_TEXT:C284($2)  //cust id
C_REAL:C285($0)
C_BOOLEAN:C305($queried)

If ([Customers_Brand_Lines:39]LineNameOrBrand:2#$1)
	$queried:=True:C214
	QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]LineNameOrBrand:2=$1; *)
	QUERY:C277([Customers_Brand_Lines:39];  & [Customers_Brand_Lines:39]CustID:1=$2)
Else 
	$queried:=False:C215
End if 

If (Records in selection:C76([Customers_Brand_Lines:39])=1)
	$0:=[Customers_Brand_Lines:39]ContractPV:7
Else 
	$0:=0
End if 

If ($queried)
	REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)
End if 