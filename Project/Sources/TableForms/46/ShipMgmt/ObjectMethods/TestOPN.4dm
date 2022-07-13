// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.TestOPN   ( ) ->
// By: Mel Bohince @ 06/04/21, 15:34:50
// Description
// find the last time an OPN was loaded, limit to 2 week look back
// ----------------------------------------------------
C_DATE:C307($checkDate; $limitDate)
C_OBJECT:C1216($es)

$checkDate:=Current date:C33
$limitDate:=Add to date:C393($checkDate; 0; 0; -14)

Repeat 
	zwStatusMsg("LastOPN"; "Checking "+String:C10($checkDate; Internal date short special:K1:4))
	
	$es:=ds:C1482.Customers_ReleaseSchedules.query("Milestones.OPN = :1"; String:C10($checkDate; Internal date short special:K1:4))
	If ($es.length=0)
		$checkDate:=Add to date:C393($checkDate; 0; 0; -1)
	End if 
Until ($es.length>0) | ($checkDate<$limitDate)

If ($es.length>0)
	ALERT:C41("Last OPN was loaded on "+String:C10($checkDate; Internal date short special:K1:4))
	
	Form:C1466.listBoxEntities:=$es
	
	Release_ShipMgmt_calcFooters
	
Else 
	ALERT:C41("OPN hasn't been loaded for two week.")
End if 


//USE ENTITY SELECTION($es)