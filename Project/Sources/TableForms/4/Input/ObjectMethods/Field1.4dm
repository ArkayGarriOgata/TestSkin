//(s) [DeptCommLink]DepartmentID
//• 10/27/97 cs code to validate entry
If (Position:C15("_"; Self:C308->)>0) | (Position:C15(" "; Self:C308->)>0)
	ALERT:C41("Entered Department code is invalid, Please re-enter.")
	GOTO OBJECT:C206(Self:C308->)
Else 
	RELATE MANY:C262([y_accounting_departments:4]DepartmentID:1)
End if 
