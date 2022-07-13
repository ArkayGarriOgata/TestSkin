//%attributes = {"publishedWeb":true}
//(P) uExclude: exclude highlighted records from selection
//•04/14/99  MLB  UPR 

C_POINTER:C301($1)  //Pointer to file
C_TEXT:C284($2)

If (Records in set:C195("UserSet")=0)  //bSelect button from selectionList layout
	uRejectAlert("You did not highlite a choice. Please try again.")
Else 
	//•04/14/99 MLB Begin Modification UPR 
	//USE SET("UserSet")
	COPY SET:C600("UserSet"; "UserSelected")
	DIFFERENCE:C122("CurrentSet"; "UserSelected"; "CurrentSet")
	CLEAR SET:C117("UserSelected")
	//•04/14/99 MLB End Modification
	USE SET:C118("CurrentSet")
End if 

If (Count parameters:C259=1)
	ACCEPT:C269
End if 
CREATE SET:C116($1->; "◊LastSelection"+String:C10(Table:C252($1)))
SET WINDOW TITLE:C213(fNameWindow($1))