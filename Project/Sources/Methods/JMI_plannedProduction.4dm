//%attributes = {"publishedWeb":true}
//PM:  JMI_plannedProductionpn{;orderline})  3/08/00  mlb
//adhoc suppliment to provide a list of jobs which
//are planned to produce an item

C_TEXT:C284($1; $2)
C_TEXT:C284($0; $plndJobs)

READ ONLY:C145([Job_Forms_Items:44])

If (Count parameters:C259=2)
	$orderline:=$2
Else 
	$orderline:="n/a"
End if 

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$1; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
If (Records in selection:C76([Job_Forms_Items:44])>0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $aJF; [Job_Forms_Items:44]OrderItem:2; $aOrderPeg)
	SORT ARRAY:C229($aJF; $aOrderPeg; >)
	QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aJF)
	// Modified by: Mel Bohince (1/30/18) add status to list
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForm; [Job_Forms:42]Status:6; $aJobFormStatus)
	SORT ARRAY:C229($aJobForm; $aJobFormStatus; >)
	$plndJobs:=""
	For ($i; 1; Size of array:C274($aJF))
		$hit:=Find in array:C230($aJobForm; $aJF{$i})
		If ($hit>-1)
			$state:="{"+$aJobFormStatus{$hit}+"}"
		Else 
			$state:=""
		End if 
		
		If ($aOrderPeg{$i}=$orderline)
			$peg:="*"
		Else 
			$peg:=""
		End if 
		If (Position:C15($aJF{$i}; $plndJobs)=0)
			$plndJobs:=$plndJobs+$aJF{$i}+$state+$peg+", "
		End if 
	End for 
	
Else 
	$plndJobs:="no open jobs"
End if 

$0:=$plndJobs