//%attributes = {"publishedWeb":true}
//Procedure: uInitFGSelarrs()  090295  MLB
//• 4/30/97 cs PI changes
//
C_LONGINT:C283($i)

$i:=Table:C252(->[Finished_Goods:26])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods:26]ProductCode:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods:26]CustID:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods:26]Line_Brand:15)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods:26]ProcessSpec:33)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods:26]OutLine_Num:4)  //•072895  MLB  UPR 201

$i:=Table:C252(->[Finished_Goods_Locations:35])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_Locations:35]Location:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_Locations:35]ProductCode:1)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_Locations:35]JobForm:19)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_Locations:35]CustID:16)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_Locations:35]Warehouse:36)

$i:=Table:C252(->[Finished_Goods_Transactions:33])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_Transactions:33]ProductCode:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_Transactions:33]XactionType:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_Transactions:33]XactionDate:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_Transactions:33]JobForm:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_Transactions:33]XactionNum:24)

$i:=Table:C252(->[Customers_Bills_of_Lading:49])
<>aSlctFF{$i}{1}:=Field:C253(->[Customers_Bills_of_Lading:49]ShippersNo:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Customers_Bills_of_Lading:49]CustID:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Customers_Bills_of_Lading:49]ShipTo:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Customers_Bills_of_Lading:49]BillTo:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Customers_Bills_of_Lading:49]ShipDate:20)

$i:=Table:C252(->[WMS_SerializedShippingLabels:96])
<>aSlctFF{$i}{1}:=Field:C253(->[WMS_SerializedShippingLabels:96]HumanReadable:5)
<>aSlctFF{$i}{2}:=Field:C253(->[WMS_SerializedShippingLabels:96]Jobit:3)
<>aSlctFF{$i}{3}:=Field:C253(->[WMS_SerializedShippingLabels:96]CPN:2)
<>aSlctFF{$i}{4}:=Field:C253(->[WMS_SerializedShippingLabels:96]ContainerType:13)
<>aSlctFF{$i}{5}:=Field:C253(->[WMS_SerializedShippingLabels:96]Arrived:16)

$i:=Table:C252(->[Finished_Goods_Specifications:98])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_Specifications:98]ControlNumber:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_Specifications:98]ProductCode:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_Specifications:98]ProjectNumber:4)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_Specifications:98]Priority:50)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_Specifications:98]FG_Key:1)

$i:=Table:C252(->[WMS_ItemMasters:123])
<>aSlctFF{$i}{1}:=Field:C253(->[WMS_ItemMasters:123]Skidid:1)
<>aSlctFF{$i}{2}:=Field:C253(->[WMS_ItemMasters:123]LOT:3)
<>aSlctFF{$i}{3}:=Field:C253(->[WMS_ItemMasters:123]SKU:2)
<>aSlctFF{$i}{4}:=Field:C253(->[WMS_ItemMasters:123]LOCATION:4)
<>aSlctFF{$i}{5}:=Field:C253(->[WMS_ItemMasters:123]DATE_MFG:8)

$i:=Table:C252(->[QA_Tests:134])
<>aSlctFF{$i}{1}:=Field:C253(->[QA_Tests:134]TestID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[QA_Tests:134]Name:2)
<>aSlctFF{$i}{3}:=Field:C253(->[QA_Tests:134]DisplayName:3)
<>aSlctFF{$i}{4}:=Field:C253(->[QA_Tests:134]SOP:7)
<>aSlctFF{$i}{5}:=Field:C253(->[QA_Tests:134]StatisticMethod:5)

$i:=Table:C252(->[QA_CustomerTestStandards:135])
<>aSlctFF{$i}{1}:=Field:C253(->[QA_CustomerTestStandards:135]CustID:2)
<>aSlctFF{$i}{2}:=Field:C253(->[QA_CustomerTestStandards:135]StdsGroup:3)
<>aSlctFF{$i}{3}:=Field:C253(->[QA_CustomerTestStandards:135]TestID:4)
<>aSlctFF{$i}{4}:=Field:C253(->[QA_CustomerTestStandards:135]LowerLimit:6)
<>aSlctFF{$i}{5}:=Field:C253(->[QA_CustomerTestStandards:135]UpperLimit:5)

$i:=Table:C252(->[WMS_aMs_Exports:153])
<>aSlctFF{$i}{1}:=Field:C253(->[WMS_aMs_Exports:153]id:1)
<>aSlctFF{$i}{2}:=Field:C253(->[WMS_aMs_Exports:153]Jobit:9)
<>aSlctFF{$i}{3}:=Field:C253(->[WMS_aMs_Exports:153]TransDate:4)
<>aSlctFF{$i}{4}:=Field:C253(->[WMS_aMs_Exports:153]BinId:10)
<>aSlctFF{$i}{5}:=Field:C253(->[WMS_aMs_Exports:153]ModWho:6)
//
$i:=Table:C252(->[Finished_Goods_DeliveryForcasts:145])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_DeliveryForcasts:145]ProductCode:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_DeliveryForcasts:145]asOf:9)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_DeliveryForcasts:145]Is_Obsolete:13)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_DeliveryForcasts:145]Custid:12)

$i:=Table:C252(->[Finished_Goods_Color_Submission:78])
<>aSlctFF{$i}{1}:=Field:C253(->[Finished_Goods_Color_Submission:78]Color:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Finished_Goods_Color_Submission:78]dateIn:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Finished_Goods_Color_Submission:78]dateOut:4)
<>aSlctFF{$i}{4}:=Field:C253(->[Finished_Goods_Color_Submission:78]Returned:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Finished_Goods_Color_Submission:78]Is_Ok:6)