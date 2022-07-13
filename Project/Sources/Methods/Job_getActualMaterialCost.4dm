//%attributes = {"executedOnServer":true}
// _______
// Method: Job_getActualMaterialCost   ( jobForm ;selling price ) -> actual material cost
// By: MelvinBohince @ 05/03/22, 14:04:32
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($jobForm_t; $1; $autoIssues)
C_REAL:C285($materialCost; $sellingPrice; $2; $autoIssuesCosts)
C_OBJECT:C1216($materials_es)

If (Count parameters:C259>0)
	$jobForm_t:=$1
	$sellingPrice:=Abs:C99($2)
Else 
	$jobForm_t:="16045.01"
	$sellingPrice:=3058.03
End if 

//going to exclued auto issues as they were based on an estimated selling price for the entire job, instead
//recalculate based on the sales value of the invoice in question
If ($sellingPrice>0)  //invoice extended price passed in
	$autoIssues:="AutoIssue@"  //see RM_Issue_Auto_Ink, RM_Issue_Auto_Coating, and RM_Issue_Auto_Corrugate
	$autoIssuesCosts:=$sellingPrice*(<>Auto_Ink_Percent+<>Auto_Coating_Percent+<>Auto_Corr_Percent)  //not going to test form lamination rule
	
Else   //else use existing budgeted autos in the transactions
	$autoIssues:=""
	$autoIssuesCosts:=0
End if 

//get the total material costs issued to the job
$materialCost:=0
$materials_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type =:2 and Raw_Matl_Code # :3"; $jobForm_t; "Issue"; $autoIssues)
If ($materials_es.length>0)
	$materialCost:=$materials_es.sum("ActExtCost")*-1
End if 

$materialCost:=$materialCost+$autoIssuesCosts
$0:=$materialCost
