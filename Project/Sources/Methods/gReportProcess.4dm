//%attributes = {"publishedWeb":true}
//(P) gGraphProcess: graphing in its own process 

zDefFilePtr:=Current form table:C627
If (uSelectFile)  //Choose file
	If (rbSearchEd=1)
		SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
		QUERY:C277(zDefFilePtr->)  //present editor for the default file
	Else 
		ALL RECORDS:C47(zDefFilePtr->)
	End if 
	gReport
End if 