//%attributes = {"publishedWeb":true}
//(p) ExpCodeListBld
//assumes that the current record in the department table is correct
//based on code initially designed for the PO system
//extracted to its own code for use in other locations where
//a list of expense codes is needed
//• 6/22/98 cs created

ARRAY TEXT:C222(aExpCode; 0)

If (Records in selection:C76([y_accounting_departments:4])=1)  //a department has been setup
	RELATE MANY:C262([y_accounting_departments:4]ExpenseCodes:3)
	$Count:=Records in selection:C76([y_accounting_departments_Expens:159])
	
	If ($Count>0)  //ther are some expencse codes setup
		ARRAY TEXT:C222(aExpCode; $Count)
		//build expense codes from subrecords
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $Count)
				aExpCode{$i}:=[y_accounting_departments_Expens:159]ExpenseCode:1+" - "+[y_accounting_departments_Expens:159]Description:2
				NEXT RECORD:C51([y_accounting_departments_Expens:159])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_ExpenseCode; 0)
			ARRAY TEXT:C222($_Description; 0)
			
			SELECTION TO ARRAY:C260([y_accounting_departments_Expens:159]ExpenseCode:1; $_ExpenseCode; [y_accounting_departments_Expens:159]Description:2; $_Description)
			
			For ($i; 1; $Count; 1)
				
				aExpCode{$i}:=$_ExpenseCode{$i}+" - "+$_Description{$i}
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
	Else   //no expense codes have been setup
		LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
	End if 
	
Else   //there is no departments setup
	LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
End if 