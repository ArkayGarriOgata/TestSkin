//%attributes = {"publishedWeb":true}
//(p) DeptList
//print alist of departmens, expense codes and commodities
//• 9/19/97 cs created

uYesNoCancel("Print All departments,"+Char:C90(13)+"Select Departments."+Char:C90(13)+"Cancel"; "All"; "Select"; "Cancel")

Case of 
	: (bNo=1)  //search
		QUERY:C277([y_accounting_departments:4])
		
		If (OK=1) & (Records in selection:C76([y_accounting_departments:4])>0)  //search OK or all records, stop if no records found
			//• 5/30/97 cs opened processes own window    
			NewWindow(500; 350; 0; 8; "Printing "+String:C10(Records in selection:C76([y_accounting_departments:4]))+" from "+"[Departments]")
			fAdHocLocal:=True:C214  //flag that this any other searching is a search dialog
			DISPLAY SELECTION:C59([y_accounting_departments:4]; *)  //• 5/30/97 cs display selected records
			CLOSE WINDOW:C154  //closes window records are displayed in
			uConfirm("Print selected records from Departments?")  //confirm print
			
			If (OK=0)  //not ok to print
				uClearSelection(->[y_accounting_departments:4])
			End if 
		End if 
	: (bAccept=1)  //all
		ALL RECORDS:C47([y_accounting_departments:4])
	Else   //cancel
		uClearSelection(->[y_accounting_departments:4])
End case 

If (Records in selection:C76([y_accounting_departments:4])>0)
	FORM SET OUTPUT:C54([y_accounting_departments:4]; "Report")
	PRINT SETTINGS:C106
	
	If (OK=1)
		xTitle:="Commodities"+(8*Char:C90(9))+"Expense Codes"
		t1:="Department Listing"
		MESSAGES OFF:C175
		RELATE MANY SELECTION:C340([y_accounting_dept_commodities:89]DepartmentID:2)  //get commoity links
		ORDER BY:C49([y_accounting_departments:4]; [y_accounting_departments:4]DepartmentID:1; >)
		PRINT SELECTION:C60([y_accounting_departments:4]; *)
		MESSAGES ON:C181
	End if 
	FORM SET OUTPUT:C54([y_accounting_departments:4]; "List")
End if 