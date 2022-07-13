//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:15:28
// ----------------------------------------------------
// Method: trigger_JobFormItems()  --> 
// ----------------------------------------------------
// Modified by: Mel Bohince (2/25/14) set complete once 80% of want is recorded
// Modified by: Mel Bohince (9/15/16) add timestamp to completed
C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Items:44]Jobit:4:=JMI_makeJobIt([Job_Forms_Items:44]JobForm:1; [Job_Forms_Items:44]ItemNumber:7)
		$err:=JIC_Create([Job_Forms_Items:44]Jobit:4)
		
		[Job_Forms_Items:44]PldCostMatl:17:=NaNtoZero([Job_Forms_Items:44]PldCostMatl:17)
		[Job_Forms_Items:44]PldCostLab:18:=NaNtoZero([Job_Forms_Items:44]PldCostLab:18)
		[Job_Forms_Items:44]PldCostOvhd:19:=NaNtoZero([Job_Forms_Items:44]PldCostOvhd:19)
		[Job_Forms_Items:44]PldCostTotal:21:=NaNtoZero([Job_Forms_Items:44]PldCostTotal:21)
		
		[Job_Forms_Items:44]PldCostS_E:20:=NaNtoZero([Job_Forms_Items:44]PldCostS_E:20)
		[Job_Forms_Items:44]ActCost_M:27:=NaNtoZero([Job_Forms_Items:44]ActCost_M:27)
		[Job_Forms_Items:44]AllocationPercent:23:=NaNtoZero([Job_Forms_Items:44]AllocationPercent:23)
		[Job_Forms_Items:44]Cost_Burd:14:=NaNtoZero([Job_Forms_Items:44]Cost_Burd:14)
		[Job_Forms_Items:44]Cost_LAB:13:=NaNtoZero([Job_Forms_Items:44]Cost_LAB:13)
		[Job_Forms_Items:44]Cost_Mat:12:=NaNtoZero([Job_Forms_Items:44]Cost_Mat:12)
		[Job_Forms_Items:44]Cost_SE:16:=NaNtoZero([Job_Forms_Items:44]Cost_SE:16)
		[Job_Forms_Items:44]FinRunStdM_Hr:28:=NaNtoZero([Job_Forms_Items:44]FinRunStdM_Hr:28)
		[Job_Forms_Items:44]Qty_Actual:11:=NaNtoZero([Job_Forms_Items:44]Qty_Actual:11)
		[Job_Forms_Items:44]Qty_Good:10:=NaNtoZero([Job_Forms_Items:44]Qty_Good:10)
		[Job_Forms_Items:44]Qty_MachTicket:36:=NaNtoZero([Job_Forms_Items:44]Qty_MachTicket:36)
		[Job_Forms_Items:44]Qty_Want:24:=NaNtoZero([Job_Forms_Items:44]Qty_Want:24)
		[Job_Forms_Items:44]Qty_Yield:9:=NaNtoZero([Job_Forms_Items:44]Qty_Yield:9)
		[Job_Forms_Items:44]SellPrice_M:25:=NaNtoZero([Job_Forms_Items:44]SellPrice_M:25)
		[Job_Forms_Items:44]SqInches:22:=NaNtoZero([Job_Forms_Items:44]SqInches:22)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Items:44]PldCostMatl:17:=NaNtoZero([Job_Forms_Items:44]PldCostMatl:17)
		[Job_Forms_Items:44]PldCostLab:18:=NaNtoZero([Job_Forms_Items:44]PldCostLab:18)
		[Job_Forms_Items:44]PldCostOvhd:19:=NaNtoZero([Job_Forms_Items:44]PldCostOvhd:19)
		[Job_Forms_Items:44]PldCostTotal:21:=NaNtoZero([Job_Forms_Items:44]PldCostTotal:21)
		
		[Job_Forms_Items:44]PldCostS_E:20:=NaNtoZero([Job_Forms_Items:44]PldCostS_E:20)
		[Job_Forms_Items:44]ActCost_M:27:=NaNtoZero([Job_Forms_Items:44]ActCost_M:27)
		[Job_Forms_Items:44]AllocationPercent:23:=NaNtoZero([Job_Forms_Items:44]AllocationPercent:23)
		[Job_Forms_Items:44]Cost_Burd:14:=NaNtoZero([Job_Forms_Items:44]Cost_Burd:14)
		[Job_Forms_Items:44]Cost_LAB:13:=NaNtoZero([Job_Forms_Items:44]Cost_LAB:13)
		[Job_Forms_Items:44]Cost_Mat:12:=NaNtoZero([Job_Forms_Items:44]Cost_Mat:12)
		[Job_Forms_Items:44]Cost_SE:16:=NaNtoZero([Job_Forms_Items:44]Cost_SE:16)
		[Job_Forms_Items:44]FinRunStdM_Hr:28:=NaNtoZero([Job_Forms_Items:44]FinRunStdM_Hr:28)
		[Job_Forms_Items:44]Qty_Actual:11:=NaNtoZero([Job_Forms_Items:44]Qty_Actual:11)
		[Job_Forms_Items:44]Qty_Good:10:=NaNtoZero([Job_Forms_Items:44]Qty_Good:10)
		[Job_Forms_Items:44]Qty_MachTicket:36:=NaNtoZero([Job_Forms_Items:44]Qty_MachTicket:36)
		[Job_Forms_Items:44]Qty_Want:24:=NaNtoZero([Job_Forms_Items:44]Qty_Want:24)
		[Job_Forms_Items:44]Qty_Yield:9:=NaNtoZero([Job_Forms_Items:44]Qty_Yield:9)
		[Job_Forms_Items:44]SellPrice_M:25:=NaNtoZero([Job_Forms_Items:44]SellPrice_M:25)
		[Job_Forms_Items:44]SqInches:22:=NaNtoZero([Job_Forms_Items:44]SqInches:22)
		
		If ([Job_Forms_Items:44]Completed:39=!00-00-00!)  // Modified by: Mel Bohince (3/27/14) running too often
			If ([Job_Forms_Items:44]Qty_Actual:11>([Job_Forms_Items:44]Qty_Want:24*0.85))  // Modified by: Mel Bohince (2/25/14) 
				[Job_Forms_Items:44]Completed:39:=4D_Current_date
				// Modified by: Mel Bohince (9/15/16) add ts
				[Job_Forms_Items:44]CompletedTimeStamp:56:=TSTimeStamp
				THC_request_update([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
			End if 
		End if 
		
	: (Trigger event:C369=On Deleting Record Event:K3:3)
		$err:=JIC_Remove([Job_Forms_Items:44]Jobit:4)
End case 