// _______
// Method: [Customer_Portal_Extracts].LoginList.List Box2   ( ) ->
// By: phil
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/5/20) clear the right listbox if nothing selected

If (Form event code:C388=On Selection Change:K2:29)
	If (enLogin#Null:C1517)
		If (enLogin.Customers=Null:C1517)
			enLogin.Customers:=New object:C1471
		End if 
		coCustomers:=OB Get:C1224(enLogin.Customers; "List"; Is collection:K8:32)
		If (coCustomers=Null:C1517)
			coCustomers:=New collection:C1472
		End if 
		
		esUsers:=enLogin.EXTRACT_TO_LOGINS
		
		
	Else   // Modified by: Mel Bohince (3/5/20) clear the right listbox if nothing selected
		coCustomers:=New collection:C1472
		esUsers:=ds:C1482.Customer_Portal_Logins.newSelection()
	End if 
End if 


