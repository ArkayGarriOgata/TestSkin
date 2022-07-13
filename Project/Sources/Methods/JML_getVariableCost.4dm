//%attributes = {}
// ----------------------------------------------------
// Method: JML_getVariableCost(job_form) ->
// By: Mel Bohince @ 04/13/16, 10:06:38
// Description
// rtn varible cost defined as total material costs
// ----------------------------------------------------
// note that ink and coatings plan $ is heavy, so using the autoissue calc

READ ONLY:C145([Job_Forms_Materials:55])
C_LONGINT:C283($0; $variable_cost)
C_TEXT:C284($1; $jobform)
C_BOOLEAN:C305($laminated)
$laminated:=False:C215

$jobform:=$1
$variable_cost:=0  //material costs

// for now consider only the matl costs, labor is essensially fixed and overhead can lie based on allocation method

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$jobform; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12#"02@"; *)  //will be using the auto issue style calc
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12#"03@")

If (Records in selection:C76([Job_Forms_Materials:55])>0)
	$variable_cost:=Round:C94(Sum:C1([Job_Forms_Materials:55]Planned_Cost:8); 0)
	REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
	
	If (False:C215)  //just for searching in design
		RM_Issue_Auto_Ink
		RM_Issue_Auto_Coating
		RM_Issue_Auto_Corrugate  // Modified by: Mel Bohince (5/15/17) 
	End if 
	
	$highest_posible_rev:=Round:C94(JOB_SellingPriceTotal($jobform); 2)
	
	If (Position:C15("474"; [Job_Forms_Master_Schedule:67]Operations:36)>0) | (Position:C15("475"; [Job_Forms_Master_Schedule:67]Operations:36)>0)  //<>LAMINATERS
		$laminated:=True:C214
	End if 
	If (Not:C34($laminated))
		$variable_cost:=$variable_cost+($highest_posible_rev*<>Auto_Coating_Percent)
	End if 
	
	$variable_cost:=$variable_cost+($highest_posible_rev*<>Auto_Ink_Percent)
	
	$variable_cost:=$variable_cost+($highest_posible_rev*<>Auto_Corr_Percent)  // Modified by: Mel Bohince (5/15/17) 
End if 

$0:=$variable_cost
