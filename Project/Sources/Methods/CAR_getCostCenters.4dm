//%attributes = {"publishedWeb":true}
//PM: CAR_getCostCenters(jobit) -> 
//@author mlb - 7/18/01  11:11

C_TEXT:C284($jobForm; $1)
C_LONGINT:C283($i; $numCC)
ARRAY TEXT:C222(aStdCC; 0)
ARRAY TEXT:C222(aCostCtrDes; 0)

READ ONLY:C145([Job_Forms_Machine_Tickets:61])

$jobForm:=Substring:C12($1; 1; 8)

If (Length:C16($jobForm)=8)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$jobForm)
	DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]CostCenterID:2; aStdCC)
	$numCC:=Size of array:C274(aStdCC)
	ARRAY TEXT:C222(aCostCtrDes; $numCC)
	SET QUERY LIMIT:C395(1)
	For ($i; 1; $numCC)
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=aStdCC{$i})
		aCostCtrDes{$i}:=aStdCC{$i}+"-"+[Cost_Centers:27]Description:3
	End for 
	SET QUERY LIMIT:C395(0)
	INSERT IN ARRAY:C227(aStdCC; 1; 1)
	aStdCC{1}:="405"
	INSERT IN ARRAY:C227(aCostCtrDes; 1; 1)
	aCostCtrDes{1}:=aStdCC{1}+"-Imaging"
	INSERT IN ARRAY:C227(aStdCC; 1; 1)
	aStdCC{1}:="O/S"
	INSERT IN ARRAY:C227(aCostCtrDes; 1; 1)
	aCostCtrDes{1}:=aStdCC{1}+"-Outside Service"
	INSERT IN ARRAY:C227(aStdCC; 1; 1)
	aStdCC{1}:=""
	INSERT IN ARRAY:C227(aCostCtrDes; 1; 1)
	aCostCtrDes{1}:=aStdCC{1}+""
End if 

REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)