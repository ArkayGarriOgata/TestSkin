//%attributes = {"publishedWeb":true}
//PM: JML_getPlant(jobform) -> hauppauge or roanoke
//@author mlb - 3/4/02  11:31
// Modified by: Mel Bohince (10/26/15) make outside service aware, machine list obsolete

QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]OutsideService:41=True:C214)
If (Records in selection:C76([Job_Forms_Machines:43])>0)
	$0:="VA/OS"
Else 
	$0:="VA"
End if   //QUERY SELECTION([Job_Forms_Machines];[Job_Forms_Machines]CostCenterID="412";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="428";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="416";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="415";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="414";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="468";*)
//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="477")
//If (Records in selection([Job_Forms_Machines])>0)
//$0:="roanoke"
//End if 