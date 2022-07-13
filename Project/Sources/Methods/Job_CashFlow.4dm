//%attributes = {"publishedWeb":true}
//PM:  Job_getCashFlow(jobform;->qtyshipped) -> $cashflow  1/25/01  mlb
//get dollar value based on releases (non consignment, not forecast) out to a specified date
//if date isn't provide, go out to end of current month
// Modified by: Mel Bohince (6/28/16) dig deeper for price with REL_getPrice and use 8 week horizon
C_REAL:C285($0; $cashFlow)
C_TEXT:C284($1; $jobForm; $lastCPN)
//C_DATE($2;$boundaryDate)
C_POINTER:C301($2)
$jobForm:=$1
$cashFlow:=0
$unitsShipped:=0
MESSAGES OFF:C175

$boundaryDate:=Add to date:C393(4D_Current_date; 0; 0; (8*7))  //8 weeks

C_LONGINT:C283($numJMI; $i; $j; $numCPN)

CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "cashFlowJMI")  //so we can restore preconditions
CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "cashFlowRel")  //so we can restore preconditions
CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "cashFlowOL")  //so we can restore preconditions
UNLOAD RECORD:C212([Job_Forms_Items:44])
$numJMI:=qryJMI($jobForm+"@")
If ($numJMI>0)
	ARRAY TEXT:C222($aProduct; 0)
	ARRAY LONGINT:C221($aWantQty; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aProduct; [Job_Forms_Items:44]Qty_Want:24; $aWantQty)
	SORT ARRAY:C229($aProduct; $aWantQty; >)
	ARRAY TEXT:C222($aCPN; $numJMI)
	ARRAY LONGINT:C221($aQty; $numJMI)
	$numCPN:=0
	$lastCPN:=""
	//*get the planned production per item
	For ($i; 1; $numJMI)
		If ($aProduct{$i}#$lastCPN)
			$numCPN:=$numCPN+1
			$aCPN{$numCPN}:=$aProduct{$i}
			$lastCPN:=$aProduct{$i}
		End if 
		$aQty{$numCPN}:=$aQty{$numCPN}+$aWantQty{$i}
	End for 
	ARRAY TEXT:C222($aCPN; $numCPN)
	ARRAY LONGINT:C221($aQty; $numCPN)
	ARRAY TEXT:C222($aProduct; 0)
	ARRAY LONGINT:C221($aWantQty; 0)
	
	//*get releases for each cpn and convert to dollars
	For ($i; 1; $numCPN)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$i}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31#1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$boundaryDate)
		For ($j; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
			$price:=REL_getPrice
			Case of 
				: ($aQty{$i}<=0)
					$j:=1+Records in selection:C76([Customers_ReleaseSchedules:46])  //break
					
				: ($aQty{$i}>=[Customers_ReleaseSchedules:46]Sched_Qty:6)  //value all of the release
					$cashFlow:=$cashFlow+(([Customers_ReleaseSchedules:46]Sched_Qty:6/1000)*$price)
					$unitsShipped:=$unitsShipped+[Customers_ReleaseSchedules:46]Sched_Qty:6
					$aQty{$i}:=$aQty{$i}-[Customers_ReleaseSchedules:46]Sched_Qty:6
					
				: ($aQty{$i}<[Customers_ReleaseSchedules:46]Sched_Qty:6)  //value all of the production
					$cashFlow:=$cashFlow+(($aQty{$i}/1000)*$price)
					$unitsShipped:=$unitsShipped+$aQty{$i}
					$aQty{$i}:=$aQty{$i}-$aQty{$i}
			End case 
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
		End for   //each release
	End for   //cpn 
	
End if   //items  

$2->:=$unitsShipped
$0:=Round:C94($cashflow; 0)

USE NAMED SELECTION:C332("cashFlowJMI")
USE NAMED SELECTION:C332("cashFlowRel")
USE NAMED SELECTION:C332("cashFlowOL")