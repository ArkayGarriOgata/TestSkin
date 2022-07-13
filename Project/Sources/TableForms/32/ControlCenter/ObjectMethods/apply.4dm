// _______
// Method: [Salesmen].ControlCenter.AllRepsBtn   ( ) ->
// By: Mel Bohince @ 12/10/19, 10:28:07
// Description
// 
// ----------------------------------------------------


C_REAL:C285($pct)
C_POINTER:C301($pctPtr)

$pctPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "applyPct")
$pct:=$pctPtr->

uConfirm("Change the displayed Customers' commission rates to "+String:C10($pct)+" %"; "Change"; "Cancel")
If (ok=1)
	//[Customers]CommissionPercent
	C_OBJECT:C1216($cust_o; $status_o)
	For each ($cust_o; Form:C1466.customers)
		$cust_o.CommissionPercent:=$pct
		$status_o:=$cust_o.save(dk auto merge:K85:24)
		If (Not:C34($status_o.success))
			BEEP:C151
		End if 
		
	End for each 
	
	Form:C1466.customers:=Form:C1466.customers
	
End if   //ok

