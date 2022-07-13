//(S) [CONTROL]CIDEvent'ibNew
If (User in group:C338(Current user:C182; "Purchasing"))
	ViewSetter(1; ->[Purchase_Orders_Clauses:14])
Else 
	uNotAuthorized
End if 
//EOS