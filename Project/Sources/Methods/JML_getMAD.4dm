//%attributes = {}
// Method: JML_getMAD () -> 
// ----------------------------------------------------
// by: mel: 08/05/04, 17:23:18
// ----------------------------------------------------
// Description:
// return MAD or REV date if avail
// Updates:
// • mel (8/24/04, 11:21:01) only use the "HRD", aka MAD
// ----------------------------------------------------

C_DATE:C307($0)
C_TEXT:C284($1; $jobform)

If (Count parameters:C259=1)
	$jobform:=$1
Else 
	$jobform:=[Job_Forms_Master_Schedule:67]JobForm:4
End if 

If ($jobform#[Job_Forms_Master_Schedule:67]JobForm:4)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
End if 

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)  // • mel (9/7/04, 16:27:07)
	$0:=[Job_Forms_Master_Schedule:67]MAD:21
	
Else 
	$0:=!00-00-00!
End if 