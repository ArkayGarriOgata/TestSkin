Case of 
	: (<>aPopEst=3)
		<>PassThrough:=True:C214
		ALL RECORDS:C47([y_accounting_expense_codes:81])
		CREATE SET:C116([y_accounting_expense_codes:81]; "◊PassThroughSet")
		
		
		ViewSetter(3; ->[y_accounting_expense_codes:81])
	: (<>aPopEst=2)
		<>PassThrough:=True:C214
		
		ALL RECORDS:C47([y_accounting_expense_codes:81])
		CREATE SET:C116([y_accounting_expense_codes:81]; "◊PassThroughSet")
		
		
		ViewSetter(2; ->[y_accounting_expense_codes:81])
	: (<>aPopEst=1)
		ViewSetter(1; ->[y_accounting_expense_codes:81])
End case 

<>aPopEst:=0
