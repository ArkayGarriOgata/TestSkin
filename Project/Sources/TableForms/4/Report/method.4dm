Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		xText:=""
		uClearSelection(->[y_accounting_dept_commodities:89])
		RELATE MANY:C262([y_accounting_departments:4]DepartmentID:1)  //get commodities
		SELECTION TO ARRAY:C260([y_accounting_dept_commodities:89]CommodityCode:1; $Codes; [y_accounting_dept_commodities:89]CommDesc:3; $Desc)
		RELATE MANY:C262([y_accounting_departments:4]ExpenseCodes:3)
		ORDER BY:C49([y_accounting_departments_Expens:159]; [y_accounting_departments_Expens:159]ExpenseCode:1; >)
		SORT ARRAY:C229($Codes; $Desc; >)
		$Recs:=Records in selection:C76([y_accounting_departments_Expens:159])
		$Size:=Size of array:C274($Codes)
		
		If ($Size>$Recs)
			$Large:=$Size
		Else 
			$Large:=$Recs
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $Large)
				
				If ($i<=$Size)  //for each commodity 
					xText:=xText+String:C10($Codes{$i}; "00")+"  "+$Desc{$i}
				Else 
					xText:=xText+(6*Char:C90(9))
				End if 
				
				If ($i<=$Recs)  //for each expense code
					xText:=xText+[y_accounting_departments_Expens:159]ExpenseCode:1+"  "+[y_accounting_departments_Expens:159]Description:2+Char:C90(13)
					NEXT RECORD:C51([y_accounting_departments_Expens:159])
				Else 
					xText:=xText+Char:C90(13)
				End if 
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_ExpenseCode; 0)
			ARRAY TEXT:C222($_Description; 0)
			
			SELECTION TO ARRAY:C260([y_accounting_departments_Expens:159]ExpenseCode:1; $_ExpenseCode; [y_accounting_departments_Expens:159]Description:2; $_Description)
			
			For ($i; 1; $Large; 1)
				
				If ($i<=$Size)  //for each commodity 
					xText:=xText+String:C10($Codes{$i}; "00")+"  "+$Desc{$i}
				Else 
					xText:=xText+(6*Char:C90(9))
				End if 
				
				If ($i<=$Recs)  //for each expense code
					xText:=xText+$_ExpenseCode{$i}+"  "+$_Description{$i}+Char:C90(13)
					
				Else 
					xText:=xText+Char:C90(13)
				End if 
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
End case 