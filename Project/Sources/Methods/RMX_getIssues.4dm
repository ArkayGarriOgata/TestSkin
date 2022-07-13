//%attributes = {}
// _______
// Method: RMX_getIssues   ( jobform; seq; rmcode) -> actual qty
// By: Mel Bohince @ 06/22/21, 14:52:05
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($priorTransactions_es)
C_REAL:C285($0)
C_TEXT:C284($1; $2)
C_LONGINT:C283($3)

$priorTransactions_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Raw_Matl_Code = :2 and Sequence = :3"; $1; $2; $3)

If ($priorTransactions_es.length>0)
	$0:=$priorTransactions_es.sum("Qty")*-1
	
Else 
	$0:=0
End if 