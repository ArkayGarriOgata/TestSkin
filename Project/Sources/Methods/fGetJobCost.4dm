//%attributes = {"publishedWeb":true}
//Method: fGetJobCost(jobit)  022499  MLB
//get the costs of a jobit, 
C_TEXT:C284($1)
C_LONGINT:C283($0)
$0:=qryJMI(Substring:C12($1; 1; 8); Num:C11(Substring:C12($1; 10)))
If ($0>0)
	If ($2="Planned")
		$3->:=[Job_Forms_Items:44]PldCostMatl:17
		$4->:=[Job_Forms_Items:44]PldCostLab:18
		$5->:=[Job_Forms_Items:44]PldCostOvhd:19
	Else   //actual
		$3->:=[Job_Forms_Items:44]Cost_Mat:12
		$4->:=[Job_Forms_Items:44]Cost_LAB:13
		$5->:=[Job_Forms_Items:44]Cost_Burd:14
	End if 
	
Else 
	$3->:=0
	$4->:=0
	$5->:=0
End if 
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)