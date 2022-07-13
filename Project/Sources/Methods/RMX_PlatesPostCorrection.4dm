//%attributes = {}
// _______
// Method: RMX_PlatesPostCorrection   ( ) ->
// By: Mel Bohince @ 09/06/19, 11:10:24
// Description
// undo a change to a plate usage record
// ----------------------------------------------------
// Modified by: Mel Bohince (9/25/19) was not restocking qty so flip the sign
// Modified by: Mel Bohince (1/25/20) do 04@ not 04-Plates

C_LONGINT:C283($1; $platesUsed)
$platesUsed:=$1

C_TEXT:C284($2; $rmCode; $usedBy)
$usedBy:=$2

If ($platesUsed#0)  //could be + | -
	READ ONLY:C145([Raw_Materials:21])
	READ WRITE:C146([Raw_Materials_Locations:25])
	
	$platesUsed:=$platesUsed*-1  // Modified by: Mel Bohince (9/25/19) was not restocking qty
	
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="04@"; *)
	QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]UsedBy:52=$usedBy)
	If (Records in selection:C76([Raw_Materials:21])>0)
		$rmCode:=[Raw_Materials:21]Raw_Matl_Code:1
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
		[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
		[Raw_Materials_Transactions:23]XferTime:25:=Current time:C178
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]consignment:27:=True:C214
		[Raw_Materials_Transactions:23]ModDate:17:=[Raw_Materials_Transactions:23]XferDate:3
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]Reason:5:="RMX_postPlates Correction"
		
		[Raw_Materials_Transactions:23]ReferenceNo:14:="[JPM]rec#: "+String:C10(Record number:C243([Job_PlatingMaterialUsage:175]))  // Modified by: Mel Bohince (12/6/17) save rec number in rmx record
		
		[Raw_Materials_Transactions:23]JobForm:12:=Substring:C12([Job_PlatingMaterialUsage:175]JobSequence:2; 1; 8)
		[Raw_Materials_Transactions:23]Sequence:13:=Num:C11(Substring:C12([Job_PlatingMaterialUsage:175]JobSequence:2; 10; 3))
		[Raw_Materials_Transactions:23]CostCenter:19:=[Job_PlatingMaterialUsage:175]CostCenter:17
		
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$rmCode
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26
		[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials:21]CompanyID:27
		[Raw_Materials_Transactions:23]DepartmentID:21:=[Raw_Materials:21]DepartmentID:28
		[Raw_Materials_Transactions:23]ExpenseCode:26:="1245"
		
		[Raw_Materials_Transactions:23]Qty:6:=$platesUsed
		
		//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]QtyOH>0;*)  // Added by: Mel Bohince (4/15/19) 
		//QUERY([Raw_Materials_Locations]; | ;[Raw_Materials_Locations]ConsignmentQty>0;*)  // Added by: Mel Bohince (4/15/19) 
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)  // Added by: Mel Bohince (4/15/19) 
			ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)
			// Modified by: Mel Bohince (9/6/19) change to data based control add Cyrel
			If ($rmCode="PH77144") | ($usedBy="Cyrel")  // Modified by: Mel Bohince (2/9/18) don't treat PH77144 as a consignment item
				[Raw_Materials_Transactions:23]viaLocation:11:=[Raw_Materials_Locations:25]Location:2
			Else 
				[Raw_Materials_Transactions:23]viaLocation:11:="Consignment"
			End if 
			
			// Modified by: Mel Bohince (1/14/19) next 3 lines got accidentally deleted
			[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19  //this is a short cut
			[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Locations:25]ActCost:18
			[Raw_Materials_Transactions:23]ActExtCost:10:=[Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Locations:25]ActCost:18
			
		Else 
			[Raw_Materials_Transactions:23]POItemKey:4:="not found"  //this is a short cut
			[Raw_Materials_Transactions:23]ActCost:9:=0
			[Raw_Materials_Transactions:23]ActExtCost:10:=0
			[Raw_Materials_Transactions:23]viaLocation:11:="not found"
		End if 
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		
		If ($rmCode="PH77144")
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+$platesUsed
		Else 
			[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26+$platesUsed
		End if 
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		
	Else 
		$rmCode:="not-found"
	End if 
	
End if 