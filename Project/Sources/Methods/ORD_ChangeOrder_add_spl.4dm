//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/19/13, 11:21:48
// ----------------------------------------------------
// Method: ORD_ChangeOrder_add_spl
// Description
// add special billing items to a change order
// ----------------------------------------------------

C_TEXT:C284($1; $product_code; $classification)
C_POINTER:C301($2; $item_number_ptr)

$product_code:=$1
$item_number_ptr:=$2
$item_number_ptr->:=$item_number_ptr->+1

MESSAGE:C88(<>sCR+"."+String:C10($item_number_ptr->)+$product_code)
// ******* Verified  - 4D PS - January  2019 ********

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
QUERY SELECTION:C341([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1=$item_number_ptr->)

// ******* Verified  - 4D PS - January 2019 (end) *********

$cost:=0
$price:=0

Case of 
	: ($product_code="Preparatory")
		$classification:="25"
		$cost:=[Estimates:17]z_Cost_TotalPrep:9
		$price:=[Estimates:17]z_Price_TotalPrep:54
		
	: ($product_code="Dupes")
		$classification:="27"
		$cost:=[Estimates_Differentials:38]Cost_Dups:19
		$price:=[Estimates_Differentials:38]Prc_Dups:24
		
	: ($product_code="Plates")
		$classification:="27"
		$cost:=[Estimates_Differentials:38]Cost_Plates:20
		$price:=[Estimates_Differentials:38]Prc_Plates:23
		
	: ($product_code="Dies")
		$classification:="27"
		$cost:=[Estimates_Differentials:38]Cost_Dies:21
		$price:=[Estimates_Differentials:38]Prc_Dies:22
		
	: ($product_code="Plates and Dies")
		$classification:="27"
		$cost:=[Estimates_Differentials:38]Cost_Dies:21+[Estimates_Differentials:38]Cost_Plates:20
		$price:=[Estimates_Differentials:38]Prc_Dies:22+[Estimates_Differentials:38]Prc_Plates:23
		
	: ($product_code="SpecialFreight")
		$classification:="9"
		
	: ($product_code="Culling")
		$classification:="90"
		
	Else 
		$classification:="25"
End case 

MESSAGE:C88(<>sCR+"."+String:C10($item_number_ptr->)+$product_code)
If (Records in selection:C76([Customers_Order_Changed_Items:176])=0)
	CREATE RECORD:C68([Customers_Order_Changed_Items:176])
	[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
	[Customers_Order_Changed_Items:176]ItemNo:1:=$item_number_ptr->
End if 
[Customers_Order_Changed_Items:176]NewProductCode:10:=$product_code
[Customers_Order_Changed_Items:176]NewQty:4:=1
[Customers_Order_Changed_Items:176]NewCost:14:=$cost
[Customers_Order_Changed_Items:176]NewPrice:5:=$price
[Customers_Order_Changed_Items:176]SpecialBilling:38:=True:C214
[Customers_Order_Changed_Items:176]NewClassificati:35:=$classification
[Customers_Order_Changed_Items:176]NewOrdType:15:="Preparatory"
SAVE RECORD:C53([Customers_Order_Changed_Items:176])