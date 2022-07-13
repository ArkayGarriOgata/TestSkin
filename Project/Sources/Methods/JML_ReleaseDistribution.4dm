//%attributes = {"publishedWeb":true}
//PM: JML_ReleaseDistribution() -> 
//@author mlb - 6/19/01  10:41

C_TEXT:C284(xTitle; xText; $t; $cr)
C_DATE:C307($today; $last)
C_LONGINT:C283($days; $i; $j; $numJML; $numJMI; $numRels; $totalRels)

$t:="  "
$cr:=Char:C90(13)
$days:=7*10
xText:="Jobform "+$t+"#I"+$t+"#R"+$t+"Distribution by day for "+String:C10($days)+" days"+$cr
$histoGram:="-"*$days  //each character represents a day, the first being today

$today:=4D_Current_date
$last:=$today+$days-1
xTitle:="Jobs' Release Disturbution from "+String:C10($today; System date short:K1:1)+" to "+String:C10($last; System date short:K1:1)

$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJF; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine)

For ($i; 1; $numJML)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$aJF{$i})
	$numJMI:=Records in selection:C76([Job_Forms_Items:44])
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $aJobit; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]OrderItem:2; $aOL)
	$distribution:=$histoGram
	$numRels:=0
	$totalRels:=0
	For ($j; 1; $numJMI)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$j}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		$totalRels:=$totalRels+$numRels
		If ($numRels>0)
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aSchd)
			For ($k; 1; $numRels)
				$relDate:=$aSchd{$k}
				Case of 
					: ($relDate=!00-00-00!)
						$when:=$days
					: ($relDate<=$today)
						$when:=1
					: ($relDate>=$last)
						$when:=$days
					Else 
						$when:=$relDate-$today+1
				End case 
				$current:=Num:C11($distribution[[$when]])
				If ($current>=9)
					$distribution[[$when]]:="X"
				Else 
					$distribution[[$when]]:=String:C10(Num:C11($distribution[[$when]])+1)
				End if 
			End for 
		End if 
	End for 
	xText:=xText+$aJF{$i}+$t+String:C10($numJMI; "^0")+$t+String:C10($totalRels; "^0")+$t+$distribution+$cr
End for 

rPrintText