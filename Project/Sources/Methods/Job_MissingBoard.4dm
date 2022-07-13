//%attributes = {}
// _______
// Method: Job_MissingBoard
// By: MelvinBohince @ 03/17/22, 09:18:41
// Description
//  List jobs that are missing board issues
// ----------------------------------------------------
// Modified by: MelvinBohince (3/28/22) change to HTML mail

$startDate:=Date:C102("1/1/"+String:C10(Year of:C25(Current date:C33(*))))

C_TEXT:C284($excludeRnD)  //don't care about these, see Job_New_R_n_D ( )
$excludeRnD:=String:C10(Year of:C25($startDate); "00000")+"@"

C_COLLECTION:C1488($startedJobs_c)  // Jobs that have machine tickets entered
$startedJobs_c:=ds:C1482.Job_Forms_Machine_Tickets.query("DateEntered >= :1 and JobForm # :2"; $startDate; $excludeRnD).distinct("JobForm")

C_COLLECTION:C1488($board)  // search commodities
$board:=New collection:C1472(1; 20)

C_COLLECTION:C1488($hasBoardIssues_c)  // Jobs that have board issued
$hasBoardIssues_c:=ds:C1482.Raw_Materials_Transactions.query("JobForm in :1 and CommodityCode in :2"; $startedJobs_c; $board).distinct("JobForm")

C_TEXT:C284($missingBoard; $jobForm)
$missingBoard:=""  // list of Jobs that do not have board issue

For each ($jobForm; $startedJobs_c)
	
	If ($hasBoardIssues_c.indexOf($jobForm)=-1)  // has board been issued?
		$missingBoard:=$missingBoard+$jobForm+", "
	End if 
	
End for each 

If ($missingBoard#CorektBlank)
	
	$missingBoard:=Substring:C12($missingBoard; 1; Length:C16($missingBoard)-2)  //Remove last <,><space>
	
End if 

//$distributionList:=Batch_GetDistributionList ("Jobs Missing Board")
//$emailBody:="Jobs missing board: "+$missingBoard

//EMAIL_Sender ("Jobs Missing Board";"";$emailBody;$distributionList)

$distributionList:=Batch_GetDistributionList("Jobs Missing Board")
//$distributionList:="mel.bohince@arkay.com"
$subject:="Jobs Missing Board - "+String:C10(Current date:C33; Internal date short special:K1:4)
$preheader:=$missingBoard
$body:="Jobs: "+$missingBoard+" appear to be started and are missing board issues"
Email_html_body($subject; $preheader; $body; 500; $distributionList)

///////////////////////18168.01
