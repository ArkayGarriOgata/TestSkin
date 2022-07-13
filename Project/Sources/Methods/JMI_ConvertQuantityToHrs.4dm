//%attributes = {}
// ----------------------------------------------------
// Method: JMI_ConvertQuantityToHrs   ( jobit; qty) -> hrs
// By: Mel Bohince @ 04/05/16, 08:53:38
// Description
// given a quantity from a jobit, how many hours (decimal) gluing did that take
//assuming that a single jobit is passed, wildcarded works, but may not make sense
// ----------------------------------------------------
C_REAL:C285($0; $hrs; $ttl_hrs; $hrs)
C_TEXT:C284($1; $jobit)
C_LONGINT:C283($2; $qty; $ttl_qty)
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
$hrs:=0

If (Count parameters:C259=2)
	$jobit:=$1
	$qty:=$2
	$continue:=True:C214
Else 
	$jobit:=Request:C163("Jobit:"; ""; "Ok"; "Cancel")
	If (ok=1)
		$qty:=Num:C11(Request:C163("Qty:"; "0"; "Ok"; "Cancel"))
		If (ok=1)
			$continue:=True:C214
		Else 
			$continue:=False:C215
		End if 
	Else 
		$continue:=False:C215
	End if 
End if 

If ($continue)
	//get the total gluing hrs for that jobit
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=$jobit)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		$ttl_hrs:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
		$ttl_qty:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
	Else 
		$ttl_hrs:=0
		$ttl_qty:=0
	End if 
	
	
	//return the proportion used for this qty
	If ($ttl_qty>0) & ($qty>0)
		$pct:=$qty/$ttl_qty
		$hrs:=Round:C94($ttl_hrs*$pct; 2)
		
	Else 
		$hrs:=0
	End if 
	
End if 

$0:=$hrs