//%attributes = {"publishedWeb":true}
If (zSort#"")
	GOTO XY:C161(10; 24)
	MESSAGE:C88("Sorting! Please Wait...        ")
	If (False:C215)
		EXECUTE FORMULA:C63("ORDER BY FORMULA(["+Table name:C256(zDefFilePtr)+"];"+zSort+")")
	Else 
		EXECUTE FORMULA:C63("ORDER BY(["+Table name:C256(zDefFilePtr)+"];"+zSort+")")
	End if 
	GOTO XY:C161(10; 24)
	MESSAGE:C88((" "*39))
	NumRecs1:=Records in selection:C76(filePtr->)
End if 