//%attributes = {}
//Methode: Prgr_Message(oProgress)
//Description:  This method will update a progresses message

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oProgress)
	C_TEXT:C284($tTitle)
	
	$oProgress:=$1
	
	$tTitle:=$oProgress.tTitle+CorektSpace+String:C10($oProgress.nLoop)+" of "+String:C10($oProgress.nNumberOfLoops)
	$tTitle:=$tTitle+CorektSpace+String:C10(100*($oProgress.nLoop/$oProgress.nNumberOfLoops); "###%")
	
End if   //Done Initialize

Progress SET TITLE($oProgress.nProgressID; $tTitle)
Progress SET PROGRESS($oProgress.nProgressID; $oProgress.nLoop/$oProgress.nNumberOfLoops)
Progress SET MESSAGE($oProgress.nProgressID; $oProgress.tMessage)
