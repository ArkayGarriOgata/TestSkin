$hit:=Find in array:C230(aExpCode; ([y_accounting_departments_Expens:159]ExpenseCode:1+"@"))
If ($hit>-1)
	[y_accounting_departments_Expens:159]Description:2:=Substring:C12(aExpCode{$hit}; 6)
End if 