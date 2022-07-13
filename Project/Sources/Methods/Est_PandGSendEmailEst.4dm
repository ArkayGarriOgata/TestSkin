//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/22/13, 13:57:39
// ----------------------------------------------------
// Method: Est_PandGSendEmailEst
// Description:
// Send the proper email back to the Estimator.
// ----------------------------------------------------

C_BOOLEAN:C305($1; $bDoWhat)
C_TEXT:C284($tSubject; $tBodyTitle; $tBody; $tSender; $tRecepients)

$bDoWhat:=$1

If (Size of array:C274(atProdCodes)>1)
	$tSubject:="The Estimate, "+[Job_Forms:42]CaseFormID:9+", has problems with multiple product codes."
	$tBodyTitle:="Action Needed!"+<>CR
	$tBodyTitle:=$tBodyTitle+"The Job Form, "+[Job_Forms:42]JobFormID:5+", on the estimate, "+[Job_Forms:42]CaseFormID:9+", has problems with mutiple product codes."
	$tBody:="The following products have quantities outside the acceptable values:"+<>CR+<>CR
	For ($i; 1; Size of array:C274(atProdCodes))
		$tBody:=$tBody+atProdCodes{$i}+<>CR
	End for 
	
Else 
	$tSubject:="The Estimate, "+[Job_Forms:42]CaseFormID:9+", has a problem with a product code."
	$tBodyTitle:="Action Needed!"+<>CR
	$tBodyTitle:=$tBodyTitle+"The Job Form, "+[Job_Forms:42]JobFormID:5+", on the estimate, "+[Job_Forms:42]CaseFormID:9+", has a problem with a product code."
	$tBody:="The following product has quantities outside the acceptable values:"+<>CR+<>CR
	$tBody:=$tBody+atProdCodes{1}+<>CR
End if 

If ($bDoWhat)  //Override
	$tBody:=$tBody+<>CR
	$tBody:=$tBody+"Your manager has approved the quantitys in the estimate and you may now continue with it."+<>CR+<>CR
	
	//The status is updated only if the manager overrides the quantities.
	If ([Job_Forms:42]VersionNumber:57=0)  //New Job
		[Job_Forms:42]Status:6:="Planned"
	Else   //Revised Job
		[Job_Forms:42]Status:6:="Revised"
	End if 
	
Else   //Fix quantities
	$tBody:=$tBody+<>CR
	$tBody:=$tBody+"Your manager has NOT approved the quantitys in the estimate and you must fix them."+<>CR+<>CR
	
End if 

$tBody:=$tBody+"Thank you,"+<>CR
$tBody:=$tBody+"aMs"+<>CR+<>CR+<>CR+<>CR
$tBody:=$tBody+"Below are the comments entered by your manager:"+<>CR+<>CR
$tbody:=$tBody+[Job_Forms:42]PandGProbsComments:85

[Job_Forms:42]PandGProbsCkByMgr:84:=True:C214

READ ONLY:C145([Users:5])
QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
If (Records in selection:C76([Users:5])#1)
	$tSender:=Request:C163("Please enter your email address.")
Else 
	$tSender:=[Users:5]email:27
End if 

EMAIL_Sender($tSubject; $tBodyTitle; $tBody; [Job_Forms:42]PandGProbsEmail:86; ""; ""; $tSender)