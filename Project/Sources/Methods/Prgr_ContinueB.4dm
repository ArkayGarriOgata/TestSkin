//%attributes = {}
//Method:  Prgr_ContinueB(oProgress)=>bContinue
//Description:  This method checks if the user stopped the progress

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oProgress)
	
	C_BOOLEAN:C305($0; $bContinue)
	
	$oProgress:=$1
	
	$bContinue:=False:C215
	
	$bContinue:=Not:C34(Progress Stopped($oProgress.nProgressID))
	
End if   //Done Initialize

$0:=$bContinue