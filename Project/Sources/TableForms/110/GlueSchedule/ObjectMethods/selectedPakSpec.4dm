
// Method: [ProductionSchedules].GlueSchedule.selectedPakSpec ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/05/14, 12:06:07
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

If (aGlueListBox>0)
	
	READ ONLY:C145([Finished_Goods_PackingSpecs:91])
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=aOutline{aGlueListBox})
	If (Records in selection:C76([Finished_Goods_PackingSpecs:91])=1)
		SET PRINT PREVIEW:C364(True:C214)
		xText:=""
		FORM SET OUTPUT:C54([Finished_Goods_PackingSpecs:91]; "PrintForm")
		util_PAGE_SETUP(->[Finished_Goods_PackingSpecs:91]; "PrintForm")
		
		PRINT RECORD:C71([Finished_Goods_PackingSpecs:91]; *)
		
		FORM SET OUTPUT:C54([Finished_Goods_PackingSpecs:91]; "List")
		xText:=""
		SET PRINT PREVIEW:C364(False:C215)
		
	Else 
		BEEP:C151
		ALERT:C41("Sorry, no packing spec found.")
	End if 
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 