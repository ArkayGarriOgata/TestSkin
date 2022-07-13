//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/10/06, 13:15:31
// ----------------------------------------------------
// Method: RMG_getDepartmentAndExpenseCode
// Parameters comkey and pointers to dept and expense fields
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_POINTER:C301($2; $3)

$0:=False:C215

READ ONLY:C145([Raw_Materials_Groups:22])
SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Raw_Materials_Groups:22])>0)
	$0:=True:C214
	If (Length:C16($2->)<4)
		$2->:=[Raw_Materials_Groups:22]DepartmentID:22
	End if 
	$3->:=[Raw_Materials_Groups:22]GL_Expense_Code:25
	REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	
Else 
	//$2->:=""`leave the users department selection
	$3->:=""
End if 