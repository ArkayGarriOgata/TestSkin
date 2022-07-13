//%attributes = {"publishedWeb":true}
//QA_BrowseProcedures

C_TEXT:C284($1)

If (Count parameters:C259=1)  //constructor  
	$id:=uSpawnProcess("QA_BrowseProcedures"; 64000; "Browsing Procedures"; True:C214; True:C214)
	
Else 
	SET MENU BAR:C67(<>DefaultMenu)
	$winRef:=Open form window:C675([QA_Procedures:108]; "Browser")
	
	READ ONLY:C145([QA_Procedures:108])
	READ ONLY:C145([QA_Section:109])
	DIALOG:C40([QA_Procedures:108]; "Browser")
	CLOSE WINDOW:C154($winRef)
End if 