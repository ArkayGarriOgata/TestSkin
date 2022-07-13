//%attributes = {}
//Method:  Batch_CheckSuccess(oOption)
//Description:  This method is run as a side process to check
//. that the batch reports run completely. It will send an email
//. after an hour if the batch reports process is still running.
//. It will check every 15 minutes after that ntil the process is completed.

//Called from method:

//. C_OBJECT($oOption)
//. $oOption:=New object()
//  $oOption.bStartChecking:=True
//. $oOption.nBatchProcessID:=Current process
//. Batch_CheckSuccess ($oOption)

// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail and Batch_CheckLogB
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oOption)
	
	C_LONGINT:C283($n15Minutes)
	C_LONGINT:C283($nBatchCheckSuccessProcess; $nSize)
	C_BOOLEAN:C305($bStartChecking)
	
	C_TEXT:C284($tSubject)
	C_TEXT:C284($tBodyHeader)
	C_TEXT:C284($tBody)
	C_TEXT:C284($tDistributionList)
	C_TEXT:C284($tAttachmentPath)
	C_TEXT:C284($tReplyTo)
	C_TEXT:C284($tSuccess)
	
	$oOption:=New object:C1471()
	
	$oOption:=$1
	
	$n15Minutes:=60*60*15
	
	$nSize:=<>lMinMemPart
	
	$bStartChecking:=False:C215
	
	If (OB Is defined:C1231($oOption; "bStartChecking"))
		$bStartChecking:=$oOption.bStartChecking
	End if 
	
	$tSubject:="[UsSp] "+Current method name:C684()+" batch reports issuing"
	$tBodyHeader:="There might be an issue with the batch reports. The batch report is still running."
	$tBody:="Sometimes this happens when a dialog appears on the aMs batch client "
	
	$tDistributionList:=ArkyktAmsHelpEmail
	
	$tAttachmentPath:=CorektBlank
	$tReplyTo:=ArkyktAmsHelpEmail
	
	$tSuccess:=CorektBlank
	
End if   //Done initialize

ON ERR CALL:C155("Batch_CheckSuccesError")

If ($bStartChecking)  //Start
	
	$oOption.bStartChecking:=False:C215
	$oOption.nBatchProcessID:=Current process:C322
	
	$nBatchCheckSuccessProcess:=New process:C317("Batch_CheckSuccess"; $nSize; "Batch_CheckSuccess"; $oOption)
	
Else   //Started
	
	DELAY PROCESS:C323(Current process:C322; (4*$n15Minutes))  //Wait 1 hour
	
	If (Not:C34(Batch_CheckLogB))  //Check
		
		$tSuccess:=EMAIL_Sender($tSubject; $tBodyHeader; $tBody; $tDistributionList; $tAttachmentPath; $tReplyTo)
		
	End if   //Done check
	
End if   //Done Start

ON ERR CALL:C155(CorektBlank)

