//%attributes = {"publishedWeb":true}
//(p) DeptandPos
//print a report for Fred to see hits against various Departments/POs
//2/12/98 cs created

ALL RECORDS:C47([y_accounting_departments:4])

FORM SET OUTPUT:C54([y_accounting_departments:4]; "DeptsAndPos")
util_PAGE_SETUP(->[y_accounting_departments:4]; "DeptsAndPos")
PRINT SETTINGS:C106

If (OK=1)
	ORDER BY:C49([y_accounting_departments:4]; [y_accounting_departments:4]DepartmentID:1; >)
	PRINT SELECTION:C60([y_accounting_departments:4]; *)
End if 
FORM SET OUTPUT:C54([y_accounting_departments:4]; "List")