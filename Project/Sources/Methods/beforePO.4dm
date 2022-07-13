//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date: 082399
// ----------------------------------------------------
// Method: beforePO
//•082399  mlb  reorganized the method, see beforePOold
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

C_BOOLEAN:C305(fNoDelete; fPOMaint; fNewPOCO)
C_LONGINT:C283($i; $t; lPOCORec)
C_TEXT:C284($1)  //option to treat as req

fPOMaint:=True:C214
fNewPOCO:=False:C215  //indicates if New Change Order in process
lPOCORec:=-1  //record number of newly created Change order
If (Current user:C182="Designer")
	<>FAX_USER:=True:C214
End if 
//SetObjectProperties ("";->rbShipTo4;False)  // Modified by: Mel Bohince (9/20/12)
// search for allow_supply_chain variable in PO_SaveRecord

cb1:=0
dDate:=!00-00-00!
iComm:=0
tSubGroup:=""
sDefJobId:=""

COPY ARRAY:C226(<>aGenDepts; aApprovingDepartments)
COPY ARRAY:C226(<>aDepartment; aDepartment)
LIST TO ARRAY:C288("Buyers"; abuy)
LIST TO ARRAY:C288("Terms"; aterm)
LIST TO ARRAY:C288("ShipVia"; ashipvia)
LIST TO ARRAY:C288("PO_FOBs"; afob)  //•061495  MLB  UPR 1645
LIST TO ARRAY:C288("Statuses"; astat)

Case of 
	: (Is new record:C668([Purchase_Orders:11]))  //new    
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		[Purchase_Orders:11]PONo:1:=PO_setPONumber
		[Purchase_Orders:11]ReqNo:5:=Req_setReqNumber  //assign Requisition number too
		[Purchase_Orders:11]LastChgOrdNo:18:="00"
		[Purchase_Orders:11]Status:15:="Requisition"  //• 6/16/97 cs upr 1872 replaced 'open' -> 'Requisition' - forces posting to budge
		[Purchase_Orders:11]StatusBy:16:=<>zResp
		[Purchase_Orders:11]ModWho:32:=<>zResp
		[Purchase_Orders:11]Buyer:11:=<>zResp
		[Purchase_Orders:11]ReqBy:6:=<>zResp
		[Purchase_Orders:11]StatusDate:17:=4D_Current_date
		[Purchase_Orders:11]ShippingOption:53:="Normal"
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
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET ENABLED:C1123(rbShipTo1; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo2; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo3; False:C215)  //•032496  mBohince  
		OBJECT SET ENABLED:C1123(rbShipTo4; False:C215)  //•032496  mBohince 
		OBJECT SET ENABLED:C1123(bDummy; False:C215)
		OBJECT SET ENABLED:C1123(bApprove; False:C215)
		OBJECT SET ENABLED:C1123(bLookVend; False:C215)
		OBJECT SET ENABLED:C1123(bRenameFG; False:C215)
		
		ARRAY TEXT:C222(abuy; 1)  //clear popups -disables them
		ARRAY TEXT:C222(aterm; 1)
		ARRAY TEXT:C222(ashipvia; 1)
		ARRAY TEXT:C222(afob; 1)
		ARRAY TEXT:C222(astat; 1)
		ARRAY TEXT:C222(aDepartment; 0)
		ARRAY TEXT:C222(aApprovingDepartments; 1)
		abuy{1}:=[Purchase_Orders:11]Buyer:11
		aterm{1}:=[Purchase_Orders:11]Terms:9
		ashipvia{1}:=[Purchase_Orders:11]ShipVia:10
		afob{1}:=[Purchase_Orders:11]FOB:8
		astat{1}:=[Purchase_Orders:11]Status:15
		aApprovingDepartments{1}:=[Purchase_Orders:11]Dept:7
		
	: (Locked:C147([Purchase_Orders:11]))  //its locked, nothing can be done anyway   
		BEEP:C151
		uConfirm("This PO is locked, try again later."; "OK"; "Help")
		CANCEL:C270
		
	: (iMode=2) | (Current user:C182="Designer")  //modify
		If (User in group:C338(Current user:C182; "Purchasing"))  //requisitioner access    
			Case of 
				: ([Purchase_Orders:11]Status:15="New Req")
					//OK to modify
				: ([Purchase_Orders:11]Status:15="Req Approved")
					//OK to modify
				: ([Purchase_Orders:11]Status:15="Requisition")
					//OK to modify          
				: ([Purchase_Orders:11]Status:15="PlantMgr")
					//OK to modify    
				: (fOrdering)
					//OK to modify from req
				: (Not:C34(User in group:C338(Current user:C182; "PO_Approval"))) & (Current user:C182#"Designer")
					If (Current user:C182#"Designer")
						uConfirm("This PO has been Approved'."+Char:C90(13)+"You are NOT Authorized modify this PO."+Char:C90(13)+"To see the details of this PO, Please 'Review' it.")
						CANCEL:C270
					Else 
						uConfirm("Designer, why you lucky stiff, you should not modify an approved PO."; "I'm just looking")
					End if 
					
				Else   //change order required
					BEEP:C151  //• 4/7/98 cs modified confirmation message below 
					xText:=""
					
					$winRef:=OpenSheetWindow(->[zz_control:1]; "New_PO_CO")
					DIALOG:C40([zz_control:1]; "New_PO_CO")
					CLOSE WINDOW:C154($winRef)
					
					//uDialog ("New_PO_CO";320;230;1)  `• 3/10/98 cs moved dialog, modified dialog appearence
					If (OK=1)
						If (Length:C16(xText)=0)
							xText:="Reason not given"
						End if 
						fNewPOCO:=PO_NewChangeOrder(->lPOCORec)
						
						If ([Purchase_Orders:11]Status:15="Closed")
							uConfirm("This PO has the Status of 'Closed'."+Char:C90(13)+"You should NOT modify this PO."; "Continue"; "Cancel")  //+Char(13)+"To see the details of this PO, Please 'Review' it.")
							If (OK=0)
								CANCEL:C270
							End if 
						End if 
						
					Else   //user canceled chg ord dialog
						BEEP:C151
						zwStatusMsg("PO CHG ORD"; "The status of this PO requires that a change order be created"+" before you may make modifications.")
						CANCEL:C270  //cancel record
					End if 
					
			End case 
			
		Else 
			uConfirm("You must be in the 'Purchasing' group to Modify a PO."+Char:C90(13)+"Try using Review."; "OK"; "Help")
			CANCEL:C270
		End if 
		
	Else   //unknown    
		BEEP:C151
		TRACE:C157
		CANCEL:C270
End case 

PO_setVendorButton

PoVendorAssign([Purchase_Orders:11]VendorID:2)

If (<>FAX_USER) & (Length:C16([Vendors:7]Fax:12)>9)
	OBJECT SET ENABLED:C1123(bFax; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bFax; False:C215)
End if 

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
util_ComboBoxSetup(->abuy; [Purchase_Orders:11]Buyer:11)
util_ComboBoxSetup(->aApprovingDepartments; [Purchase_Orders:11]Dept:7)
util_ComboBoxSetup(->aTerm; [Purchase_Orders:11]Terms:9)
util_ComboBoxSetup(->afob; [Purchase_Orders:11]FOB:8)
util_ComboBoxSetup(->aShipvia; [Purchase_Orders:11]ShipVia:10)

ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3=[Purchase_Orders:11]PONo:1)
ORDER BY:C49([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]POCOKey:1; >)

READ WRITE:C146([Purchase_Orders_Clauses:14])
RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
ORDER BY:C49([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]SeqNo:1; >)

PO_setExtendedTotals("all")