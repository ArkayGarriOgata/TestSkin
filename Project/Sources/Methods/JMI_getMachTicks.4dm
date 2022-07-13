//%attributes = {}
// -------
// Method: JMI_getMachTicks   ( ) ->
// By: Mel Bohince @ 09/30/16, 06:49:40
// Description
// sum the mach tickets for a jobit
// ----------------------------------------------------

C_LONGINT:C283($0; $qty)
C_TEXT:C284($1)

$qty:=0
If (Count parameters:C259=1)
	$jobit:=$1
Else 
	$jobit:=[Job_Forms_Items:44]Jobit:4
End if 

QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=$jobit; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Good_Units:8>0)

If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
	$qty:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
End if 

$0:=$qty
