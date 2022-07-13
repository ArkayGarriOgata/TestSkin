//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: beforeRM
// ----------------------------------------------------
// Modified by: Mel Bohince (11/7/20) added two listboxes for where-used
fRMMaint:=True:C214

C_OBJECT:C1216(selectedJobForm; selectedProductCode)
C_COLLECTION:C1488(jobforms_c; items_c)

ARRAY TEXT:C222(aUom1; 0)  //disbale popups
ARRAY TEXT:C222(aUom2; 0)

LIST TO ARRAY:C288("UOMs"; aUOM1)
COPY ARRAY:C226(aUOM1; aUOM2)
LIST TO ARRAY:C288("RMstatus"; astat)

LIST TO ARRAY:C288("CommCodes"; aCommCode)
ARRAY TEXT:C222(aSubGroup; 0)
RMG_buildSubgroupList([Raw_Materials:21]CommodityCode:26; ->aSubGroup)

If (Length:C16([Raw_Materials:21]Commodity_Key:2)>2)  //it has been set so restrict
	If (Not:C34(User in group:C338(Current user:C182; "RoleCostAccountant")))
		OBJECT SET ENABLED:C1123(aCommCode; False:C215)
		OBJECT SET ENABLED:C1123(aSubGroup; False:C215)
	End if 
End if 

sRMflexFields([Raw_Materials:21]CommodityCode:26)

If ([Raw_Materials:21]Stocked:5)
	OBJECT SET VISIBLE:C603(*; "MRO@"; True:C214)
Else 
	OBJECT SET VISIBLE:C603(*; "MRO@"; False:C215)
End if 

Case of 
	: (Is new record:C668([Raw_Materials:21]))
		[Raw_Materials:21]Status:25:="Active"
		ARRAY BOOLEAN:C223(aCPNuses; 0)
		ARRAY TEXT:C222(aCPN; 0)
		
	: (iMode=2)
		READ WRITE:C146([Raw_Materials_Locations:25])
		READ WRITE:C146([Raw_Materials_Transactions:23])
		READ WRITE:C146([Raw_Materials_Allocations:58])
		READ WRITE:C146([Raw_Materials_Components:60])
		READ WRITE:C146([Purchase_Orders_Releases:79])
		SetObjectProperties(""; ->[Raw_Materials:21]Raw_Matl_Code:1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		If (User in group:C338(Current user:C182; "RoleCostAccountant")) | (Current user:C182="Designer")
			//allowed to change status, see below also for enabling objects
		Else 
			ARRAY TEXT:C222(astat; 1)
			astat{1}:=[Raw_Materials:21]Status:25
		End if 
		
	: (iMode>2)
		READ ONLY:C145([Raw_Materials_Locations:25])
		READ ONLY:C145([Raw_Materials_Transactions:23])
		READ ONLY:C145([Raw_Materials_Allocations:58])
		READ ONLY:C145([Raw_Materials_Components:60])
		READ ONLY:C145([Raw_Materials_Suggest_Vendors:173])
		READ ONLY:C145([Purchase_Orders_Releases:79])
		ARRAY TEXT:C222(aUom1; 1)  //disbale popups
		ARRAY TEXT:C222(aUom2; 1)
		ARRAY TEXT:C222(astat; 1)
		
		ARRAY TEXT:C222(aCommCode; 1)
		ARRAY TEXT:C222(aSubGroup; 1)
		
		aUom1{1}:=[Raw_Materials:21]ReceiptUOM:9
		aUom2{1}:=[Raw_Materials:21]IssueUOM:10
		astat{1}:=[Raw_Materials:21]Status:25
		aCommCode{1}:=String:C10([Raw_Materials:21]CommodityCode:26)
		aSubGroup{1}:=[Raw_Materials:21]SubGroup:31
		OBJECT SET ENABLED:C1123(aCommCode; False:C215)
		OBJECT SET ENABLED:C1123(aSubGroup; False:C215)
		OBJECT SET ENABLED:C1123(bAdd; False:C215)
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
End case 

If (User in group:C338(Current user:C182; "RoleCostAccountant"))
	SetObjectProperties(""; ->[Raw_Materials:21]Status:25; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Raw_Materials:21]ActCost:45; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bMerge; True:C214)
	OBJECT SET ENABLED:C1123(bRenameFG; True:C214)
	OBJECT SET ENABLED:C1123(astat; True:C214)
	If ([Raw_Materials:21]Status:25="Obsolete") | ([Raw_Materials:21]Status:25="PhaseOut")
		SetObjectProperties(""; ->[Raw_Materials:21]Successor:34; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		GOTO OBJECT:C206([Raw_Materials:21]Successor:34)
	End if 
	
Else 
	SetObjectProperties(""; ->[Raw_Materials:21]Status:25; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Raw_Materials:21]ActCost:45; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Raw_Materials:21]Successor:34; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bMerge; False:C215)
	OBJECT SET ENABLED:C1123(bRenameFG; False:C215)
	OBJECT SET ENABLED:C1123(astat; False:C215)
End if 

util_ComboBoxSetup(->aUOM1; [Raw_Materials:21]ReceiptUOM:9)
util_ComboBoxSetup(->aUOM2; [Raw_Materials:21]IssueUOM:10)
util_ComboBoxSetup(->astat; [Raw_Materials:21]Status:25)
util_ComboBoxSetup(->aCommCode; String:C10([Raw_Materials:21]CommodityCode:26; "00"))
util_ComboBoxSetup(->aSubGroup; [Raw_Materials:21]SubGroup:31)

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2; [Raw_Materials_Locations:25]POItemKey:19)

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; <; [Raw_Materials_Transactions:23]XferTime:25; <)

RELATE MANY:C262([Raw_Materials:21]Suggest_Vendors:49)
//ORDER BY([Raw_Materials_Suggest_Vendors];[Raw_Materials_Suggest_Vendors]Raw_Matl_Code;>)

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=[Raw_Materials:21]Raw_Matl_Code:1; *)
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Deleted:22=False:C215; *)
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Canceled:44=False:C215; *)
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27>0)
ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)

QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
ORDER BY:C49([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Date_Allocated:5; >)
rOnHand:=0
iOnHand:=0
iOnOrder:=0
iAllocated:=0
iIssued:=0
iOpen:=0

QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]RM_Code:7=[Raw_Materials:21]Raw_Matl_Code:1; *)
QUERY:C277([Purchase_Orders_Releases:79];  & ; [Purchase_Orders_Releases:79]Actual_Qty:6=0)
ORDER BY:C49([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]Schd_Date:3; >)

QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Raw_Materials:21]Raw_Matl_Code:1)
ORDER BY:C49([Raw_Materials_Components:60]; [Raw_Materials_Components:60]MixPercent:8; <)




