Case of 
	: (Form event code:C388=On Load:K2:1)
		rb1:=1  //cartons
		rb2:=0  //sheets
		sBudget:="cartons"
		iTotalQty:=0
		[Raw_Materials_Transactions:23]CommodityCode:24:=1
		[Raw_Materials_Transactions:23]Commodity_Key:22:="01-Semi-Finished"
		[Raw_Materials_Transactions:23]CompanyID:20:="2"
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:="will-be-jobseq"
		[Raw_Materials_Transactions:23]ExpenseCode:26:="1240"
		[Raw_Materials_Transactions:23]Location:15:="Scrap"
		[Raw_Materials_Transactions:23]viaLocation:11:="WIP"
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
		[Raw_Materials_Transactions:23]Xfer_Type:2:="iSSue"
		[Raw_Materials_Transactions:23]Reason:5:="Defect"  //assigned by popup
		[Raw_Materials_Transactions:23]ReferenceNo:14:="n/a"  //assigned by popup
		hlCategoryTypes:=CAR_BuildReasonList("init")
		
	: (Form event code:C388=On Validate:K2:3)
		//disable costing portion until impact study
		$ActExtCost:=Round:C94(([Raw_Materials_Transactions:23]Qty:6/iTotalQty)*[Job_Forms:42]Pld_CostTtl:14; 2)
		$ActCost:=Round:C94($ActExtCost/[Raw_Materials_Transactions:23]Qty:6; 4)
		[Raw_Materials_Transactions:23]ActExtCost:10:=0
		[Raw_Materials_Transactions:23]ActCost:9:=0
		[Raw_Materials_Transactions:23]consignment:27:=False:C215
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]DepartmentID:21:=txt_Pad([Raw_Materials_Transactions:23]CostCenter:19; "0"; 1; 4)
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]JobForm:12+"."+String:C10([Raw_Materials_Transactions:23]Sequence:13; "000")
		[Raw_Materials_Transactions:23]POItemKey:4:="A"+[Raw_Materials_Transactions:23]JobForm:12
		[Raw_Materials_Transactions:23]POQty:8:=[Raw_Materials_Transactions:23]Qty:6
		[Raw_Materials_Transactions:23]ReceivingNum:23:=0
		[Raw_Materials_Transactions:23]ReferenceNo:14:="Waste-"+[Raw_Materials_Transactions:23]ReferenceNo:14
		[Raw_Materials_Transactions:23]UnitPrice:7:=$ActCost
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		REDUCE SELECTION:C351([Cost_Centers:27]; 0)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
