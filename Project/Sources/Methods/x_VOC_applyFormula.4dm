//%attributes = {"publishedWeb":true}
//PM: x_VOC_applyFormula() -> 
//@author mlb - 10/9/01  15:58
MESSAGES OFF:C175
C_TEXT:C284($0; $cc)
$cc:=""
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Sequence:3=[Raw_Materials_Transactions:23]Sequence:13)
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
	$cc:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
Else 
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Raw_Materials_Transactions:23]Sequence:13)
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		$cc:=[Job_Forms_Machines:43]CostCenterID:4
	End if 
End if 

$0:=$cc