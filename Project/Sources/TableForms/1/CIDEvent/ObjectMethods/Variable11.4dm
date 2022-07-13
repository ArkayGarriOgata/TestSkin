//(S) [CONTROL]CIDEvent'ibMod
If (User in group:C338(Current user:C182; "Purchasing"))
	ViewSetter(2; ->[Purchase_Orders_Clauses:14])
Else 
	uNotAuthorized
End if 
//EOS