//%attributes = {"publishedWeb":true}
//gDepartmentsDel: Deletion for [Departments]
//• 9/19/97 cs renamd from help, rewritten for new table use

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46=[y_accounting_departments:4]DepartmentID:1)
If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	ALERT:C41("There are items in the Purchase order file which reference this department."+Char:C90(13)+"You may not delete this Department.")
	fDelete:=False:C215
Else 
	fDelete:=True:C214
End if 

If (fDelete)
	RELATE MANY:C262([y_accounting_departments:4]DepartmentID:1)
	If (gDeleteRecord(->[y_accounting_departments:4]))
		DELETE SELECTION:C66([y_accounting_dept_commodities:89])
		UpdateDeptList  //recreate the department lists 
	End if 
End if 