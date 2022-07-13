//%attributes = {"publishedWeb":true}
//(p) fCalcYeild
//• 4/9/98 cs nan checking/removal

C_REAL:C285($YldCost; $scrap; $ot; $hrs)
C_LONGINT:C283($delta; $1)

$delta:=$1

If ($delta#0)  //then calculate the additional cost of running that many cartons
	$hrs:=uNANCheck(Round:C94(($delta/[Estimates_Machines:20]RunningRate:31); 2))
	
	If ([Cost_Centers:27]AddScrapExcess:25)
		$scrap:=Round:C94(($hrs*[Cost_Centers:27]ScrapExcessCost:32); 2)
	Else 
		$scrap:=0
	End if 
	
	If ([Estimates_Machines:20]CalcOvertimeFlg:42)
		$ot:=Round:C94((($hrs*[Cost_Centers:27]MHRlaborSales:4)*0.5); 2)
	Else 
		$ot:=0
	End if 
	
	$YldCost:=($hrs*([Cost_Centers:27]MHRlaborSales:4+[Cost_Centers:27]MHRburdenSales:5))+$scrap+$ot
	
Else 
	$hrs:=0
	$YldCost:=0
End if 
[Estimates_Machines:20]Hrs_YldAddition:44:=uNANCheck($hrs)
[Estimates_Machines:20]OOP_YldAddition:45:=uNANCheck($YldCost)