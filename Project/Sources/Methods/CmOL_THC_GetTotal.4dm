//%attributes = {}
//Method:  CmOL_THC_GetTotal (tCustomerID;tProductCode;poTotal)
//Description:  This method gets totals

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tCustomerID; $2; $tProductCode)
	C_POINTER:C301($3; $poCustomersOrderLines)
	
	$tCustomerID:=$1
	$tProductCode:=$2
	$poCustomersOrderLines:=$3
	
End if   //Done Initialize

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$tCustomerID; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=$tProductCode)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$tCustomerID; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$tProductCode)

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$tCustomerID; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=$tProductCode)

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15=$tCustomerID; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=$tProductCode)

sAskMeTotals

$poCustomersOrderLines->rTotalOrderLine:=iitotal1
$poCustomersOrderLines->rTotalOrderLineOverRun:=i3
$poCustomersOrderLines->rTotalRelease:=iitotal2
$poCustomersOrderLines->rTotalInventory:=iitotal3
$poCustomersOrderLines->rTotalProduction:=iitotal4
