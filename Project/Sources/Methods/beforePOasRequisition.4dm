//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/16/06, 11:00:13
// ----------------------------------------------------
// Method: beforePOasRequisition
// Description
// Handle items unique to reqs
// ----------------------------------------------------
//(P) beforePO: before phase processing for [PURCHASE_ORDER]
//•082399  mlb  reorganized the method, see beforePOold

C_BOOLEAN:C305(fNoDelete; fPOMaint; fNewPOCO)
C_LONGINT:C283($i; $t; lPOCORec)
C_TEXT:C284($1)  //option to treat as req

fPOMaint:=True:C214
fNewPOCO:=False:C215  //indicates if New Change Order in process
lPOCORec:=-1  //record number of newly created Change order
cb1:=0
dDate:=!00-00-00!
iComm:=0
tSubGroup:=""
sDefJobId:=""

//used by seting vendor via rm pick
LIST TO ARRAY:C288("Terms"; aterm)
LIST TO ARRAY:C288("ShipVia"; ashipvia)
LIST TO ARRAY:C288("PO_FOBs"; afob)

COPY ARRAY:C226(<>aGenDepts; aApprovingDepartments)
COPY ARRAY:C226(<>aDepartment; aDepartment)
LIST TO ARRAY:C288("ReqStatuses"; astat)

Case of 
	: (User in group:C338(Current user:C182; "Req_Approval"))  //is the user allowed to approve?
		SetObjectProperties(""; ->[Purchase_Orders:11]Status:15; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bApprove; True:C214; "Approve")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bApprove; True:C214)
		OBJECT SET ENABLED:C1123(bHold; True:C214)
		
	: (User in group:C338(Current user:C182; "Req_PreApproval"))
		SetObjectProperties(""; ->[Purchase_Orders:11]Status:15; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bApprove; True:C214; "PreApprove")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bApprove; True:C214)
		OBJECT SET ENABLED:C1123(bHold; True:C214)
		
	Else 
		SetObjectProperties(""; ->[Purchase_Orders:11]Status:15; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bApprove; True:C214; "n/a")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bApprove; False:C215)
		OBJECT SET ENABLED:C1123(bHold; False:C215)
End case 

