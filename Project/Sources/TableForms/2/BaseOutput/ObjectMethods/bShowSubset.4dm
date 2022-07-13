If (Records in set:C195("UserSet")=0)  //bSelect button from selectionList layout
	ALERT:C41("You did not highlite any records. Please try again.")
Else 
	USE SET:C118("UserSet")
	CREATE SET:C116(Current form table:C627->; "CurrentSet")
End if 

CREATE SET:C116(Current form table:C627->; "◊LastSelection"+String:C10(Table:C252(Current form table:C627)))
SET WINDOW TITLE:C213(fNameWindow(Current form table:C627))