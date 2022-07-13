//%attributes = {"publishedWeb":true}
//Procedure: uInitRMSelarrs()  090295  MLB
//•031997  MLB  
//3/24/97 cs upr 235, commodity code ROLLIN
//• 7/2/97 cs changed PO seach fields
// Modified by: MelvinBohince (2/22/22) added commkey to allocations

C_LONGINT:C283($i)

<>aSlctFF{7}{2}:=Field:C253(->[Vendors:7]ID:1)  //•060195  MLB  UPR 1528
<>aSlctFF{7}{1}:=Field:C253(->[Vendors:7]Name:2)  //•060195  MLB  UPR 1528
<>aSlctFF{7}{3}:=Field:C253(->[Vendors:7]VendorType:3)
<>aSlctFF{7}{4}:=Field:C253(->[Vendors:7]HUB:35)
<>aSlctFF{7}{5}:=Field:C253(->[Vendors:7]Active:15)

<>aSlctFF{11}{1}:=Field:C253(->[Purchase_Orders:11]PONo:1)
<>aSlctFF{11}{2}:=Field:C253(->[Purchase_Orders:11]VendorName:42)  //•061595  MLB  UPR ?
<>aSlctFF{11}{3}:=Field:C253(->[Purchase_Orders:11]VendorID:2)
<>aSlctFF{11}{4}:=Field:C253(->[Purchase_Orders:11]ReqNo:5)  //• 7/2/97 cs changed from PODate -> Req No
<>aSlctFF{11}{5}:=Field:C253(->[Purchase_Orders:11]Status:15)

$i:=Table:C252(->[Purchase_Orders_Items:12])
<>aSlctFF{$i}{1}:=Field:C253(->[Purchase_Orders_Items:12]Raw_Matl_Code:15)
<>aSlctFF{$i}{2}:=Field:C253(->[Purchase_Orders_Items:12]VendPartNo:6)
<>aSlctFF{$i}{3}:=Field:C253(->[Purchase_Orders_Items:12]POItemKey:1)
<>aSlctFF{$i}{4}:=Field:C253(->[Purchase_Orders_Items:12]Commodity_Key:26)
<>aSlctFF{$i}{5}:=Field:C253(->[Purchase_Orders_Items:12]Qty_Open:27)

$i:=Table:C252(->[Purchase_Orders_Releases:79])
<>aSlctFF{$i}{1}:=Field:C253(->[Purchase_Orders_Releases:79]POitemKey:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Purchase_Orders_Releases:79]RM_Code:7)
<>aSlctFF{$i}{3}:=Field:C253(->[Purchase_Orders_Releases:79]Schd_Date:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Purchase_Orders_Releases:79]Actual_Date:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Purchase_Orders_Releases:79]RelNumber:4)


<>aSlctFF{14}{1}:=Field:C253(->[Purchase_Orders_Clauses:14]ID:1)
<>aSlctFF{14}{2}:=Field:C253(->[Purchase_Orders_Clauses:14]Title:2)
<>aSlctFF{14}{3}:=0  //• 7/2/97 cs removed repeats
<>aSlctFF{14}{4}:=0
<>aSlctFF{14}{5}:=0

$i:=Table:C252(->[Raw_Materials:21])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Materials:21]Raw_Matl_Code:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Materials:21]Commodity_Key:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Materials:21]DepartmentID:28)  //3/24/97 cs upr 235, commodity code ROLLIN
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Materials:21]Description:4)  // Modified by: Mark Zinke (8/9/13) Was [Raw_Materials]Obsolete_ExpCode
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Materials:21]Status:25)

$i:=Table:C252(->[Raw_Materials_Allocations:58])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Materials_Allocations:58]commdityKey:13)  // Modified by: MelvinBohince (2/22/22) added
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Materials_Allocations:58]JobForm:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Materials_Allocations:58]Date_Allocated:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Materials_Allocations:58]ModWho:9)

$i:=Table:C252(->[Raw_Materials_Locations:25])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Materials_Locations:25]Raw_Matl_Code:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Materials_Locations:25]POItemKey:19)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Materials_Locations:25]Commodity_Key:12)
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Materials_Locations:25]Warehouse:29)
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Materials_Locations:25]Location:2)

$i:=Table:C252(->[Raw_Materials_Groups:22])
<>aSlctFF{$i}{1}:=Field:C253(->[Raw_Materials_Groups:22]Commodity_Key:3)
<>aSlctFF{$i}{2}:=Field:C253(->[Raw_Materials_Groups:22]Commodity_Code:1)
<>aSlctFF{$i}{3}:=Field:C253(->[Raw_Materials_Groups:22]SubGroup:10)
<>aSlctFF{$i}{4}:=Field:C253(->[Raw_Materials_Groups:22]UseForEst:12)
<>aSlctFF{$i}{5}:=Field:C253(->[Raw_Materials_Groups:22]ReceiptType:13)

$i:=Table:C252(->[Job_PlatingMaterialUsage:175])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_PlatingMaterialUsage:175]DateEntered:4)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_PlatingMaterialUsage:175]Operator:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_PlatingMaterialUsage:175]JobSequence:2)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_PlatingMaterialUsage:175]Shift:5)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_PlatingMaterialUsage:175]CostCenter:17)