Case of 
	: (Is new record:C668([Purchase_Orders:11]))  //new    
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		[Purchase_Orders:11]PONo:1:=PO_setPONumber
		[Purchase_Orders:11]ReqNo:5:=Req_setReqNumber  //assign Requisition number too
		[Purchase_Orders:11]LastChgOrdNo:18:="00"
		[Purchase_Orders:11]StatusBy:16:=<>zResp
		[Purchase_Orders:11]ModWho:32:=<>zResp
		[Purchase_Orders:11]ReqBy:6:=<>zResp
		[Purchase_Orders:11]Buyer:11:=""
		[Purchase_Orders:11]Status:15:="New Req"
		[Purchase_Orders:11]ShippingOption:53:="Normal"
		[Purchase_Orders:11]StatusDate:17:=4D_Current_date
		[Purchase_Orders:11]PODate:4:=4D_Current_date
		[Purchase_Orders:11]ModDate:31:=4D_Current_date
		If (User in group:C338(Current user:C182; "Roanoke"))
			PO_SetAddress("Roanoke")
			rbShipTo1:=2  //•1/31/97 mod for company default
			[Purchase_Orders:11]CompanyID:43:="2"  //•1/31/97 mod for company default
		Else 
			PO_SetAddress("Hauppauge")
			rbShipTo1:=1  //•1/31/97 mod for company default
			[Purchase_Orders:11]CompanyID:43:="1"  //•1/31/97 mod for company default
		End if 
		
		$sequence:=1
		READ ONLY:C145([Purchase_Orders_Clauses:14])
		QUERY:C277([Purchase_Orders_Clauses:14]; [Purchase_Orders_Clauses:14]ID:1="EMAIL")
		If (Records in selection:C76([Purchase_Orders_Clauses:14])>0)
			PO_ClauseAdd("EMAIL"; ->$sequence)
		End if 
		QUERY:C277([Purchase_Orders_Clauses:14]; [Purchase_Orders_Clauses:14]ID:1="FUEL")
		If (Records in selection:C76([Purchase_Orders_Clauses:14])>0)
			PO_ClauseAdd("FUEL"; ->$sequence)
		End if 
		REDUCE SELECTION:C351([Purchase_Orders_Clauses:14]; 0)
		
	: (iMode=3)  //review
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(rbShipTo1; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo2; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo3; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo4; False:C215)  //•032496  mBohince 
		
		OBJECT SET ENABLED:C1123(i1; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(i2; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(i3; False:C215)
		OBJECT SET ENABLED:C1123(cb1; False:C215)
		
		OBJECT SET ENABLED:C1123(bDummy; False:C215)
		OBJECT SET ENABLED:C1123(bApprove; False:C215)
		OBJECT SET ENABLED:C1123(bLookVend; False:C215)
		OBJECT SET ENABLED:C1123(bRenameFG; False:C215)
		OBJECT SET ENABLED:C1123(bHold; False:C215)
		
		ARRAY TEXT:C222(astat; 1)
		ARRAY TEXT:C222(aDepartment; 0)
		ARRAY TEXT:C222(aApprovingDepartments; 1)
		astat{1}:=[Purchase_Orders:11]Status:15
		aApprovingDepartments{1}:=[Purchase_Orders:11]Dept:7
		
	: (Locked:C147([Purchase_Orders:11]))  //its locked, nothing can be done anyway   
		BEEP:C151
		uConfirm("This Requisition is locked, try again later."; "OK"; "Help")
		CANCEL:C270
		
	: (iMode=2) | (Current user:C182="Designer")  //modify
		Case of 
			: ([Purchase_Orders:11]Status:15="Requisition")
			: ([Purchase_Orders:11]Status:15="Cancelled")
			: ([Purchase_Orders:11]Status:15="Req On Hold")
			: ([Purchase_Orders:11]Status:15="New Req")
			: ([Purchase_Orders:11]Status:15="PlantMgr")
			: ([Purchase_Orders:11]Status:15="Req Approved")
				uConfirm("This Requistion has been Approved and cannot be changed."+Char:C90(13)+"To view this requsition, please 'Review' it."; "OK"; "Help")
				CANCEL:C270
			Else 
				uConfirm("The Status of this requisition does not allow modifications."+Char:C90(13)+"To view this requsition, please 'Review' it."; "OK"; "Help")
				CANCEL:C270
		End case 
		
	Else   //unknown    
		BEEP:C151
		TRACE:C157
		CANCEL:C270
End case 

PoVendorAssign([Purchase_Orders:11]VendorID:2)

PO_setVendorButton

sItemNo:=gFindPOItem
CREATE EMPTY SET:C140([Purchase_Orders_Items:12]; "ChangedPItm")
$numRMX:=0  // Modified by: Mel Bohince (6/9/21) 
SET QUERY DESTINATION:C396(Into variable:K19:4; $numRMX)
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders:11]PONo:1+"@")
SET QUERY DESTINATION:C396(Into current selection:K19:1)
If ($numRMX>0)  //• 4/24/98 cs STOP ability to delete PO items if ANY receiving has occured
	fNoDelete:=True:C214
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
Else 
	fNoDelete:=False:C215
End if 

Case of   //set shipto radio buttons
	: ([Purchase_Orders:11]CompanyID:43="1")  //Arkay(hauppauge)
		rbShipTo1:=1
		rbShipTo2:=0
		rbShipTo3:=0
		rbShipTo4:=0
		cb1:=0
	: ([Purchase_Orders:11]CompanyID:43="2")  //Roanoke
		rbShipTo1:=0
		rbShipTo2:=1
		rbShipTo3:=0
		rbShipTo4:=0
		cb1:=0
	: ([Purchase_Orders:11]CompanyID:43="4")  //vista
		rbShipTo1:=0
		rbShipTo2:=0
		rbShipTo3:=1
		rbShipTo4:=0
		cb1:=0
	: ([Purchase_Orders:11]CompanyID:43="5")  //other
		rbShipTo1:=0
		rbShipTo2:=0  //
		rbShipTo3:=0
		rbShipTo4:=1
		cb1:=0
	: ([Purchase_Orders:11]CompanyID:43="3")  //Admintistration 
		cb1:=1
		If (Position:C15("Roanoke"; [Purchase_Orders:11]ShipTo3:36)>0)
			rbShipTo1:=0
			rbShipTo2:=1
			rbShipTo3:=0
			rbShipTo4:=0
		Else 
			rbShipTo1:=1
			rbShipTo2:=0
			rbShipTo3:=0
			rbShipTo4:=0
		End if 
End case 

util_ComboBoxSetup(->astat; [Purchase_Orders:11]Status:15)
util_ComboBoxSetup(->aApprovingDepartments; [Purchase_Orders:11]Dept:7)

ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
PO_setExtendedTotals("all")

Case of 
	: ([Purchase_Orders:11]ShippingOption:53="Hot")
		i1:=1
	: ([Purchase_Orders:11]ShippingOption:53="Rush")
		i2:=1
	: ([Purchase_Orders:11]ShippingOption:53="Normal")
		i3:=1
End case 