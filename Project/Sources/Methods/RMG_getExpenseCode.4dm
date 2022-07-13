//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 02/09/06, 16:01:18
// ----------------------------------------------------
// Method: RMG_getExpenseCode(commodityKey)
// Description
// return the current ExpenseCode for a commodity
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($0; $2)

$0:=""

If (Count parameters:C259=1)
	READ ONLY:C145([Raw_Materials_Groups:22])
End if 

SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$1)
If (Records in selection:C76([Raw_Materials_Groups:22])>0)
	$0:=[Raw_Materials_Groups:22]GL_Expense_Code:25
	If (Count parameters:C259=1)
		REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	End if 
End if 

SET QUERY LIMIT:C395(0)