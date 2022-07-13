//%attributes = {"publishedWeb":true}
//Method: UpdateExpenseCodeList()  042699  MLB
//why not
// Modified by: Mel Bohince (4/24/18) because in 19 you might like to know why


C_LONGINT:C283($i)
MESSAGES OFF:C175
ALL RECORDS:C47([y_accounting_expense_codes:81])
//If (<>FlexwareActive) | (<>AcctVantageActive)
SELECTION TO ARRAY:C260([y_accounting_expense_codes:81]GL_Code:3; $aId; [y_accounting_expense_codes:81]ExpenseName:2; $Desc)
//Else 
//SELECTION TO ARRAY([y_accounting_expense_codes]_future;$aId;[y_accounting_expense_codes]ExpenseName;$Desc)
//End if 
SORT ARRAY:C229($Desc; $aId; >)
ARRAY TEXT:C222($List; Size of array:C274($aId))
uClearSelection(->[y_accounting_expense_codes:81])

For ($i; 1; Size of array:C274($List))
	$List{$i}:=$aId{$i}+" "+Substring:C12($Desc{$i}; 1; 26)
End for 
//SORT ARRAY($List;>)

ARRAY TO LIST:C287($List; "ExpenseCodes")
MESSAGES ON:C181
//