//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date: 10/10/97
// ----------------------------------------------------
// Method: BeforeCustOrder
// ----------------------------------------------------
// Modified by: Garri Ogata (11/13/20) - Added <>PHYSICAL_INVENORY_IN_PROGRESS check
// Modified by: Garri Ogata (09/22/21) - Added check for array to not be 0 (250)

C_LONGINT:C283(vPVPID; vAskMePID)
C_REAL:C285(rTotal1; rTtal2; rTotal3)
C_BOOLEAN:C305(cancelLineItemInputForm; fItemChg)

If (Not:C34(User_AllowedCustomer([Customers_Orders:40]CustID:2; ""; "via ORD:"+String:C10([Customers_Orders:40]OrderNumber:1))))
	bDone:=1
	CANCEL:C270
End if 

SetObjectProperties("lockopen"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties("lockclosed"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)

cancelLineItemInputForm:=False:C215  // this is used by the PV display screen
fItemChg:=False:C215
READ ONLY:C145([Customers:16])  //••
READ ONLY:C145([Customers_Addresses:31])

fCnclTrn:=True:C214
fChg:=False:C215

fCOFlag:=False:C215  //Used to mark access to change order

OBJECT SET ENABLED:C1123(bDelete; False:C215)
OBJECT SET ENABLED:C1123(bValidate; False:C215)
OBJECT SET ENABLED:C1123(*; "chgOrd@"; False:C215)
OBJECT SET ENABLED:C1123(*; "orderline@"; False:C215)

ARRAY TEXT:C222(aEmailAddress; 0)
ARRAY TEXT:C222(aSalesReps; 0)

ARRAY TEXT:C222(aBrand; 1)
aBrand{1}:=[Customers_Orders:40]CustomerLine:22
ARRAY TEXT:C222(aTerm; 1)
aTerm{1}:=[Customers_Orders:40]Terms:23
ARRAY TEXT:C222(asOrdStat; 1)
asOrdStat{1}:=[Customers_Orders:40]Status:10
ARRAY TEXT:C222(ashipvia; 1)
ashipvia{1}:=[Customers_Orders:40]ShipVia:24
ARRAY TEXT:C222(afob; 1)
afob{1}:=[Customers_Orders:40]FOB:25
ARRAY TEXT:C222(aBilltos; 1)
aBilltos{1}:=[Customers_Orders:40]defaultBillTo:5
ARRAY TEXT:C222(aShiptos; 1)
aShiptos{1}:=[Customers_Orders:40]defaultShipto:40

READ ONLY:C145([Estimates:17])  //2/14/95
RELATE ONE:C42([Customers_Orders:40]EstimateNo:3)

Text2:=fGetAddressText([Customers_Orders:40]defaultBillTo:5)
a1:=1
a2:=0



Case of 
	: (Is new record:C668([Customers_Orders:40]))  //shouldn't ever hit here
		uConfirm("This can't be happening..."; "It did"; "Oh Oh")
		CANCEL:C270
		
	: (iMode=2)
		If (User in group:C338(Current user:C182; "CCO_Approval"))
			OBJECT SET ENABLED:C1123(bDelete; True:C214)
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
			OBJECT SET ENABLED:C1123(*; "chgOrd@"; True:C214)
			OBJECT SET ENABLED:C1123(*; "orderline@"; True:C214)
		End if 
		
		If ([Customers_Orders:40]PlannedBy:30=<>zResp) | (User in group:C338(Current user:C182; "SalesManager"))
			LIST TO ARRAY:C288("SalesReps"; aSalesReps)
		Else 
			ARRAY TEXT:C222(aSalesReps; 1)
			aSalesReps{1}:=[Customers_Orders:40]SalesRep:13
		End if 
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Orders:40]CustID:2; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Bill to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aBilltos)
		SORT ARRAY:C229(aBilltos; >)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Orders:40]CustID:2; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aShiptos)
		SORT ARRAY:C229(aShiptos; >)
		OBJECT SET ENABLED:C1123(vAddContac1; True:C214)
		aEmailAddress:=Contact_PickEmail([Customers_Orders:40]CustID:2; "Purchasing Agent"; [Customers_Orders:40]Contact_Agent:36)  //populate aEmailAddress
		
		If (Find in array:C230(aEmailAddress; [Customers_Orders:40]EmailTo:38)=-1)
			INSERT IN ARRAY:C227(aEmailAddress; 1; 1)
			aEmailAddress{1}:=[Customers_Orders:40]EmailTo:38
		End if 
		INSERT IN ARRAY:C227(aEmailAddress; 1; 1)
		aEmailAddress{1}:="Select or Enter Email address."
		
		If (Length:C16([Customers_Orders:40]edi_sender_id:57)>0)
			OBJECT SET ENABLED:C1123(set_edi_sender; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(set_edi_sender; True:C214)
		End if 
		
		
		COPY ARRAY:C226(<>asOrdStat; asOrdStat)  //2/15/95 upr 1326
		
		If (User in group:C338(Current user:C182; "AccountManager"))
			SetObjectProperties("lockopen"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("lockclosed"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
			LIST TO ARRAY:C288("Terms"; aTerm)
			LIST TO ARRAY:C288("ShipVia"; ashipvia)
			LIST TO ARRAY:C288("FOBs"; afob)  //•061495  MLB  UPR 1645
			
		Else 
			ARRAY TEXT:C222(aTerm; 1)
			aTerm{1}:=[Customers_Orders:40]Terms:23
			SetObjectProperties(""; ->[Customers_Orders:40]FOB:25; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties(""; ->[Customers_Orders:40]ShipVia:24; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			ARRAY TEXT:C222(ashipvia; 1)
			ARRAY TEXT:C222(afob; 1)
			ashipvia{1}:=[Customers_Orders:40]ShipVia:24
			afob{1}:=[Customers_Orders:40]FOB:25
		End if 
		
		READ WRITE:C146([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_Order_Change_Orders:34])
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		
		//SetObjectProperties ("";->bEditpspec;True;"Edit")  // Modified by: Mark Zinke (5/6/13)
		//SetObjectProperties ("";->EditCO;True;"Edit")  // Modified by: Mark Zinke (5/6/13)
		
		Case of 
			: (([Customers_Orders:40]Status:10="Accepted") | ([Customers_Orders:40]Status:10="Budgeted"))
				SetObjectProperties("lockopen"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
				SetObjectProperties("lockclosed"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
				OBJECT SET ENABLED:C1123(PrtOrdAckn; True:C214)
				uSetEntStatus(->[Customers_Orders:40]; False:C215)
				SetObjectProperties(""; ->[Customers_Orders:40]PONumber:11; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
				SetObjectProperties(""; ->[Customers_Orders:40]DateOpened:6; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
				SetObjectProperties(""; ->[Customers_Orders:40]PayUse:50; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
				//OBJECT SET ENABLED(CreateCO;True)
				//SetObjectProperties ("";->bEditpspec;True;"View")  // Modified by: Mark Zinke (5/6/13)
				
				ARRAY TEXT:C222(aBrand; 1)
				aBrand{1}:=[Customers_Orders:40]CustomerLine:22
				aBrand:=1
				ARRAY TEXT:C222(aBilltos; 1)
				aBilltos{1}:=[Customers_Orders:40]defaultBillTo:5
				ARRAY TEXT:C222(aShiptos; 1)
				aShiptos{1}:=[Customers_Orders:40]defaultShipto:40
				OBJECT SET ENABLED:C1123(bValidate; True:C214)
				
			: (([Customers_Orders:40]Status:10="Closed") | ([Customers_Orders:40]Status:10="Kill") | ([Customers_Orders:40]Status:10="Cancel"))
				SetObjectProperties("lockopen"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
				SetObjectProperties("lockclosed"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
				uSetEntStatus(->[Customers_Orders:40]; False:C215)
				OBJECT SET ENABLED:C1123(CreateCO; True:C214)
				OBJECT SET ENABLED:C1123(bValidate; True:C214)
				
			Else 
				OBJECT SET ENABLED:C1123(bValidate; True:C214)
				OBJECT SET ENABLED:C1123(bUp; True:C214)
				OBJECT SET ENABLED:C1123(bDown; True:C214)
				OBJECT SET ENABLED:C1123(bUp2; True:C214)
				OBJECT SET ENABLED:C1123(bDown2; True:C214)
				OBJECT SET ENABLED:C1123(bAddPS; True:C214)
				OBJECT SET ENABLED:C1123(bDelPS; True:C214)
				OBJECT SET ENABLED:C1123(bEditpspec; True:C214)
				SetObjectProperties(""; ->EditCO; True:C214; "View")  // Modified by: Mark Zinke (5/6/13)
				uBuildBrandLis2  //upr 1221 11/22/94
		End case 
		
		If (User in group:C338(Current user:C182; "AccountManager")) & (iMode<3)  //•5/06/99  MLB  UPR 236 for commission purposes
			SetObjectProperties(""; ->[Customers_Orders:40]IsContract:52; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		Else 
			SetObjectProperties(""; ->[Customers_Orders:40]IsContract:52; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		End if 
		
	: (iMode>2)
		ARRAY TEXT:C222(aSalesReps; 1)
		aSalesReps{1}:=[Customers_Orders:40]SalesRep:13
		ARRAY TEXT:C222(aEmailAddress; 1)
		aEmailAddress{1}:=[Customers_Orders:40]EmailTo:38
		ARRAY TEXT:C222(aBrand; 1)
		aBrand{1}:=[Customers_Orders:40]CustomerLine:22
		ARRAY TEXT:C222(aTerm; 1)
		aTerm{1}:=[Customers_Orders:40]Terms:23
		ARRAY TEXT:C222(asOrdStat; 1)
		asOrdStat{1}:=[Customers_Orders:40]Status:10
		ARRAY TEXT:C222(ashipvia; 1)
		ashipvia{1}:=[Customers_Orders:40]ShipVia:24
		ARRAY TEXT:C222(afob; 1)
		afob{1}:=[Customers_Orders:40]FOB:25
		ARRAY TEXT:C222(aBilltos; 1)
		aBilltos{1}:=[Customers_Orders:40]defaultBillTo:5
		ARRAY TEXT:C222(aShiptos; 1)
		aShiptos{1}:=[Customers_Orders:40]defaultShipto:40
		
		READ ONLY:C145([Customers_Order_Lines:41])
		READ ONLY:C145([Customers_Order_Change_Orders:34])
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		
	Else 
		If (Current user:C182#"Designer")
			CANCEL:C270
		Else 
			COPY ARRAY:C226(<>asOrdStat; asOrdStat)  //2/15/95 upr 1326
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
		End if 
End case 

RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
CustOrderLinesCheckStatus([Customers_Orders:40]Status:10)  // Added by: Mark Zinke (8/5/13) 
i1:=Records in selection:C76([Customers_Order_Lines:41])  //used for sequenct numbers on order lines   
ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]LineItem:2; >)  //•110998  MLB  UPR 
If (i1>0)
	OBJECT SET ENABLED:C1123(*; "hasOL@"; True:C214)
End if 
rReal1:=fTotalOrderLine

ORDER BY:C49([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1; <)
If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
	OBJECT SET ENABLED:C1123(EditCO; True:C214)
End if 
Invoice_SetInvoiceBtnState
//
If (User in group:C338(Current user:C182; "Planners"))
	OBJECT SET ENABLED:C1123(bCreateBudget; True:C214)
End if 

If (([Customers_Orders:40]Status:10="Accepted") | ([Customers_Orders:40]Status:10="Budgeted"))
	OBJECT SET ENABLED:C1123(PrtOrdAckn; True:C214)
End if 

util_ComboBoxSetup(->asOrdStat; [Customers_Orders:40]Status:10)
util_ComboBoxSetup(->aTerm; [Customers_Orders:40]Terms:23)
util_ComboBoxSetup(->afob; [Customers_Orders:40]FOB:25)
util_ComboBoxSetup(->aShipvia; [Customers_Orders:40]ShipVia:24)
util_ComboBoxSetup(->aBrand; [Customers_Orders:40]CustomerLine:22)

Case of 
	: (Length:C16([Customers_Orders:40]EmailTo:38)>0)
		util_ComboBoxSetup(->aEmailAddress; [Customers_Orders:40]EmailTo:38)
	: (Size of array:C274(aEmailAddress)=0)
	Else 
		aEmailAddress{0}:=aEmailAddress{1}
		aEmailAddress:=1
End case 

If (<>PHYSICAL_INVENORY_IN_PROGRESS)  // Modified by: Garri Ogata (11/13/20) 
	
	OBJECT SET ENABLED:C1123(*; "asOrdStat"; False:C215)
	
End if 
