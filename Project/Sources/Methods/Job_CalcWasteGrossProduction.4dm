//%attributes = {"publishedWeb":true}
//Job_CalcWasteGrossProduction(jobform) 111400 mlb
//calc waste as gross sheeted-(good cartons/numUp) over gross sheeted

C_REAL:C285($wastePercent; $0)
C_LONGINT:C283($grossSheeted; $goodCartons; $netSheets; $wasteSheets)

If ([Job_Forms:42]JobFormID:5#$1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
End if 

QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2="426"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="427"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="428"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms:42]JobFormID:5)
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
	$grossSheeted:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
Else 
	$grossSheeted:=0
End if 

$goodCartons:=[Job_Forms:42]QtyActProduced:35  //see JOB_RollupActuals called by JOB_Closeout

If ([Job_Forms:42]NumberUp:26>0)
	$netSheets:=Int:C8($goodCartons/[Job_Forms:42]NumberUp:26)
Else 
	$netSheets:=$goodCartons
End if 

$wasteSheets:=$grossSheeted-$netSheets

If ($grossSheeted>0)
	$wastePercent:=Round:C94($wasteSheets/$grossSheeted*100; 0)
Else 
	$wastePercent:=0
End if 

$0:=$wastePercent