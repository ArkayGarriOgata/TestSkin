//zoomSpec ([Jobs]ProcessSpec)  `;[JOB]CustID) pspec id is unique
//
If ([Process_Specs:18]ID:1#[Jobs:15]ProcessSpec:14)
	READ ONLY:C145([Process_Specs:18])
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Jobs:15]ProcessSpec:14)
End if 

If (Records in selection:C76([Process_Specs:18])>0)
	pattern_PassThru(->[Process_Specs:18])
	ViewSetter(3; ->[Process_Specs:18])
Else 
	BEEP:C151
End if 