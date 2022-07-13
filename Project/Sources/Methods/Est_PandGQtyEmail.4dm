//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/08/13, 14:09:59
// ----------------------------------------------------
// Method: Est_PandGQtyEmail
// Description:
// Sends a email to a manager to notify him/her of an over Max qty.
// ----------------------------------------------------

C_TEXT:C284($tSubject; $tBodyTitle; $tBody; $tSender; $tRecepients; $0)
C_LONGINT:C283($i)

If (Est_PandGSendEmailTest)
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
	
	$tBody:=$tBody+<>CR
	$tBody:=$tBody+"Please login to aMs to override and let the planner continue working on the estimate or "
	$tBody:=$tBody+"tell the planner he/she must adjust the quantity."+<>CR+<>CR
	$tBody:=$tBody+"When you get to the Jobform {budget} screen you will see a button called "+util_Quote("Show Problems")+". "
	$tBody:=$tBody+"Clicking on that button will present you with a dialog with the problems listed and a "
	$tBody:=$tBody+"area where you can type notes, paste an email from the client, or both. These notes will "
	$tBody:=$tBody+"be sent to the estimator. On the bottom of the dialog are two buttons, "+util_Quote("Send Email to Fix Quantities")+" "
	$tBody:=$tBody+"and "+util_Quote("Send Email and Override")+". Clicking on either button will send an email "
	$tBody:=$tBody+"to the estimator with your instructions to fix the quantities or coninue with them as is."+<>CR+<>CR
	$tBody:=$tBody+"Thank you,"+<>CR
	$tBody:=$tBody+"aMs"+<>CR+<>CR+<>CR+<>CR
	$tBody:=$tBody+"Please do not reply to this email, reply thru aMs."
	
	$tSender:=Email_WhoAmI  // Modified by: Mel Bohince (5/1/13)
	If (Length:C16($tSender)=0)
		$tSender:=Request:C163("Please enter your email address.")
	End if 
	
	$tRecepients:=Batch_GetDistributionList("Min/Max Confirmation")  // Modified by: Mel Bohince (5/1/13)
	
	$0:=EMAIL_Sender($tSubject; $tBodyTitle; $tBody; $tRecepients; ""; ""; $tSender)
End if 