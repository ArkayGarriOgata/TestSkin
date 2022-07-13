//%attributes = {"publishedWeb":true}
//(p) JCORmXferCreate
//based on gRMXferCreate
//used by auto issue system in Job Close Out to create issue records
//$1 - Integer sequence number
//$2 - Real qty to Issue
//$3 - Real Cost/unit of issue material
//• 1 2/3/97 cs created
//• 5/29/98 cs try to get expense and depart codes set more often
//• 7/15/98 cs more attempts to get Depsrtment & exp code set
//•120998  MLB  UPR bad polarity error

C_LONGINT:C283($1)
C_REAL:C285($2; $3)

CREATE RECORD:C68([Raw_Materials_Transactions:23])
[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
[Raw_Materials_Transactions:23]POItemKey:4:=[Purchase_Orders_Items:12]POItemKey:1
[Raw_Materials_Transactions:23]JobForm:12:=[Job_Forms:42]JobFormID:5
[Raw_Materials_Transactions:23]Sequence:13:=$1
[Raw_Materials_Transactions:23]ReferenceNo:14:="Auto Issue"
[Raw_Materials_Transactions:23]Location:15:="WIP"
[Raw_Materials_Transactions:23]CompanyID:20:="1"
[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
[Raw_Materials_Transactions:23]Commodity_Key:22:=[Job_Forms_Materials:55]Commodity_Key:12
[Raw_Materials_Transactions:23]viaLocation:11:=[Raw_Materials_Locations:25]Location:2
[Raw_Materials_Transactions:23]Qty:6:=$2
[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck($3)
[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($2*$3; 2))  //•120998  MLB  was -$2
[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" Auto Issue"+Char:C90(13)

If ([Raw_Materials:21]Raw_Matl_Code:1#[Raw_Materials_Locations:25]Raw_Matl_Code:1)
	READ ONLY:C145([Raw_Materials:21])
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Locations:25]Raw_Matl_Code:1)
End if 

If (Records in selection:C76([Raw_Materials:21])>0)
	[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
	[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
Else 
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
End if 

Case of   //• 7/15/98 cs try to get company & exp codes from PO
	: ([Purchase_Orders_Items:12]ExpenseCode:47#"")
		[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
	: ([Job_Forms_Materials:55]ExpenseCode:25="")  //• 5/29/98 cs try to get expense and depart codes set more often   
		//[RM_XFER]ExpenseCode:=[RAW_MATERIALS]ExpenseCode
	Else 
		// [RM_XFER]ExpenseCode:=[Material_Job]ExpenseCode
End case 

Case of 
	: ([Purchase_Orders_Items:12]CompanyID:45#"") & ([Purchase_Orders_Items:12]POItemKey:1#"9999999@")  //not a generic issue
		[Raw_Materials_Transactions:23]CompanyID:20:=[Purchase_Orders_Items:12]CompanyID:45
	: ([Job_Forms_Materials:55]CompanyId:23#"")
		[Raw_Materials_Transactions:23]CompanyID:20:=[Job_Forms_Materials:55]CompanyId:23
	: ([Raw_Materials_Locations:25]CompanyID:27#"")
		[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials_Locations:25]CompanyID:27
	: ([Raw_Materials:21]CompanyID:27#"")
		[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials:21]CompanyID:27
	Else   //default
		[Raw_Materials_Transactions:23]CompanyID:20:="1"
End case 
[Raw_Materials_Transactions:23]DepartmentID:21:="9999"
SAVE RECORD:C53([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Raw_Materials_Transactions:23])