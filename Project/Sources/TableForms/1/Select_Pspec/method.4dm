// ----------------------------------------------------
// User name (OS): JML
// ----------------------------------------------------
// Form Method: [zz_control].Select_Pspec
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(asDiff; 0)
	ARRAY TEXT:C222(aSelected; 0)
	ARRAY BOOLEAN:C223(ListBox1; 0)
	
	asDiff:=0
	
	SetObjectProperties(""; ->Header1; True:C214; "√")
	SetObjectProperties(""; ->Header2; True:C214; "Process Spec Id")
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	READ ONLY:C145([Process_Specs:18])
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)
	If (Records in selection:C76([Process_Specs:18])>0)
		SELECTION TO ARRAY:C260([Process_Specs:18]ID:1; asDiff)
		SORT ARRAY:C229(asDiff; >)
		asDiff:=0
		ARRAY TEXT:C222(aSelected; Size of array:C274(asDiff))
	End if   //wrong length
	REDUCE SELECTION:C351([Process_Specs:18]; 0)
End if 