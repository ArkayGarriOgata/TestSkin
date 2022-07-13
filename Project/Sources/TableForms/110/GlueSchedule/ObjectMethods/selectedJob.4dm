//•031297  mBohince  reduce selections
//• 11/7/97 cs insure input layout selection

If (aGlueListBox>0)
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Substring:C12(aJobit{aGlueListBox}; 1; 8))
	pattern_PassThru(->[Job_Forms:42])
	ViewSetter(3; ->[Job_Forms:42])
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 