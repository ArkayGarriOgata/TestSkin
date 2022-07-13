//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:36:53
// ----------------------------------------------------
// Method: trigger_JobFormItemsCosts()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Items_Costs:92]Jobit:3:=JMI_makeJobIt([Job_Forms_Items_Costs:92]JobForm:1; [Job_Forms_Items_Costs:92]ItemNumber:2)
		
		[Job_Forms_Items_Costs:92]AllocatedBurden:6:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedBurden:6)
		[Job_Forms_Items_Costs:92]AllocatedLabor:5:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedLabor:5)
		[Job_Forms_Items_Costs:92]AllocatedMaterial:4:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedMaterial:4)
		[Job_Forms_Items_Costs:92]AllocatedQuantity:14:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedQuantity:14)
		[Job_Forms_Items_Costs:92]AllocatedTotal:7:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedTotal:7)
		
		[Job_Forms_Items_Costs:92]RemainingBurden:11:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingBurden:11)
		[Job_Forms_Items_Costs:92]RemainingLabor:10:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingLabor:10)
		[Job_Forms_Items_Costs:92]RemainingMaterial:9:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingMaterial:9)
		[Job_Forms_Items_Costs:92]RemainingQuantity:15:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingQuantity:15)
		[Job_Forms_Items_Costs:92]RemainingTotal:12:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingTotal:12)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Items_Costs:92]AllocatedBurden:6:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedBurden:6)
		[Job_Forms_Items_Costs:92]AllocatedLabor:5:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedLabor:5)
		[Job_Forms_Items_Costs:92]AllocatedMaterial:4:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedMaterial:4)
		[Job_Forms_Items_Costs:92]AllocatedQuantity:14:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedQuantity:14)
		[Job_Forms_Items_Costs:92]AllocatedTotal:7:=NaNtoZero([Job_Forms_Items_Costs:92]AllocatedTotal:7)
		
		[Job_Forms_Items_Costs:92]RemainingBurden:11:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingBurden:11)
		[Job_Forms_Items_Costs:92]RemainingLabor:10:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingLabor:10)
		[Job_Forms_Items_Costs:92]RemainingMaterial:9:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingMaterial:9)
		[Job_Forms_Items_Costs:92]RemainingQuantity:15:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingQuantity:15)
		[Job_Forms_Items_Costs:92]RemainingTotal:12:=NaNtoZero([Job_Forms_Items_Costs:92]RemainingTotal:12)
End case 