//%attributes = {"publishedWeb":true}
//(P) beforePOI: before phase processing for [PO_ITEMS]
//upr 1300 11/4/94
//UPR 1355 Chip 12/9/94
//upr 1454 3/24/95
//•031997  MLB  
//• 4/1/97 cs Allow subgroup to be modified at any time, PO Item is modifiable
//• 4/10/97 cs clear RM_xfer selection when navigating from po_item to poitem
//• 4/11/97 cs code to track changs in subgroup correctly
//• 7/15/97 cs added code to popoulate subgroub popup based on Entered comm code
//• 7/17/97 cs allowed acces to po_item's raw material code except when PO has 
//been approved
//• 11/14/97 cs added assignment of reqn by field
//• 4/24/98 cs STOP deletion of items once any item has been received
//• 4/24/98 cs give user ability to cancel ONE item on a PO
// SetObjectProperties, Mark Zinke (5/16/13)
// Modified by: Mel Bohince (1/12/16) Remove Dan's restriction?
// Modified by: Mel Bohince (4/14/17) using wrong qty off the transactions when sum'g the receipts, call CalcPOitem

MESSAGES OFF:C175
READ ONLY:C145([Raw_Materials_Transactions:23])
fPOIMaint:=True:C214
fNewRM:=False:C215
fChngComKey:=False:C215  //• 4/11/97 cs 
sPOIAction:=fGetMode(imode)
applyFixedCost:=0  //use to on validate to see if change is required, unitprice floats based on qty, instead of extprice changing

SetObjectProperties("asset@"; -><>NULL; False:C215)
ARRAY TEXT:C222(aUom1; 0)  //disbale popups
ARRAY TEXT:C222(aUom2; 0)
ARRAY TEXT:C222(aUom3; 0)
ARRAY TEXT:C222(aCommCode; 0)
ARRAY TEXT:C222(aSubGroup; 0)
ARRAY TEXT:C222(aExpCode; 0)
ARRAY TEXT:C222(aDepartment; 0)  //set in beforePO, don't change

Case of 
	: (Is new record:C668([Purchase_Orders_Items:12]))  //this is new
		If (User in group:C338(Current user:C182; "Purchasing")) | (User in group:C338(Current user:C182; "Requisitions"))
			LIST TO ARRAY:C288("UOMs"; aUOM1)
			COPY ARRAY:C226(aUOM1; aUOM2)
			COPY ARRAY:C226(aUOM1; aUOM3)
			
			LIST TO ARRAY:C288("CommCodes"; aCommCode)
			
			LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
			COPY ARRAY:C226(<>aDepartment; aDepartment)
			RMG_buildSubgroupList(iComm; ->aSubGroup)
			
			sPOIAction:="NEW"
			[Purchase_Orders_Items:12]PONo:2:=[Purchase_Orders:11]PONo:1
			sItemNo:=String:C10(Num:C11(sItemNo)+1; "00")
			[Purchase_Orders_Items:12]ItemNo:3:=sItemNo
			[Purchase_Orders_Items:12]POItemKey:1:=[Purchase_Orders_Items:12]PONo:2+sItemNo
			[Purchase_Orders_Items:12]ReqdDate:8:=[Purchase_Orders:11]Required:27
			[Purchase_Orders_Items:12]ModDate:19:=4D_Current_date
			[Purchase_Orders_Items:12]ModWho:20:=<>zResp
			[Purchase_Orders_Items:12]ReqnBy:18:=<>zResp
			[Purchase_Orders_Items:12]VendorID:39:=[Purchase_Orders:11]VendorID:2
			[Purchase_Orders_Items:12]FactNship2price:25:=1
			[Purchase_Orders_Items:12]FactNship2cost:29:=1
			[Purchase_Orders_Items:12]FactDship2cost:37:=1
			[Purchase_Orders_Items:12]FactDship2price:38:=1
			[Purchase_Orders_Items:12]PoItemDate:40:=4D_Current_date  //UPR 1355
			//carry defaults
			[Purchase_Orders_Items:12]PromiseDate:9:=dDate
			[Purchase_Orders_Items:12]SubGroup:13:=tSubGroup
			[Purchase_Orders_Items:12]CommodityCode:16:=iComm
			[Purchase_Orders_Items:12]Commodity_Key:26:=RMG_getCommodityKey([Purchase_Orders_Items:12]CommodityCode:16; [Purchase_Orders_Items:12]SubGroup:13)
			[Purchase_Orders_Items:12]CompanyID:45:=[Purchase_Orders:11]CompanyID:43  //moved to here because the division gets reset (sometimes) by RM group
			
			sSetPurchaseUM([Purchase_Orders_Items:12]CommodityCode:16)
			fNewRM:=True:C214
			
			
		Else   //user in wrong group
			uNewRecReject("You are not permitted to create a PO Item in this manner!")
		End if 
		
	: (iMode<3)
		//If (Not(POTestStatus ("Approved+")))
		READ WRITE:C146([Raw_Materials_Transactions:23])
		READ WRITE:C146([Purchase_Orders_Releases:79])
		LIST TO ARRAY:C288("UOMs"; aUOM1)
		COPY ARRAY:C226(aUOM1; aUOM2)
		COPY ARRAY:C226(aUOM1; aUOM3)
		
		LIST TO ARRAY:C288("CommCodes"; aCommCode)
		
		//LIST TO ARRAY("ExpenseCodes";aExpCode)
		//COPY ARRAY(◊aDepartment;aDepartment)
		RMG_buildSubgroupList([Purchase_Orders_Items:12]CommodityCode:16; ->aSubGroup)
		//End if 
		LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
		COPY ARRAY:C226(<>aDepartment; aDepartment)
		iComm:=[Purchase_Orders_Items:12]CommodityCode:16
		tSubGroup:=[Purchase_Orders_Items:12]SubGroup:13
		
	Else   //review mode
		READ ONLY:C145([Purchase_Orders_Releases:79])
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bValidatePOI; False:C215)
		OBJECT SET ENABLED:C1123(bRelClear; False:C215)
		OBJECT SET ENABLED:C1123(bZoomMatl; False:C215)
		OBJECT SET ENABLED:C1123(bRel; False:C215)
		
		ARRAY TEXT:C222(aUom1; 1)  //disbale popups
		ARRAY TEXT:C222(aUom2; 1)
		ARRAY TEXT:C222(aUom3; 1)
		ARRAY TEXT:C222(aCommCode; 1)
		ARRAY TEXT:C222(aSubGroup; 1)
		ARRAY TEXT:C222(aExpCode; 1)
		ARRAY TEXT:C222(aDepartment; 1)
		aUom1{1}:=[Purchase_Orders_Items:12]UM_Ship:5
		aUom2{1}:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
		aUom3{1}:=[Purchase_Orders_Items:12]UM_Price:24
		aCommCode{1}:=String:C10([Purchase_Orders_Items:12]CommodityCode:16)
		aSubGroup{1}:=[Purchase_Orders_Items:12]SubGroup:13
		aExpCode{1}:=[Purchase_Orders_Items:12]ExpenseCode:47
		aDepartment{1}:=[Purchase_Orders_Items:12]DepartmentID:46
