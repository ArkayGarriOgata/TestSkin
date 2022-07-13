//(lp) [departments]Input

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		ARRAY TEXT:C222(aCommCode; 0)
		ARRAY TEXT:C222(aExpCode; 0)
		LIST TO ARRAY:C288("CommCodes"; aCommCode)
		LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
		
		RELATE MANY:C262([y_accounting_departments:4]DepartmentID:1)
		RELATE MANY:C262([y_accounting_departments:4]ExpenseCodes:3)
		
		ORDER BY:C49([y_accounting_departments_Expens:159]; [y_accounting_departments_Expens:159]ExpenseCode:1; >)
		ORDER BY:C49([y_accounting_dept_commodities:89]; [y_accounting_dept_commodities:89]CommodityCode:1; >)
		
	: (Form event code:C388=On Validate:K2:3)
		
End case 
//