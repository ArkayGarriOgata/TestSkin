$itemPosition:=Selected list items:C379(<>hlFiles)
GET LIST ITEM:C378(<>hlFiles; $itemPosition; $tableNumber; $tableName)
If ($tableNumber>0)
	zDefFilePtr:=Table:C252($tableNumber)  //•051496  MLB  
	<>FilePtr:=zDefFilePtr
	READ ONLY:C145(zDefFIleptr->)  //try to stop self record locking problem
	DEFAULT TABLE:C46(zDefFilePtr->)
	FORM SET OUTPUT:C54(zDefFilePtr->; "List")
	
	If (Form event code:C388=On Double Clicked:K2:5)
		ACCEPT:C269
	End if 
	
Else 
	BEEP:C151
End if 
