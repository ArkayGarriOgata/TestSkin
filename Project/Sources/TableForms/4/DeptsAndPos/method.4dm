//(lp) [departments]DeptsandPos
C_TEXT:C284(xText)
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		xText:=""
		RELATE MANY:C262([y_accounting_departments:4]ExpenseCodes:3)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46=[y_accounting_departments:4]DepartmentID:1)
			CREATE SET:C116([Purchase_Orders_Items:12]; "Hold")
			
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "Hold")
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46=[y_accounting_departments:4]DepartmentID:1)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		End if   // END 4D Professional Services : January 2019 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; Records in selection:C76([y_accounting_departments_Expens:159]))
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					USE SET:C118("Hold")
					QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]ExpenseCode:47=[y_accounting_departments_Expens:159]ExpenseCode:1)
					$Sum:=0
					
					For ($j; 1; Records in selection:C76([Purchase_Orders_Items:12]))
						$Sum:=[Purchase_Orders_Items:12]ExtPrice:11+$Sum
					End for 
					
				Else 
					
					QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46=[y_accounting_departments:4]DepartmentID:1; *)
					QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]ExpenseCode:47=[y_accounting_departments_Expens:159]ExpenseCode:1)
					$Sum:=Sum:C1([Purchase_Orders_Items:12]ExtPrice:11)
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				$Count:=Records in selection:C76([Purchase_Orders_Items:12])
				xText:=xText+[y_accounting_departments_Expens:159]ExpenseCode:1+"  -  Hits: "+String:C10($Count)+"  -  Dollars: "+String:C10($Sum; "$###,###,##0.00")+Char:C90(13)
				NEXT RECORD:C51([y_accounting_departments_Expens:159])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_ExpenseCode; 0)
			
			
			SELECTION TO ARRAY:C260([y_accounting_departments_Expens:159]ExpenseCode:1; $_ExpenseCode)
			
			For ($i; 1; Size of array:C274($_ExpenseCode); 1)
				
				
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46=[y_accounting_departments:4]DepartmentID:1; *)
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]ExpenseCode:47=$_ExpenseCode{$i})
				$Sum:=0
				
				For ($j; 1; Records in selection:C76([Purchase_Orders_Items:12]))
					$Sum:=[Purchase_Orders_Items:12]ExtPrice:11+$Sum
				End for 
				
				$Count:=Records in selection:C76([Purchase_Orders_Items:12])
				xText:=xText+$_ExpenseCode{$i}+"  -  Hits: "+String:C10($Count)+"  -  Dollars: "+String:C10($Sum; "$###,###,##0.00")+Char:C90(13)
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
End case 
//