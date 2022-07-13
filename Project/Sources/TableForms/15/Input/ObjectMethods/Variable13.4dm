
If ([Estimates:17]EstimateNo:1#[Jobs:15]EstimateNo:6)
	READ ONLY:C145([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Jobs:15]EstimateNo:6)
End if 

If (Records in selection:C76([Estimates:17])>0)
	pattern_PassThru(->[Estimates:17])
	ViewSetter(3; ->[Estimates:17])
Else 
	BEEP:C151
End if 


