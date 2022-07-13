//•031297  mBohince  reduce selections
//• 11/7/97 cs insure input layout selection

If (aGlueListBox>0)
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=Substring:C12(aJobit{aGlueListBox}; 1; 8))
	pattern_PassThru(->[Job_Forms_Master_Schedule:67])
	ViewSetter(2; ->[Job_Forms_Master_Schedule:67])
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 