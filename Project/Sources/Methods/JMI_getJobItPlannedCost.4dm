//%attributes = {"publishedWeb":true}
//PM: JMI_getJobItPlannedCost(jobit) -> 
//@author mlb - 6/20/01  09:24

C_REAL:C285($0)
C_TEXT:C284($1)

$0:=0

If ([Job_Forms_Items:44]Jobit:4#$1)  //9/30/94  | ([JobMakesItem]CustId#sCriterion2)
	READ ONLY:C145([Job_Forms_Items:44])
	$numJMI:=qryJMI($1)  //•051595  MLB  UPR 1508   
Else 
	$numJMI:=1
End if 

If ($numJMI>0)  //2/10/95 test for hit
	$0:=[Job_Forms_Items:44]PldCostTotal:21
End if 