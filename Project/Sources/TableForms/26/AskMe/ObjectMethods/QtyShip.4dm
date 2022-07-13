// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/09/13, 08:14:54
// ----------------------------------------------------
// Method: [Finished_Goods].AskMe.QtyShip
// Description:
// Shows information based on which item is selected from the list below it.
// ----------------------------------------------------

$selectionSetName:="Job_Forms_Items"
If (Records in set:C195($selectionSetName)>0)
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdNamedSelectionBefore")
	
	
	USE SET:C118($selectionSetName)
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdNamedSelectionFG")
	CUT NAMED SELECTION:C334([Finished_Goods_Transactions:33]; "holdNamedSelectionX")
	
	If ([Job_Forms_Items:44]ProductCode:3=sCPN)
		FG_ChkQtyShipped([Job_Forms_Items:44]Jobit:4)
		
	Else 
		BEEP:C151
	End if 
	
	USE NAMED SELECTION:C332("holdNamedSelectionBefore")
	USE NAMED SELECTION:C332("holdNamedSelectionFG")
	USE NAMED SELECTION:C332("holdNamedSelectionX")
	
Else 
	uConfirm("Please select a Job_Forms_Item first."; "OK"; "Help")
End if 