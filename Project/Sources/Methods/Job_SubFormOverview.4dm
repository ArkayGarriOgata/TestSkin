//%attributes = {}
// -------
// Method: Job_SubFormOverview   ( ) ->
// By: Mel Bohince @ 05/07/18, 10:22:49
// Description
// columns represent operation, rows represent the subforms
// ----------------------------------------------------

C_BLOB:C604($objData)
C_LONGINT:C283($pid; $blobOffset)
C_TEXT:C284($1; $2; sJobForm)
app_Log_Usage("log"; "SubformOverview"; "open")


Case of 
	: (Count parameters:C259=0)
		sJobForm:="99796.03"
		$pid:=New process:C317("Job_SubFormOverview"; <>lMidMemPart; "SubForm_Overview"; sJobForm; "init")
		
	: (Count parameters:C259=1)
		sJobForm:=$1
		$pid:=New process:C317("Job_SubFormOverview"; <>lMidMemPart; "SubForm_Overview"; sJobForm; "init")
		
	: (Count parameters:C259=2)  //fire this puppy up
		sJobForm:=$1
		
		Job_SubformsOnServer(sJobForm; ->$objData)
		
		$blobOffset:=0
		//BLOB TO VARIABLE($objData;sJobFormNetSheets;$blobOffset)
		
		BLOB TO VARIABLE:C533($objData; aSeq; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aCC; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aQtyGross; $blobOffset)
		
		BLOB TO VARIABLE:C533($objData; aSubForm; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aQtyNetSheets; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aRatio; $blobOffset)
		
		BLOB TO VARIABLE:C533($objData; aMT_SeqSF; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aMT_SeqSFqty; $blobOffset)
		
		BLOB TO VARIABLE:C533($objData; aJFM_seq; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJFM_comm; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJFM_RM; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJFM_rotation; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJFM_SF; $blobOffset)
		ARRAY BOOLEAN:C223(aJFM_Hidden; 0)
		ARRAY BOOLEAN:C223(aJFM_Hidden; Size of array:C274(aJFM_RM))
		
		BLOB TO VARIABLE:C533($objData; aJMI_item; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJMI_CPN; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJMI_SF; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJMI_HRD; $blobOffset)
		BLOB TO VARIABLE:C533($objData; aJMI_REL; $blobOffset)
		ARRAY BOOLEAN:C223(aJMI_Hidden; 0)
		ARRAY BOOLEAN:C223(aJMI_Hidden; Size of array:C274(aJMI_item))
		
		$numSubforms:=Size of array:C274(aSubForm)
		$numOperations:=Size of array:C274(aSeq)
		//columns for actuals
		ARRAY LONGINT:C221(aColumn1; 0)
		ARRAY LONGINT:C221(aColumn2; 0)
		ARRAY LONGINT:C221(aColumn3; 0)
		ARRAY LONGINT:C221(aColumn4; 0)
		ARRAY LONGINT:C221(aColumn5; 0)
		ARRAY LONGINT:C221(aColumn6; 0)
		ARRAY LONGINT:C221(aColumn7; 0)
		ARRAY LONGINT:C221(aColumn8; 0)
		ARRAY LONGINT:C221(aColumn9; 0)
		
		ARRAY LONGINT:C221(aColumn1; $numSubforms)
		ARRAY LONGINT:C221(aColumn2; $numSubforms)
		ARRAY LONGINT:C221(aColumn3; $numSubforms)
		ARRAY LONGINT:C221(aColumn4; $numSubforms)
		ARRAY LONGINT:C221(aColumn5; $numSubforms)
		ARRAY LONGINT:C221(aColumn6; $numSubforms)
		ARRAY LONGINT:C221(aColumn7; $numSubforms)
		ARRAY LONGINT:C221(aColumn8; $numSubforms)
		ARRAY LONGINT:C221(aColumn9; $numSubforms)
		
		//columns for budget
		ARRAY LONGINT:C221(bColumn1; 0)
		ARRAY LONGINT:C221(bColumn2; 0)
		ARRAY LONGINT:C221(bColumn3; 0)
		ARRAY LONGINT:C221(bColumn4; 0)
		ARRAY LONGINT:C221(bColumn5; 0)
		ARRAY LONGINT:C221(bColumn6; 0)
		ARRAY LONGINT:C221(bColumn7; 0)
		ARRAY LONGINT:C221(bColumn8; 0)
		ARRAY LONGINT:C221(bColumn9; 0)
		
		ARRAY LONGINT:C221(bColumn1; $numSubforms)
		ARRAY LONGINT:C221(bColumn2; $numSubforms)
		ARRAY LONGINT:C221(bColumn3; $numSubforms)
		ARRAY LONGINT:C221(bColumn4; $numSubforms)
		ARRAY LONGINT:C221(bColumn5; $numSubforms)
		ARRAY LONGINT:C221(bColumn6; $numSubforms)
		ARRAY LONGINT:C221(bColumn7; $numSubforms)
		ARRAY LONGINT:C221(bColumn8; $numSubforms)
		ARRAY LONGINT:C221(bColumn9; $numSubforms)
		
		For ($sf; 1; $numSubforms)  //build the rows for each subform
			For ($seq; 1; $numOperations)  //for each operation on this subform
				//calc this subform's share of the total sequence qty
				$column:=Get pointer:C304("bColumn"+String:C10($seq))
				$column->{$sf}:=Round:C94(aQtyGross{$seq}*aRatio{$sf}; -2)
				//pull in the actual if it exists
				$column:=Get pointer:C304("aColumn"+String:C10($seq))
				$seqSubForm:=String:C10(($seq*10); "000")+String:C10($sf; "00")
				$hit:=Find in array:C230(aMT_SeqSF; $seqSubForm)
				If ($hit>-1)
					$column->{$sf}:=aMT_SeqSFqty{$hit}
				Else 
					If ($sf=1)  //maybe subform not entered for this opertion, so use "#0" subform one time
						$seqSubForm:=String:C10(($seq*10); "000")+"00"
						$hit:=Find in array:C230(aMT_SeqSF; $seqSubForm)
						If ($hit>-1)
							$column->{$sf}:=aMT_SeqSFqty{$hit}
						Else 
							$column->{$sf}:=0
						End if 
					Else   //already used #0 subform
						$column->{$sf}:=0
					End if 
				End if 
			End for 
		End for 
		
		C_LONGINT:C283($winRef)
		SET MENU BAR:C67(<>DefaultMenu)
		
		$winRef:=Open form window:C675("SubformOverview"; Has full screen mode Mac:K34:20)
		SET WINDOW TITLE:C213("Subform Overview for "+sJobForm; $winRef)
		DIALOG:C40("SubformOverview")
		
		CLOSE WINDOW:C154($winRef)
		app_Log_Usage("log"; "SubformOverview"; "close")
		
