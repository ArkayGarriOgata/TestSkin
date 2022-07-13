//%attributes = {"publishedWeb":true}
//Procedure: qryMachJob(Form;CC;Sequence)
// May 10, 1995

C_TEXT:C284($1; $JobForm)
C_TEXT:C284($2; $CC)
C_LONGINT:C283($3; $Seq; $0; $4)

$JobForm:=$1
$CC:=$2
$Seq:=$3

MESSAGES OFF:C175

If (Count parameters:C259=3)
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$JobForm; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]CostCenterID:4=$CC; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=$Seq)
Else   //allready on the form
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=$CC; *)
	QUERY SELECTION:C341([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=$Seq)
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
End if 

$0:=Records in selection:C76([Job_Forms_Machines:43])