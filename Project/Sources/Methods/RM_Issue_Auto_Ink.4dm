//%attributes = {}
// Method: RM_Issue_Auto_Ink ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 09/13/13, 11:18:02
// ----------------------------------------------------
// Description
// when doing closeout, add ink charge for 2.9% of selling price to rm transactions
// ----------------------------------------------------
// Modified by: Mel Bohince (6/7/18) don't create issue rec if zero rev

//set flags for running on server
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
ONE RECORD SELECT:C189([zz_control:1])
<>Auto_Ink_Issue:=([zz_control:1]InkVendorID:39="ISSUE")  // Modified by: Mel Bohince (8/23/13) 
<>Auto_Ink_Percent:=Num:C11([zz_control:1]Auto_Ink_Percent:41)
If (<>Auto_Ink_Percent<=0)
	<>Auto_Ink_Percent:=0.029
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([zz_control:1])
	
Else 
	
	// you have read only mode
	
	
End if   // END 4D Professional Services : January 2019 

If (<>Auto_Ink_Issue)
	//utl_Logfile ("AutoInk.log";[Job_Forms]JobFormID+" Request: "+String(<>Auto_Ink_Percent)+"% of selling price")
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Commodity_Key:22="02@")  //"02-AutoInk"
	If (Records in selection:C76([Raw_Materials_Transactions:23])=0)  //create one
		$highest_posible_rev:=Round:C94(JOB_SellingPriceTotal([Job_Forms:42]JobFormID:5); 2)
		If ($highest_posible_rev>0)  // Modified by: Mel Bohince (6/7/18) 
			CREATE RECORD:C68([Raw_Materials_Transactions:23])  //• 6/22/98 cs start
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:="AutoIssueInk"
			[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]JobForm:12:=[Job_Forms:42]JobFormID:5
			
			[Raw_Materials_Transactions:23]Location:15:="WIP"
			[Raw_Materials_Transactions:23]DepartmentID:21:="9999"
			[Raw_Materials_Transactions:23]ExpenseCode:26:="1242"
			[Raw_Materials_Transactions:23]CompanyID:20:="1"
			[Raw_Materials_Transactions:23]viaLocation:11:="Backflush"
			[Raw_Materials_Transactions:23]Qty:6:=-1
			//$highest_posible_rev:=Round(JOB_SellingPriceTotal ([Job_Forms]JobFormID);2)
			[Raw_Materials_Transactions:23]ReferenceNo:14:=String:C10($highest_posible_rev)
			[Raw_Materials_Transactions:23]ActExtCost:10:=($highest_posible_rev*<>Auto_Ink_Percent)*[Raw_Materials_Transactions:23]Qty:6
			//utl_Logfile ("AutoInk.log";"   "+[Job_Forms]JobFormID+"  "+String($highest_posible_rev)+" revenue results in "+String(($highest_posible_rev*<>Auto_Ink_Percent))+" calc'd cost")
			[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Transactions:23]ActExtCost:10
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]Commodity_Key:22:="02-AutoInk"
			[Raw_Materials_Transactions:23]CommodityCode:24:=2
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
		Else 
			//utl_Logfile ("AutoInk.log";"   "+[Job_Forms]JobFormID+"  zero rev calculated")
		End if   //$highest_posible_rev
	Else 
		//utl_Logfile ("AutoInk.log";"   "+[Job_Forms]JobFormID+"  already auto-issued")
	End if 
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22; >; [Raw_Materials_Transactions:23]XferDate:3; >)
	COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
	
Else 
	//utl_Logfile ("AutoInk.log";[Job_Forms]JobFormID+" Manual")
End if 