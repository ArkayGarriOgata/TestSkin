If (Records in set:C195("UserSet")#0)
	uConfirm("Are You Sure Yo Want to Delete the Selected (highlighted) Records?")
	If (OK=1)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			CREATE SET:C116([y_Customers_Name_Exclusions:76]; "Hold")
			USE SET:C118("UserSet")
			DELETE SELECTION:C66([y_Customers_Name_Exclusions:76])
			USE SET:C118("Hold")
			CLEAR SET:C117("Hold")
			
		Else 
			ARRAY LONGINT:C221($_Hold; 0)
			LONGINT ARRAY FROM SELECTION:C647([y_Customers_Name_Exclusions:76]; $_Hold)
			USE SET:C118("UserSet")
			DELETE SELECTION:C66([y_Customers_Name_Exclusions:76])
			CREATE SELECTION FROM ARRAY:C640([y_Customers_Name_Exclusions:76]; $_Hold)
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
Else 
	ALERT:C41("You MUST Select (highlight) One or More Records to Delete.")
End if 