End case 

If ([Purchase_Orders_Items:12]CommodityCode:16>13) | (User in group:C338(Current user:C182; "RoleAccounting"))
	SetObjectProperties("exp@"; -><>NULL; True:C214)
Else 
	SetObjectProperties("exp@"; -><>NULL; False:C215)
	If (Length:C16([Purchase_Orders_Items:12]ExpenseCode:47)#4) & (sPOIAction="MODIFY")
		[Purchase_Orders_Items:12]ExpenseCode:47:="9999"
	End if 
End if 

If ([Purchase_Orders_Items:12]CommodityCode:16=39)
	SetObjectProperties("asset@"; -><>NULL; True:C214)
End if 

$calculatedReceivedQty:=0
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Return"; *)  // upr 1297
QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)  // upr 1297
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders_Items:12]POItemKey:1)
If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; <)
	$calculatedReceivedQty:=Sum:C1([Raw_Materials_Transactions:23]POQty:8)  // Modified by: Mel Bohince (4/14/17) 
	If ($calculatedReceivedQty#[Purchase_Orders_Items:12]Qty_Received:14)
		zwStatusMsg("WARNING"; "Correcting [Purchase_Orders_Items]Qty_Received")
		[Purchase_Orders_Items:12]Qty_Received:14:=$calculatedReceivedQty
		SAVE RECORD:C53([Purchase_Orders_Items:12])
	End if 
	
	If (fNewPOCO) & ($calculatedReceivedQty>0)
		util_FloatingAlert("There are transactions against line item: "+[Purchase_Orders_Items:12]POItemKey:1+"."+Char:C90(13)+"Make sure you do a RETURN PRIOR to changing the Unit of Measure or conversions.")
	End if 
End if 

CalcPOitem  // Modified by: Mel Bohince (4/14/17) lifted up out of ship qty field onload event

QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders_Items:12]POItemKey:1)
ORDER BY:C49([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2; >)

QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]POitemKey:1=[Purchase_Orders_Items:12]POItemKey:1)
ORDER BY:C49([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]Schd_Date:3; >)

If (fNoDelete)  //• 4/24/98 cs set in Purchase order before
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 

If ([Purchase_Orders_Items:12]Canceled:44)  //• 4/24/98 cs give user ability to cancel ONE item on a PO
	
	OBJECT SET RGB COLORS:C628([Purchase_Orders_Items:12]Canceled:44; Black:K11:16; 16711680)  //make background red and forground black
	
	SetObjectProperties("tcancelled@"; -><>NULL; True:C214)
	SetObjectProperties("tNot@"; -><>NULL; False:C215)
	
Else 
	
	OBJECT SET RGB COLORS:C628([Purchase_Orders_Items:12]Canceled:44; 0; 16777215)  //make normal colors - black text on white
	
	SetObjectProperties("tcancelled@"; -><>NULL; False:C215)
	SetObjectProperties("tNot@"; -><>NULL; True:C214)
End if 

util_ComboBoxSetup(->aUOM1; [Purchase_Orders_Items:12]UM_Ship:5)
util_ComboBoxSetup(->aUOM2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
util_ComboBoxSetup(->aUOM3; [Purchase_Orders_Items:12]UM_Price:24)

util_ComboBoxSetup(->aCommCode; String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00"))
util_ComboBoxSetup(->aSubGroup; [Purchase_Orders_Items:12]SubGroup:13)
util_ComboBoxSetup(->aExpCode; [Purchase_Orders_Items:12]ExpenseCode:47)
util_ComboBoxSetup(->aDepartment; [Purchase_Orders_Items:12]DepartmentID:46)

sRMflexFields([Purchase_Orders_Items:12]CommodityCode:16; 1)

If (Length:C16([Purchase_Orders_Items:12]Commodity_Key:26)>2)  //it has been set so restrict
	//If (Not(User in group(Current user;"RoleCostAccountant")))// Modified by: Mel Bohince (1/12/16) Why did Dan want to restrict?
	//OBJECT SET ENABLED(aCommCode;False)
	//OBJECT SET ENABLED(aSubGroup;False)
	//End if 
End if 

OBJECT SET ENABLED:C1123(bRel; True:C214)
