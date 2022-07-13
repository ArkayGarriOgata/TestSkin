//%attributes = {"publishedWeb":true}
//Procedure: uInitJobArrs()  090295  MLB
//

$i:=Table:C252(->[Jobs:15])
<>aSlctFF{$i}{1}:=Field:C253(->[Jobs:15]JobNo:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Jobs:15]CustID:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Jobs:15]Line:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Jobs:15]Status:4)
<>aSlctFF{$i}{5}:=Field:C253(->[Jobs:15]EstimateNo:6)

$i:=Table:C252(->[Job_Forms:42])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms:42]JobFormID:5)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms:42]OutlineNumber:65)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms:42]Status:6)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms:42]cust_id:82)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms:42]JobType:33)

//2/9/95 upr 1398
$i:=Table:C252(->[Job_Forms_Items:44])
<>aSlctFF{$i}{1}:=Field:C253(->[Job_Forms_Items:44]JobForm:1)
<>aSlctFF{$i}{2}:=Field:C253(->[Job_Forms_Items:44]OrderItem:2)
<>aSlctFF{$i}{3}:=Field:C253(->[Job_Forms_Items:44]ProductCode:3)
<>aSlctFF{$i}{4}:=Field:C253(->[Job_Forms_Items:44]CustId:15)
<>aSlctFF{$i}{5}:=Field:C253(->[Job_Forms_Items:44]Qty_Actual:11)

$i:=Table:C252(->[To_Do_Tasks_Sets:99])
<>aSlctFF{$i}{1}:=Field:C253(->[To_Do_Tasks_Sets:99]Category:2)
<>aSlctFF{$i}{2}:=Field:C253(->[To_Do_Tasks_Sets:99]Task:3)
<>aSlctFF{$i}{3}:=Field:C253(->[To_Do_Tasks_Sets:99]AssignedTo:5)
<>aSlctFF{$i}{4}:=Field:C253(->[To_Do_Tasks_Sets:99]id:1)
<>aSlctFF{$i}{5}:=Field:C253(->[To_Do_Tasks_Sets:99]HowTo:4)

$i:=Table:C252(->[To_Do_Tasks:100])
<>aSlctFF{$i}{1}:=Field:C253(->[To_Do_Tasks:100]AssignedTo:9)
<>aSlctFF{$i}{2}:=Field:C253(->[To_Do_Tasks:100]Jobform:1)
<>aSlctFF{$i}{3}:=Field:C253(->[To_Do_Tasks:100]CreatedBy:8)
<>aSlctFF{$i}{4}:=Field:C253(->[To_Do_Tasks:100]Task:3)
<>aSlctFF{$i}{5}:=Field:C253(->[To_Do_Tasks:100]Category:2)

$i:=Table:C252(->[ProductionSchedules_BlockTimes:136])
<>aSlctFF{$i}{1}:=Field:C253(->[ProductionSchedules_BlockTimes:136]BlockId:1)
<>aSlctFF{$i}{2}:=Field:C253(->[ProductionSchedules_BlockTimes:136]ProjectNumber:2)
<>aSlctFF{$i}{3}:=Field:C253(->[ProductionSchedules_BlockTimes:136]LineSpecificationID:4)

