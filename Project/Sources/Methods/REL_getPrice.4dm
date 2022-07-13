//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/30/15, 10:36:37
// ----------------------------------------------------
// Method: REL_getPrice("Extended")
// Description
// to be called from a release quick report
//
// ----------------------------------------------------
// Modified by: Mel Bohince (8/29/16) try last order, last price can be wildly wrong

C_REAL:C285($0; $pricePerM)
C_TEXT:C284($1)

$pricePerM:=0
//First, if linked to an orderline, use that
If (Length:C16([Customers_ReleaseSchedules:46]OrderLine:4)=8)
	$pricePerM:=ORD_getPricePerM([Customers_ReleaseSchedules:46]OrderLine:4)
End if 

//If still 0
If ($pricePerM=0)  //see if there is a contract price
	$numFG:=qryFinishedGood("#KEY"; ([Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11))
	$pricePerM:=[Finished_Goods:26]RKContractPrice:49
End if 

If ($pricePerM=0)  // Modified by: Mel Bohince (8/29/16) try last order
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Customers_ReleaseSchedules:46]ProductCode:11; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Price_Per_M:8>0)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateOpened:13; $aOpened; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		SORT ARRAY:C229($aOpened; $aPrice; <)
		$pricePerM:=$aPrice{1}
	End if 
End if 

If ($pricePerM=0)  //try last price
	$pricePerM:=FG_getLastPrice(([Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11); "tryFGrec")
End if 

If ((Count parameters:C259=0) | ($pricePerM=0))
	$0:=$pricePerM
Else 
	$0:=$pricePerM*[Customers_ReleaseSchedules:46]Sched_Qty:6/1000
End if 