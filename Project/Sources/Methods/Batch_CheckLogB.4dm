//%attributes = {}
//Method:  Batch_CheckLogB=>bChecked
//Description:  This method checks the batch log file to make sure it ran
//.  to completion

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bLogChecked)
	
	C_COLLECTION:C1488($cLine)
	
	C_DATE:C307($dBatchedOn)
	
	C_TEXT:C284($tDocumentPath)
	
	C_TEXT:C284($tBatchLog)
	C_TEXT:C284($tBatchEnd)
	C_TEXT:C284($tSeparator)
	C_TEXT:C284($tLastLine)
	
	C_TEXT:C284($tBatchedOnAt)
	
	C_TIME:C306($hBatchedAt)
	
	$bLogChecked:=False:C215
	
	$tBatchLog:=CorektBlank  //Batch log file
	$tBatchEnd:=CorektBlank  //Last line END
	$tBatchedOnAt:=CorektBlank  //DateTime OnAt
	
	$tDocumentPath:=<>PATH_TO_LOG_FILE+"BatchRunner.Log"
	
	$cLine:=New collection:C1472()
	$tSeparator:=CorektCR
	
	$dBatchRun:=Current date:C33()
	$dBatchRun:=!2021-09-06!
	
End if   //Done initialize

$tBatchLog:=Document to text:C1236($tDocumentPath)

$cLine:=Split string:C1554($tBatchLog; $tSeparator; sk ignore empty strings:K86:1+sk trim spaces:K86:2)

$tLastLine:=$cLine[$cline.length-1]

$nAsterisk:=Position:C15(CorektAsterisk; $tLastLine)

If ($nAsterisk>0)  //Asterisk
	
	$tBatchedOnAt:=Replace string:C233(\
		Substring:C12($tLastLine; 1; $nAsterisk-2); \
		CorektSpace; \
		"T")
	
	$dBatchedOn:=Date:C102($tBatchedOnAt)
	$hBatchedAt:=Time:C179($tBatchedOnAt)
	
	$tBatchEnd:=Substring:C12($tLastLine; $nAsterisk+2)
	
	Case of   //Verify
			
		: (Not:C34($dBatchedOn=$dBatchRun))  //Date
		: (Not:C34(($hBatchedAt>=?23:00:00?) & ($hBatchedAt<=?23:59:59?)))  //Time
		: (Not:C34($tBatchEnd="END   Setup for next Batch"))  //Three spaces after END
			
		Else   //Verified
			
			$bLogChecked:=True:C214
			
	End case   //Done verify
	
End if   //Done asterisk

$0:=$bLogChecked