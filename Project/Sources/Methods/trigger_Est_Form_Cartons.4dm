//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/16/07, 18:06:59
// ----------------------------------------------------
// Method: trigger_Est_Form_Cartons
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Estimates_FormCartons:48]ItemCost_Per_M:6:=NaNtoZero([Estimates_FormCartons:48]ItemCost_Per_M:6)
		[Estimates_FormCartons:48]CostMatl:13:=NaNtoZero([Estimates_FormCartons:48]CostMatl:13)
		[Estimates_FormCartons:48]CostLabor:14:=NaNtoZero([Estimates_FormCartons:48]CostLabor:14)
		[Estimates_FormCartons:48]CostBurden:15:=NaNtoZero([Estimates_FormCartons:48]CostBurden:15)
		[Estimates_FormCartons:48]ItemCost_Per_M:6:=NaNtoZero([Estimates_FormCartons:48]ItemCost_Per_M:6)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Estimates_FormCartons:48]ItemCost_Per_M:6:=NaNtoZero([Estimates_FormCartons:48]ItemCost_Per_M:6)
		[Estimates_FormCartons:48]CostMatl:13:=NaNtoZero([Estimates_FormCartons:48]CostMatl:13)
		[Estimates_FormCartons:48]CostLabor:14:=NaNtoZero([Estimates_FormCartons:48]CostLabor:14)
		[Estimates_FormCartons:48]CostBurden:15:=NaNtoZero([Estimates_FormCartons:48]CostBurden:15)
		[Estimates_FormCartons:48]ItemCost_Per_M:6:=NaNtoZero([Estimates_FormCartons:48]ItemCost_Per_M:6)
		
End case 