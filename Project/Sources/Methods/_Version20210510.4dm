//%attributes = {}
// _______
// Method: _Version20210510   ( ) ->
// By: Garri Ogata @ 05/06/21, 11:30:21
// Description
//  Clean up [Job_Forms]Notes field of large numbers of spaces and possible gremlins
//  This issued caused Job bag Reviews to hang printers.
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esJobForms; $eJobForm)
	C_OBJECT:C1216($esEstmDfrnForms; $eEstmDfrnForm)
	
	C_OBJECT:C1216($oProgress)
	C_OBJECT:C1216($oSaveResult)
	
	C_LONGINT:C283($nLoop; $nNumberOfLoops)
	C_LONGINT:C283($nOriginalLength; $nStrippedLength)
	
	C_TEXT:C284($tNotes)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	
	ARRAY TEXT:C222($atForm; 0)
	ARRAY TEXT:C222($atReason; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektSpace)
	
	APPEND TO ARRAY:C911($apColumn; ->$atForm)
	APPEND TO ARRAY:C911($apColumn; ->$atReason)
	
	$esJobForms:=New object:C1471()
	$eJobForm:=New object:C1471()
	
	$esEstmDfrnForms:=New object:C1471()
	$eEstmDfrnForm:=New object:C1471()
	
	$oSaveResult:=New object:C1471()
	$oProgress:=New object:C1471()
	
End if   //Done initialize

If (True:C214)  //JobForm initialize
	
	ARRAY TEXT:C222($atForm; 0)
	ARRAY TEXT:C222($atReason; 0)
	
	APPEND TO ARRAY:C911($atForm; "Job Form")
	APPEND TO ARRAY:C911($atReason; "Reason")
	
	$esJobForms:=ds:C1482.Job_Forms.all()
	
	$nNumberOfLoops:=$esJobForms.length
	
	$oProgress.nProgressID:=Prgr_NewN
	
	$oProgress.nNumberOfLoops:=$nNumberOfLoops
	$oProgress.tTitle:="Fixing notes in Job_Forms"
	
	$bProgress:=True:C214
	
	$nLoop:=0
	
End if   //Done jobForm initialize

For each ($eJobForm; $esJobForms) While ($bProgress)  //JobForm
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$nLoop:=$nLoop+1
		
		$oProgress.nLoop:=$nLoop
		$oProgress.tMessage:=CorektBlank
		
		Prgr_Message($oProgress)
		
		$tNotes:=$eJobForm.Notes
		
		$nOriginalLength:=Length:C16($tNotes)
		
		$tNotes:=Core_Text_RemoveT($tNotes; ->$atStripCharacter; 5)
		$tNotes:=Core_Text_RemoveGremlinsT($tNotes)
		
		$nStrippedLength:=Length:C16($tNotes)
		
		$eJobForm.Notes:=$tNotes
		
		$nDifference:=($nOriginalLength-$nStrippedLength)
		
		$oSaveResult:=$eJobForm.save()
		
		Case of   //Difference
				
			: (Not:C34($oSaveResult.success))
				
				APPEND TO ARRAY:C911($atForm; $eJobForm.JobFormID)
				APPEND TO ARRAY:C911($atReason; $oSaveResult)
				
			: (($nDifference<0) | ($nDifference>20))
				
				APPEND TO ARRAY:C911($atForm; $eJobForm.JobFormID)
				APPEND TO ARRAY:C911($atReason; String:C10($nDifference)+"="+String:C10($nOriginalLength)+CorektDash+String:C10($nStrippedLength))
				
			Else   //Everything is good
				
		End case   //Done Difference
		
	Else   //Progress canceled
		
		$bProgress:=False:C215  //Cancel loop
		
	End if   //Done progress
	
End for each   //Done jobform

Core_Array_ToDocument(->$apColumn)

Prgr_Quit($oProgress)

If (True:C214)  //EstmDfrnForms initialize
	
	ARRAY TEXT:C222($atForm; 0)
	ARRAY TEXT:C222($atReason; 0)
	
	APPEND TO ARRAY:C911($atForm; "Est. Differentials")
	APPEND TO ARRAY:C911($atReason; "Reason")
	
	$esEstmDfrnForms:=ds:C1482.Estimates_DifferentialsForms.all()
	
	$nNumberOfLoops:=$esJobForms.length
	
	$oProgress.nProgressID:=Prgr_NewN
	
	$oProgress.nNumberOfLoops:=$nNumberOfLoops
	$oProgress.tTitle:="Fixing notes in Estimates_DifferentialsForms"
	
	$bProgress:=True:C214
	
	$nLoop:=0
	
End if   //Done EstmDfrnForms initialize

For each ($eEstmDfrnForm; $esEstmDfrnForms) While ($bProgress)  //EstmDfrnForms
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$nLoop:=$nLoop+1
		
		$oProgress.nLoop:=$nLoop
		$oProgress.tMessage:=CorektBlank
		
		Prgr_Message($oProgress)
		
		$tNotes:=$eEstmDfrnForm.Notes
		
		$nOriginalLength:=Length:C16($tNotes)
		
		$tNotes:=Core_Text_RemoveT($tNotes; ->$atStripCharacter; 5)
		$tNotes:=Core_Text_RemoveGremlinsT($tNotes)
		
		$nStrippedLength:=Length:C16($tNotes)
		
		$eEstmDfrnForm.Notes:=$tNotes
		
		$nDifference:=($nOriginalLength-$nStrippedLength)
		
		$oSaveResult:=$eEstmDfrnForm.save()
		
		Case of   //Difference
				
			: (Not:C34($oSaveResult.success))
				
				APPEND TO ARRAY:C911($atForm; $eEstmDfrnForm.DiffId)
				APPEND TO ARRAY:C911($atReason; $oSaveResult)
				
			: (($nDifference<0) | ($nDifference>20))
				
				APPEND TO ARRAY:C911($atForm; $eEstmDfrnForm.DiffId)
				APPEND TO ARRAY:C911($atReason; String:C10($nDifference)+"="+String:C10($nOriginalLength)+CorektDash+String:C10($nStrippedLength))
				
			Else   //Everything is good
				
		End case   //Done Difference
		
	Else   //Progress canceled
		
		$bProgress:=False:C215  //Cancel loop
		
	End if   //Done progress
	
End for each   //Done EstmDfrnForms

Core_Array_ToDocument(->$apColumn)

Prgr_Quit($oProgress)
