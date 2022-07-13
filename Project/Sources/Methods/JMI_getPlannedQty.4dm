//%attributes = {}
// Method: JMI_getPlannedQty (product_code) -> planned want qty
// ----------------------------------------------------
// by: mel: 06/14/05, 10:23:46
// ----------------------------------------------------
// Description:
// find the qty planned to produce
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($open; $0; $i)

READ ONLY:C145([Job_Forms_Items:44])

$open:=0

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$1; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
If (Records in selection:C76([Job_Forms_Items:44])>0)
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY LONGINT:C221($aActQty; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Want:24; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aActQty)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	For ($i; 1; Size of array:C274($aQty))
		If ($aQty{$i}>$aActQty{$i})
			$open:=$open+($aQty{$i}-$aActQty{$i})
		End if 
	End for 
	
End if 

$0:=$open