End case 

If (False:C215)
	$docName:="Subform-"+sJobForm+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; "Subforms-"+sJobForm+"\r\r")
		
		SEND PACKET:C103($docRef; "Seq\t")
		For ($op; 1; Size of array:C274(aSeq))
			SEND PACKET:C103($docRef; String:C10(aSeq{$op}; "000")+"\t\t\t")
		End for   //op
		
		SEND PACKET:C103($docRef; "\rCC\t")
		
		For ($op; 1; Size of array:C274(aSeq))
			SEND PACKET:C103($docRef; aCC{$op}+"\tQtyAct\tDiff\t")
		End for   //op
		
		SEND PACKET:C103($docRef; "\rSeqNet\t")
		
		For ($op; 1; Size of array:C274(aSeq))
			SEND PACKET:C103($docRef; String:C10(aQtyGross{$op})+"\t\t\t")
		End for   //op
		
		
		
		For ($sf; 1; Size of array:C274(aSubForm))
			SEND PACKET:C103($docRef; "\rSF# "+String:C10($sf; "00")+"\t")
			
			For ($op; 1; Size of array:C274(aSeq))
				$planned:=Round:C94(aRatio{$sf}*aQtyGross{$op}; -1)
				SEND PACKET:C103($docRef; String:C10($planned)+"\t")
				//slam in the actuals:
				$hit:=Find in array:C230(aMT_SeqSF; (String:C10(aSeq{$op}; "000")+String:C10(aSubForm{$sf}; "00")))
				If ($hit>-1)
					SEND PACKET:C103($docRef; String:C10(aMT_SeqSFqty{$hit})+"\t")
				Else 
					$hit:=Find in array:C230(aMT_SeqSF; (String:C10(aSeq{$op}; "000")+"00"))
					If ($hit>-1)
						SEND PACKET:C103($docRef; String:C10(aMT_SeqSFqty{$hit})+"\t")
						aMT_SeqSFqty{$hit}:=0
						
						If (aMT_SeqSFqty{$hit}>0)
							SEND PACKET:C103($docRef; String:C10(aMT_SeqSFqty{$hit}-$planned)+"\t")  //variance
						Else 
							SEND PACKET:C103($docRef; "0\t")  //not a subform particapant
						End if 
						
					Else 
						SEND PACKET:C103($docRef; "0\t")
						SEND PACKET:C103($docRef; "0\t")  //not a subform particapant
					End if 
				End if 
				
				
				
			End for   //operation
			
		End for   //subform
		
		SEND PACKET:C103($docRef; "\r")
		
		SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		//// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
		$err:=util_Launch_External_App($docName)
	End if 
End if 


