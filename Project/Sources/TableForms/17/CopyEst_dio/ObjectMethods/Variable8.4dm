If (rb1=1)  //kepp old job
	$Text:=" Keeping the Estimate's Current Job Number?"
Else   //new job number
	$Text:=" Creating a New Job Number?"
End if 
If (sb1=1)
	$Text2:=" RFQ Only "
Else 
	$Text2:=" Entire Estimate "
End if 
BEEP:C151
CONFIRM:C162("Are You Sure You Want to Copy the"+$Text2+"for Estimate Number: "+sCriterion1+$Text; "Copy"; "Cancel")
If (OK=1)
	sCopyEstimate
	ACCEPT:C269
End if 
//