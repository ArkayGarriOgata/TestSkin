//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/12/08, 16:43:37
// ----------------------------------------------------
// Method: JMI_getProducedQty
// ----------------------------------------------------

READ ONLY:C145([Job_Forms_Items:44])

C_TEXT:C284($1)
C_LONGINT:C283($produced; $0; $i)

$produced:=0

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$1; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
If (Records in selection:C76([Job_Forms_Items:44])>0)
	$produced:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
End if 

$0:=$produced