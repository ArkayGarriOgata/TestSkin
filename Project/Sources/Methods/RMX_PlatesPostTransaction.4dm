//%attributes = {}
// _______
// Method: RMX_PlatesPostTransaction   ( ) ->
// By: Mel Bohince @ 01/09/20, 14:27:30
// Description
// while sitting on a [Job_PlatingMaterialUsage],  [Raw_Materials_Locations] and [Raw_Materials] record, 
//  create an issue transaction for specified amount
// ----------------------------------------------------


Case of 
	: ($1="init")
		$rmCode:=$2
		$platesUsed:=$3
		$usedBy:=$4
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
		[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
		[Raw_Materials_Transactions:23]XferTime:25:=Current time:C178
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]consignment:27:=True:C214
		[Raw_Materials_Transactions:23]ModDate:17:=[Raw_Materials_Transactions:23]XferDate:3
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]Reason:5:="RMX_postPlates"
		
		[Raw_Materials_Transactions:23]ReferenceNo:14:="[JPM]rec#: "+String:C10(Record number:C243([Job_PlatingMaterialUsage:175]))  // Modified by: Mel Bohince (12/6/17) save rec number in rmx record
		
		[Raw_Materials_Transactions:23]JobForm:12:=Substring:C12([Job_PlatingMaterialUsage:175]JobSequence:2; 1; 8)
		[Raw_Materials_Transactions:23]Sequence:13:=Num:C11(Substring:C12([Job_PlatingMaterialUsage:175]JobSequence:2; 10; 3))
		[Raw_Materials_Transactions:23]CostCenter:19:=[Job_PlatingMaterialUsage:175]CostCenter:17
		
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$rmCode
		//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=[Raw_Materials_Transactions]Raw_Matl_Code)// done above
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26
		[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials:21]CompanyID:27
		[Raw_Materials_Transactions:23]DepartmentID:21:=[Raw_Materials:21]DepartmentID:28
		[Raw_Materials_Transactions:23]ExpenseCode:26:="1245"
		[Raw_Materials_Transactions:23]Qty:6:=$platesUsed*-1
		
		If ($rmCode="PH77144") | ($usedBy="Cyrel")  // Modified by: Mel Bohince (9/6/19) change to data based control add Cyrel
			[Raw_Materials_Transactions:23]viaLocation:11:=[Raw_Materials_Locations:25]Location:2  // Modified by: Mel Bohince (2/9/18) don't treat PH77144 as a consignment item
		Else 
			[Raw_Materials_Transactions:23]viaLocation:11:="Consignment"
		End if 
		
		[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19  //this is a short cut
		[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Locations:25]ActCost:18
		[Raw_Materials_Transactions:23]ActExtCost:10:=[Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Locations:25]ActCost:18
		
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
End case 

