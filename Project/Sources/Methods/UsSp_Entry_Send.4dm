//%attributes = {}
//Method:  UsSp_Entry_Send
//Description:  This method will send an email with the information
//  v18 Upgrade change to zip the attachements and send in one email
//  Modified by: Garri Ogata (8/10/21) Changed to send from amsHelp to garri.ogata 
//  Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
//  Modified by: Garri Ogata (11/29/21) added CaseID to body
//  Modified by: Garri Ogata (03/08/21) changed app_getNextID to use 8005 and $tService to be more meangful 
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_LONGINT:C283($nCaseID)
	
	C_TEXT:C284($tSubject)
	C_TEXT:C284($tBodyHeader)
	C_TEXT:C284($tBody)
	C_TEXT:C284($tDistributionList)
	C_TEXT:C284($tAttachmentPath)
	C_TEXT:C284($tReplyTo)
	
	C_TEXT:C284($tSuccessMessage)
	C_TEXT:C284($tFailureMessage)
	C_TEXT:C284($tSuccess)
	C_TEXT:C284($tCaseId)
	C_TEXT:C284($tService)
	C_LONGINT:C283($nAttachment; $nNumberOfAttachments)
	
	C_OBJECT:C1216($oAsk)
	
	C_LONGINT:C283($nConfirmButton)
	
	$oAsk:=New object:C1471()
	
	$tSubject:="[UsSp] "+UsSp_atEntry_Category{UsSp_atEntry_Category}+CorektSpace+UsSp_tEntry_Form
	
	$tService:="User Support Case Number"
	
	app_getNextID(8005; ->$tService; ->$nCaseID)
	
	$tCaseID:=String:C10($nCaseID)
	
	$tBodyHeader:=UsSp_tEntry_Email
	$tBody:="Case ID:  "+$tCaseId+CorektPeriod+CorektSpace+UsSp_tEntry_Issue+Core_User_GetSystemInfoT
	
	$tDistributionList:=ArkyktAmsHelpEmail
	$tAttachmentPath:=CorektBlank
	$tReplyTo:=UsSp_tEntry_Email
	
	$tSuccessMessage:="Thank you for contacting aMs User Support. An aMs User Support person will contact you shortly."
	
	$tFailureMessage:="We had an issue with sending your request."+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)
	$tFailureMessage:=$tFailureMessage+"Please send an email to amshelp@arkay.com "
	$tFailureMessage:=$tFailureMessage+"and attach all the documents located on your desktop in the folder aMsUserSupport."+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)
	$tFailureMessage:=$tFailureMessage+"Thank you very much."
	
	$tSuccess:=CorektBlank
	
	$nNumberOfAttachments:=Size of array:C274(UsSp_atEntry_Attachment)
	
	$oAsk.tMessage:="Do you want to send the "+UsSp_atEntry_Category{UsSp_atEntry_Category}+" to aMs User Support?"
	$oAsk.tDefault:="Send eMail"
	$oask.tCancel:="Cancel"
	
	If (User in group:C338(Current user:C182; "RoleSuperUser"))
		$oAsk.tNonDefault:="My eMail"
	End if 
	
End if   //Done Initialize

If (Core_Dialog_ConfirmN($oAsk)#CoreknCancel)  //Send email
	
	If ($oAsk.nResult=CoreknNonDefault)  //My email address
		$tDistributionList:=UsSp_tEntry_Email
	End if   //Done my email address
	
	$oAsk.tDefault:=CorektBlank
	$oask.tCancel:=CorektBlank
	$oAsk.tNonDefault:=CorektBlank
	
	For ($nAttachment; 1; $nNumberOfAttachments)  //Loop thru attachments
		
		$tAttachmentPath:=UsSp_atEntry_Attachment{$nAttachment}
		
		$tNewSubject:=$tSubject+CorektSpace+String:C10($nAttachment)+" of "+String:C10($nNumberOfAttachments)
		
		$tSuccess:=EMAIL_Sender($tNewSubject; $tBodyHeader; $tBody; $tDistributionList; $tAttachmentPath; $tReplyTo)
		
		If ($tSuccess#CorektBlank)  //Error
			
			$nAttachment:=$nNumberOfAttachments+1
			
			UsSp_CopyToDesktop(->UsSp_atEntry_Attachment)
			
		End if   //Done error
		
	End for   //Done looping thru attachments
	
	$oAsk.tDefault:="OK"
	
	$oAsk.tMessage:=Choose:C955(\
		($tSuccess=CorektBlank); \
		$tSuccessMessage; \
		$tFailureMessage)
	
	Core_Dialog_Alert($oAsk)
	
	If ($tSuccess=CorektBlank)  //Success
		
		ACCEPT:C269  //Close the window
		
	End if   //Done success
	
End if   //Done send email
