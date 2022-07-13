//%attributes = {"publishedWeb":true}
//fCalcPlate()   -JML  8/4/93, mod mlb 11/10/93, 2/10/94
//401 Plate Department calc
//3/23/94 upr1043
//upr 1163 10/11/94
//•051496  MLB  UPR ? add the roland's plates
//•031197  mBohince  MarkAndy Plates
//•062598  MLB  UPR 238 spl calc for 411 & 412 plates
//•082698  MLB  UPR 238 multilplier for 412
//Gross and net don't apply here since we are talking about plates
//for the same reason, only Make Ready costs apply, with Running & waste stuff 
//being nonapplicable.

C_LONGINT:C283($1; $waste; $net; $gross; $0; $2; $3; $plates)  //$numberUp;$Items;$keys;$press;$remakes;$swings;$multilpier)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation
$plates:=[Estimates_Machines:20]Flex_field1:18
//WASTE
$waste:=0  //fCalcStdWaste ($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
$MR_hrs:=0
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	Case of 
		: (True:C214)
			$MR_hrs:=[Cost_Centers:27]MR_mimumum:33*$plates
			
		Else 
			BEEP:C151
			ALERT:C41("You must specify the press (411-415 or 417 or 451) for the plate department.")
			$MR_hrs:=9999
	End case 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 
//RUN N/A
[Estimates_Machines:20]RunningRate:31:=0

fCalcStdTotals($Gross; $waste; $net)

$0:=$gross