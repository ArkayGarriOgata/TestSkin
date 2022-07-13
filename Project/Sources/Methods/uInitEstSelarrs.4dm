//%attributes = {"publishedWeb":true}
//Procedure: uInitEstSelarrs()  090295  MLB
//


$i:=Table:C252(->[Process_Specs:18])
<>aSlctFF{$i}{1}:=Field:C253(->[Process_Specs:18]ID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Process_Specs:18]Cust_ID:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Process_Specs:18]Description:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Process_Specs:18]Stock:7)
<>aSlctFF{$i}{5}:=Field:C253(->[Process_Specs:18]ModWho:103)

$i:=Table:C252(->[Estimates_Carton_Specs:19])
<>aSlctFF{$i}{1}:=Field:C253(->[Estimates_Carton_Specs:19]Estimate_No:2)
<>aSlctFF{$i}{2}:=Field:C253(->[Estimates_Carton_Specs:19]ProductCode:5)
<>aSlctFF{$i}{3}:=Field:C253(->[Estimates_Carton_Specs:19]ProcessSpec:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Estimates_Carton_Specs:19]CustID:6)
<>aSlctFF{$i}{5}:=Field:C253(->[Estimates_Carton_Specs:19]OutLineNumber:15)  //•072895  MLB  UPR 201

$i:=Table:C252(->[Estimates_Machines:20])
<>aSlctFF{$i}{1}:=Field:C253(->[Estimates_Machines:20]DiffFormID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Estimates_Machines:20]CostCtrID:4)
<>aSlctFF{$i}{3}:=Field:C253(->[Estimates_Machines:20]Sequence:5)
<>aSlctFF{$i}{4}:=Field:C253(->[Estimates_Machines:20]EstimateNo:14)
<>aSlctFF{$i}{5}:=Field:C253(->[Estimates_Machines:20]EstimateType:16)

$i:=Table:C252(->[Process_Specs_Machines:28])
<>aSlctFF{$i}{1}:=Field:C253(->[Process_Specs_Machines:28]ProcessSpec:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Process_Specs_Machines:28]CustID:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Process_Specs_Machines:28]Seq_Num:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Process_Specs_Machines:28]CostCenterID:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Process_Specs_Machines:28]CostCtrName:5)
//MESSAGE("c")
$i:=Table:C252(->[Estimates_Materials:29])
<>aSlctFF{$i}{1}:=Field:C253(->[Estimates_Materials:29]DiffFormID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Estimates_Materials:29]Commodity_Key:6)
<>aSlctFF{$i}{4}:=Field:C253(->[Estimates_Materials:29]Raw_Matl_Code:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Estimates_Materials:29]Sequence:12)
//◊aSlctFF{$i}{5}:=◊NIL_PTR

$i:=Table:C252(->[Estimates:17])
<>aSlctFF{$i}{1}:=Field:C253(->[Estimates:17]EstimateNo:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Estimates:17]JobNo:50)
<>aSlctFF{$i}{4}:=Field:C253(->[Estimates:17]OrderNo:51)
<>aSlctFF{$i}{3}:=Field:C253(->[Estimates:17]CustomerName:47)
<>aSlctFF{$i}{5}:=Field:C253(->[Estimates:17]Status:30)

$i:=Table:C252(->[Cost_Centers:27])
<>aSlctFF{$i}{1}:=Field:C253(->[Cost_Centers:27]ID:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Cost_Centers:27]Description:3)
<>aSlctFF{$i}{3}:=Field:C253(->[Cost_Centers:27]EffectivityDate:13)
<>aSlctFF{$i}{4}:=Field:C253(->[Cost_Centers:27]PrepCC:38)
<>aSlctFF{$i}{5}:=Field:C253(->[Cost_Centers:27]ProdCC:39)

$i:=Table:C252(->[Estimates_DifferentialsForms:47])
<>aSlctFF{$i}{1}:=Field:C253(->[Estimates_DifferentialsForms:47]DiffId:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Estimates_DifferentialsForms:47]FormNumber:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Estimates_DifferentialsForms:47]DiffFormId:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Estimates_DifferentialsForms:47]DateCustomerWant:7)
<>aSlctFF{$i}{5}:=Field:C253(->[Estimates_DifferentialsForms:47]NumItems:8)

