
If (Records in set:C195("UserSet")=0)  //bSelect button from selectionList layout
	ALERT:C41("You did not highlite any records. Please try again.")
Else 
	COPY SET:C600("UserSet"; "UserSelected")
	DIFFERENCE:C122("CurrentSet"; "UserSelected"; "CurrentSet")
	CLEAR SET:C117("UserSelected")
	//•04/14/99 MLB End Modification
	USE SET:C118("CurrentSet")
End if 

CREATE SET:C116(Current form table:C627->; "◊LastSelection"+String:C10(Table:C252(Current form table:C627)))
SET WINDOW TITLE:C213(fNameWindow(Current form table:C627))