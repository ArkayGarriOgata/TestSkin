//%attributes = {"publishedWeb":true}
//(P) uInclude: Include highlighted records only in selection
//$2 any string - suppresss accept

C_POINTER:C301($1)  //Pointer to file
C_TEXT:C284($2)

If (Records in set:C195("UserSet")=0)  //bSelect button from selectionList layout
	uRejectAlert("You did not highlite a choice. Please try again.")
Else 
	USE SET:C118("UserSet")
	CREATE SET:C116($1->; "CurrentSet")
End if 

If (Count parameters:C259=1)
	ACCEPT:C269
End if 

CREATE SET:C116($1->; "◊LastSelection"+String:C10(Table:C252($1)))
SET WINDOW TITLE:C213(fNameWindow($1))