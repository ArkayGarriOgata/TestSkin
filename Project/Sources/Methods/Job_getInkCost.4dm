//%attributes = {}
// Method: Job_getInkCost
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/16/13, 14:21:40
// ----------------------------------------------------

Case of 
	: ($1="bud")
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$2; *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="02@")
		If (Records in selection:C76([Job_Forms_Materials:55])>0)
			$0:=Sum:C1([Job_Forms_Materials:55]Planned_Cost:8)
		Else 
			$0:=0
		End if 
		
	: ($1="act")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$2; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=2)
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$0:=(-1*Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10))
		Else 
			$0:=0
		End if 
	Else 
		$0:=0
End case 