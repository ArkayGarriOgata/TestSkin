//%attributes = {"publishedWeb":true}
//PM:  JMI_getJobItProductionCost(jobit)  2/14/01  mlb
//see also  `Method: fGetJobCost(jobit)  022499  MLB
//get the costs of a jobit, 

C_TEXT:C284($1)
C_REAL:C285($0)

READ ONLY:C145([Job_Forms_Items:44])

SET QUERY LIMIT:C395(1)
$numJMI:=qryJMI($1)
SET QUERY LIMIT:C395(0)
If ($numJMI>0)
	If ([Job_Forms_Items:44]FormClosed:5)
		$0:=Round:C94([Job_Forms_Items:44]ActCost_M:27; 2)
	Else 
		$0:=Round:C94([Job_Forms_Items:44]PldCostTotal:21; 2)
	End if 
Else 
	$0:=0
End if 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)