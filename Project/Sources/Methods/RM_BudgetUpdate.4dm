//%attributes = {"publishedWeb":true}
//(p) RM_BudgetUpdate: Update [Budgets]
//•  1/2/97 - cs - upr 0235 charge code change means the 3 new fields
// must be populated,
// $2 (optional) charge code to parse
//• 1/20/98 cs moved code from 'new only' to all the time
//  updates this covers the new items that are possible from  issue screen
//• 1/28/98 cs NAN checking
//• 3/18/98 cs stop UOM from being changed from Est/Bud during issue
//• 4/10/98 cs Nan Checking
//•082402  mlb  chg default on creating allocation
//073009 mlb add locked alert, drop comm 6 add comm 12
//mlb 10/27/10 be specific about sequence number in case same rm used on multiple machines
// Modified by: Mel Bohince (1/29/14) added case stmt for 09-coldfoil/05-specialleaf, delete allocations when issued

C_TEXT:C284($ChargeCode; $2)
C_LONGINT:C283($1; $i; $locked)  // Added by: Mark Zinke (1/24/14) Added $i

If (Count parameters:C259=2)
	$ChargeCode:=$2
End if 
READ WRITE:C146([Job_Forms_Materials:55])
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=aRMJFNum{$1}; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=aRMBudItem{$1}; *)  //mlb 10/27/10
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7=aRMCode{$1})

If (Records in selection:C76([Job_Forms_Materials:55])=0)  //this should not happen any more
	CREATE RECORD:C68([Job_Forms_Materials:55])
	[Job_Forms_Materials:55]JobForm:1:=aRMJFNum{$1}
	[Job_Forms_Materials:55]Sequence:3:=aRMBudItem{$1}
	If ([Raw_Materials:21]Raw_Matl_Code:1#aRMCode{$1})
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$1})
	End if 
	[Job_Forms_Materials:55]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2
	[Job_Forms_Materials:55]Comments:4:="Non-budgeted item. Posting"  // see doReviseJob for the importance of this assignment
	[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
	[Job_Forms_Materials:55]ModWho:11:=<>zResp
	[Job_Forms_Materials:55]Raw_Matl_Code:7:=aRMCode{$1}
	SAVE RECORD:C53([Job_Forms_Materials:55])
End if 

If ([Raw_Materials:21]Raw_Matl_Code:1#[Job_Forms_Materials:55]Raw_Matl_Code:7)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
End if 

If (Records in selection:C76([Job_Forms_Materials:55])>0)
	If (Not:C34(Locked:C147([Job_Forms_Materials:55])))  //optimistic here, there is a recalc later anyway
		//mlb 10/27/10 be specific about sequence number in case same rm used on multiple machines
		//If ([Job_Forms_Materials]Sequence#aRMBudItem{$1})
		//[Job_Forms_Materials]Sequence:=aRMBudItem{$1}
		//End if 
		
		//• 1/2/97 upr 0235
		If (Count parameters:C259=2)  //if charge code avail use it
			[Job_Forms_Materials:55]CompanyId:23:=ChrgCodeParse($ChargeCode; 1)
			[Job_Forms_Materials:55]DepartmentID:24:=ChrgCodeParse($ChargeCode; 2)
			[Job_Forms_Materials:55]ExpenseCode:25:=ChrgCodeParse($ChargeCode; 3)
		End if 
		//end upr 0235  
		aRMPOQty{$1}:=uNANCheck(aRMPOQty{$1})  //• 1/28/98 cs check value for a NAN
		[Job_Forms_Materials:55]Raw_Matl_Code:7:=aRMCode{$1}
		[Job_Forms_Materials:55]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2
		
		If ([Job_Forms_Materials:55]UOM:5="")  //• 3/18/98 cs stop UOM from being changed from Est/Bud during issue
			[Job_Forms_Materials:55]UOM:5:=[Raw_Materials:21]IssueUOM:10
		End if 
		[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+aRMPOQty{$1})
		[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck(Round:C94(aRMPOQty{$1}*aRMStdPrice{$1}; 2))
		SAVE RECORD:C53([Job_Forms_Materials:55])
		UNLOAD RECORD:C212([Job_Forms_Materials:55])
	End if 
End if 


//address allocation record(s) if applicable
READ WRITE:C146([Raw_Materials_Allocations:58])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$1})

Case of   //look for the ideal of 09-coldfoil and the possiblity of an 05-special_leaf allocation` Modified by: Mel Bohince (1/29/14) 
	: (([Raw_Materials:21]CommodityCode:26=1) | ([Raw_Materials:21]CommodityCode:26=12))  //board or sensor labels
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=aRMCode{$1}; *)  //the issued rm should match the planned rm
		QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=aRMJFNum{$1})
		If (fLockNLoad(->[Raw_Materials_Allocations:58]))
			[Raw_Materials_Allocations:58]Qty_Issued:6:=[Raw_Materials_Allocations:58]Qty_Issued:6+aRMPOQty{$1}  //will still show on allocation report prefixed with a bullet •
			[Raw_Materials_Allocations:58]Date_Issued:7:=4D_Current_date
			SAVE RECORD:C53([Raw_Materials_Allocations:58])
			
		Else 
			BEEP:C151
			BEEP:C151
			ALERT:C41("Issue against the "+aRMCode{$1}+" allocation failed on form "+aRMJFNum{$1})
		End if 
		
	: (([Raw_Materials:21]CommodityCode:26=9) | ([Raw_Materials:21]CommodityCode:26=5))  //cold foil or special leaf
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]commdityKey:13="09@"; *)  //the issued rm may or may not match the planned rm
		QUERY:C277([Raw_Materials_Allocations:58];  | ; [Raw_Materials_Allocations:58]commdityKey:13="05@"; *)
		QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=aRMJFNum{$1})
		
		$locked:=util_DeleteSelection(->[Raw_Materials_Allocations:58])  //assuming cold foil is issued all at once, so no reason for allocations records to remain
		If ($locked>0)
			ALERT:C41("Issue against the "+aRMCode{$1}+" allocation failed on form "+aRMJFNum{$1}+", Delete the coldfoil allocation manually!")
		End if 
End case 
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
