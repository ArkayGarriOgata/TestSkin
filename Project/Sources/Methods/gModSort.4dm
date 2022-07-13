//%attributes = {"publishedWeb":true}
//(P) gModSort: Sort records based on defined sort variable zSort

If (zSort#"")
	//uCenterWindow (150;39;1;"")
	Open window:C153(20; 50; 220; 89; 1; "")
	MESSAGE:C88(Char:C90(13)+"Sorting! Please Wait...")
	Case of 
		: (fAutoOne)
			SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		: (fAutoMany)
			SET AUTOMATIC RELATIONS:C310(False:C215; True:C214)
		: (fAutoBoth)
			SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
	End case 
	If (fSortxForm)
		EXECUTE FORMULA:C63("SORT BY FORMULA(["+Table name:C256(zDefFilePtr)+"];"+zSort+")")
	Else 
		EXECUTE FORMULA:C63("SORT SELECTION(["+Table name:C256(zDefFilePtr)+"];"+zSort+")")
	End if 
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	CLOSE WINDOW:C154
End if 