//%attributes = {}
// -------
// Method: FGX_getReceipts   ( ) ->
// By: Mel Bohince @ 01/25/19, 16:41:58
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $jobit)
C_LONGINT:C283($0; $ttlReceipts)
$jobit:=$1

Begin SQL
	select sum(qty)
	from Finished_Goods_Transactions
	where XactionType='Receipt' and jobit = :$jobit
	into :$ttlReceipts
End SQL

$0:=$ttlReceipts