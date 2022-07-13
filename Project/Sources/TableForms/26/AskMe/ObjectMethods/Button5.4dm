$selectionSetName:="Job_Forms_Items"
UNLOAD RECORD:C212([Job_Forms_Items:44])
CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdNamedSelectionBefore")

USE SET:C118($selectionSetName)
CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdNamedSelectionFG")
CUT NAMED SELECTION:C334([Finished_Goods_Transactions:33]; "holdNamedSelectionX")

If ([Job_Forms_Items:44]ProductCode:3=sCPN)
	FG_ChkInventoryBal([Job_Forms_Items:44]Jobit:4)
	
Else 
	BEEP:C151
End if 

USE NAMED SELECTION:C332("holdNamedSelectionBefore")
USE NAMED SELECTION:C332("holdNamedSelectionFG")
USE NAMED SELECTION:C332("holdNamedSelectionX")