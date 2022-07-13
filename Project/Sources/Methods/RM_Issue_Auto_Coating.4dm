//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/04/15, 11:47:40
// ----------------------------------------------------
// Method: RM_Issue_Auto_Coating
// Description
// based on RM_Issue_Auto_Ink
//
// ----------------------------------------------------
// Modified by: Mel Bohince (6/7/18) don't create issue rec if zero rev

//set flags for running on server
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
ONE RECORD SELECT:C189([zz_control:1])
<>Auto_Coating_Percent:=[zz_control:1]Auto_Coating_Percent:63
UNLOAD RECORD:C212([zz_control:1])

If (<>Auto_Coating_Percent>0)
	//utl_Logfile ("AutoCoating.log";[Job_Forms]JobFormID+" Request: "+String(<>Auto_Coating_Percent)+"% of selling price")
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Commodity_Key:22="03@")  //"02-AutoInk"
	If (Records in selection:C76([Raw_Materials_Transactions:23])=0)  //create one
		$highest_posible_rev:=Round:C94(JOB_SellingPriceTotal([Job_Forms:42]JobFormID:5); 2)
		If ($highest_posible_rev>0)  // Modified by: Mel Bohince (6/7/18) don't create issue rec if zero rev
			CREATE RECORD:C68([Raw_Materials_Transactions:23])  //• 6/22/98 cs start
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:="AutoIssueCoating"
			[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]JobForm:12:=[Job_Forms:42]JobFormID:5
			
			[Raw_Materials_Transactions:23]Location:15:="WIP"
			[Raw_Materials_Transactions:23]DepartmentID:21:="9999"
			[Raw_Materials_Transactions:23]ExpenseCode:26:="1244"
			[Raw_Materials_Transactions:23]CompanyID:20:="1"
			[Raw_Materials_Transactions:23]viaLocation:11:="Backflush"
			[Raw_Materials_Transactions:23]Qty:6:=-1
			//$highest_posible_rev:=Round(JOB_SellingPriceTotal ([Job_Forms]JobFormID);2)
			[Raw_Materials_Transactions:23]ReferenceNo:14:=String:C10($highest_posible_rev)
			[Raw_Materials_Transactions:23]ActExtCost:10:=($highest_posible_rev*<>Auto_Coating_Percent)*[Raw_Materials_Transactions:23]Qty:6
			//utl_Logfile ("AutoCoating.log";"   "+[Job_Forms]JobFormID+"  "+String($highest_posible_rev)+" revenue results in "+String(($highest_posible_rev*<>Auto_Coating_Percent))+" calc'd cost")
			[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Transactions:23]ActExtCost:10
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]Commodity_Key:22:="03-AutoCoating"
			[Raw_Materials_Transactions:23]CommodityCode:24:=3
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
		Else 
			//utl_Logfile ("AutoInk.log";"   "+[Job_Forms]JobFormID+"  zero rev calculated")
		End if   //$highest_posible_rev
	Else 
		//utl_Logfile ("AutoCoating.log";"   "+[Job_Forms]JobFormID+"  already auto-issued")
	End if 
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22; >; [Raw_Materials_Transactions:23]XferDate:3; >)
	COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
	
Else 
	//utl_Logfile ("AutoCoating.log";[Job_Forms]JobFormID+" Manual")
End if 