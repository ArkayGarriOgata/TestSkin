//%attributes = {}
// _______
// Method: FGX_extendCost   ( fgx_es; jobitCostDictionary) -> extended cost
// By: MelvinBohince @ 05/17/22, 09:38:05
// Description
// given a jobit cost dictionary, extend it by the qty's in the a fgx entity selection
// ----------------------------------------------------

C_OBJECT:C1216($fgx_es; $1; $jobit_o; $costDictionary_o; $2)
C_COLLECTION:C1488($invoiceJobits_c)
C_REAL:C285($0; $costExtended)

If (Count parameters:C259>0)
	$fgx_es:=$1
	$costDictionary_o:=$2
Else 
	$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("JobForm = :1 and XactionType = :2"; "18378.01"; "ship")
	$costDictionary_o:=New object:C1471
	$costDictionary_o["18378.01.01"]:=100
	$costDictionary_o["18378.01.04"]:=200
	$costDictionary_o["18378.01.06"]:=300
End if 

//for each jobit that shipped, find the sum of its extended cost 

$costExtended:=0

For each ($jobit_o; $fgx_es)  //sum of the cost times qty shipped
	$costExtended:=$costExtended+(($jobit_o.Qty/1000)*$costDictionary_o[$jobit_o.Jobit])
End for each 

$0:=Round:C94($costExtended; 2)

If (Count parameters:C259=0)  //assert
	ALERT:C41(Choose:C955($costExtended=11520; "Success"; "Fail"))
End if 

//$invoiceJobits_c:=$fgx_es.toCollection("Jobit, Qty")
//For each ($jobit_o;$invoiceJobits_c)  //sum of the cost times qty shipped
//$costExtended:=$costExtended+(($jobit_o.Qty/1000)*$costDictionary_o[$jobit_o.Jobit])
//End for each 
