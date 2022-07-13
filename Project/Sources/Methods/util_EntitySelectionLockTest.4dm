//%attributes = {}
// _______
// Method: util_EntitySelectionLockTest   ( es_to_test) -> True if free and clear
// By: Mel Bohince @ 03/08/21, 09:09:11
// Description
// see if any entities are locked in a selection
// before starting a transaction so warning 
// can be given
// see also util_EntityLocked
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_LONGINT:C283($numLocked; $innerBar; $innerLoop; $in; $winRef)
C_OBJECT:C1216($es_to_test; $1; $entity; $status_o; $formObj)
$es_to_test:=$1
$numLocked:=0
$in:=1
$innerLoop:=$es_to_test.length

$innerBar:=Progress New  //new progress bar
Progress SET BUTTON ENABLED($innerBar; False:C215)  // no stop button 
Progress SET TITLE($innerBar; "Testing for locked records... ")

For each ($entity; $es_to_test) While ($numLocked=0)
	Progress SET PROGRESS($innerBar; $in/$innerLoop)  //update the thermometer
	Progress SET MESSAGE($innerBar; String:C10($in)+"/"+String:C10($innerLoop))  //optional verbose status
	$in:=$in+1
	
	$status_o:=$entity.lock()  //make sure we can save any changes
	If (Not:C34($status_o.success))
		$numLocked:=$numLocked+1
		
		$formObj:=$status_o.lockInfo
		$formObj.message:="Record locked. CPN: "+$entity.ProductCode+"\rPO: "+$entity.CustomerRefer
		util_EntityLocked($formObj)
		
		Progress SET MESSAGE($innerBar; "locked detected")  //optional verbose status
		
	Else   //release the test lock
		$status_o:=$entity.unlock()
		If (Not:C34($status_o.success))
			ALERT:C41("Problem unlocking a record.")
		End if 
	End if 
	
End for each 
Progress QUIT($innerBar)  //remove the thermometer

$0:=($numLocked=0)
