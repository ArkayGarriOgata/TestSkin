//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/14/17, 10:49:40
// ----------------------------------------------------
// Method: RMX_SaveFromIssueDialog
// Description
// 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (3/29/18) make sure actextcost is calc in case script didn't fire on form
//check for locked bin, allocation and jfm
// Modified by: Mel Bohince (1/14/20) lock checking done in rm transaction's trigger

[Raw_Materials_Transactions:23]Qty:6:=[Raw_Materials_Transactions:23]Qty:6*-1  //issues should be negative
[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(([Raw_Materials_Transactions:23]ActCost:9*[Raw_Materials_Transactions:23]Qty:6); 2)
ACCEPT:C269

If (False:C215)  // Modified by: Mel Bohince (1/14/20) 
	$abort:=False:C215
	
	
	LOAD RECORD:C52([Raw_Materials_Locations:25])  //this is a problem in hte trigger
	
	
	If (Not:C34(fLockNLoad(->[Raw_Materials_Locations:25])))
		$abort:=True:C214
		tText:="[Raw_Materials_Locations] record locked, try later."
		
	Else 
		Case of   //look for the ideal of 09-coldfoil and the possiblity of an 05-special_leaf allocation` Modified by: Mel Bohince (1/29/14) 
			: (([Raw_Materials_Transactions:23]CommodityCode:24=1) | ([Raw_Materials_Transactions:23]CommodityCode:24=12) | ([Raw_Materials_Transactions:23]CommodityCode:24=20))  //board or sensor labels
				QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1; *)  //the issued rm should match the planned rm
				QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=[Raw_Materials_Transactions:23]JobForm:12)
				
			: (([Raw_Materials_Transactions:23]CommodityCode:24=9) | ([Raw_Materials_Transactions:23]CommodityCode:24=5))  //cold foil or special leaf
				QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]commdityKey:13="09@"; *)  //the issued rm may or may not match the planned rm
				QUERY:C277([Raw_Materials_Allocations:58];  | ; [Raw_Materials_Allocations:58]commdityKey:13="05@"; *)
				QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]JobForm:3=[Raw_Materials_Transactions:23]JobForm:12)
				
			Else 
				REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
		End case 
		
		If (Not:C34(fLockNLoad(->[Raw_Materials_Allocations:58])))
			$abort:=True:C214
			tText:="[[Raw_Materials_Allocations]] record locked, try later."
			
		Else 
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=[Raw_Materials_Transactions:23]Sequence:13; *)  //mlb 10/27/10
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
			If (Not:C34(fLockNLoad(->[Job_Forms_Materials:55])))
				$abort:=True:C214
				tText:="[[Job_Forms_Materials]] record locked, try later."
			End if 
		End if 
		//End if 
		
		If ($abort)
			[Raw_Materials_Transactions:23]Qty:6:=0
			UNLOAD RECORD:C212([Raw_Materials_Locations:25])
			UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
			UNLOAD RECORD:C212([Job_Forms_Materials:55])
			UNLOAD RECORD:C212([Raw_Material_Labels:171])
			REJECT:C38
		Else 
			ACCEPT:C269
		End if 
	End if 
End if   //false