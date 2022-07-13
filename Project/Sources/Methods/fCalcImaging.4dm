//%attributes = {"publishedWeb":true}
//fCalcImaging()   - mlb 8/22/94 upr1193
//405 imaging
//Gross and net don't apply here since we are talking about plates
//for the same reason, only Make Ready costs apply, with Running & waste stuff 
//being nonapplicable.

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation
//WASTE
$waste:=0  //fCalcStdWaste ($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
$MR_hrs:=0
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	BEEP:C151
	ALERT:C41("Imaging department requires a make ready override.")
	[Estimates_Machines:20]MakeReadyHrs:30:=0
End if 
//RUN N/A
[Estimates_Machines:20]RunningRate:31:=0

fCalcStdTotals($Gross; $waste; $net)

$0:=$gross