//%attributes = {"publishedWeb":true}
//(P) gNoUserSet: Error message that user did not select records from selection

C_POINTER:C301($1)  //Pointer to file

If (Records in set:C195("UserSet")=0)  //bSelect button from selectionList layout
	uRejectAlert("You did not highlite a choice. Please try again.")
Else 
	USE SET:C118("UserSet")
	CREATE SET:C116($1->; "CurrentSet")
End if 