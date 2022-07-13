//%attributes = {}
//Method:  Batch_CheckBatchRunnerSet (poRunner)
//Description:  This method sets if bBatchRunnerLoggedIn and
//.  if nBatchProcess was started
//.  if bAdministrator was logged in as

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $poRunner)
	
	C_OBJECT:C1216($oSession)
	C_TEXT:C284($tBatchProcessName)
	
	$poRunner:=$1
	
	$tBatchProcessName:="bBatch_Runner"
	
	$oSession:=New object:C1471()
	
End if   //Done Initialize

OB SET:C1220($poRunner->; "nBatchProcess"; Process number:C372($tBatchProcessName; *))

$oSession:=Get process activity:C1495(Sessions only:K5:36)  //Add this $oRunner.bNotAdministrator

OB SET:C1220($poRunner->; "bAdministrator"; ($oSession.userName="Administrator"))
