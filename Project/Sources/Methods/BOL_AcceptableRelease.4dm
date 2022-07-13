//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/10/07, 17:24:24
// ----------------------------------------------------
// Method: BOL_AcceptableRelease(release#)  --> boolean
// Description
// make sure releases added to a bol are compatible with dest, billto, etc
//
// ----------------------------------------------------
//removed ability to ship while in contract status - mlb 12/3/07
// ----------------------------------------------------

// Modified by: Mel Bohince (4/7/15) prevent rama from shipping against payuse releases
// Added by: Mel Bohince (6/28/19) require numeric char in PO
// Modified by: Mel Bohince (11/6/19) mode test
// Modified by: Mel Bohince (7/21/20) disable mode test, during TMC shipping feasco

C_TEXT:C284($problems)
C_BOOLEAN:C305($0; $setPayUse)
C_LONGINT:C283($1)  //release#

$problems:=""
$setPayUse:=False:C215

READ WRITE:C146([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$1)

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	
	If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))  // Modified by: Mel Bohince (4/7/15) prevent rama from shipping against payuse releases
		If ([Customers_ReleaseSchedules:46]PayU:31#0)
			$problems:=$problems+"Not a valid release for Rama use -- payuse."
		End if 
	End if 
	
	If (Not:C34(fLockNLoad(->[Customers_ReleaseSchedules:46])))  //not locked
		$problems:=$problems+"Release "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" was Locked."
	End if 
	UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	LOAD RECORD:C52([Customers_ReleaseSchedules:46])
	
	If ([Customers_ReleaseSchedules:46]B_O_L_pending:45>0)
		If ([Customers_ReleaseSchedules:46]B_O_L_pending:45#[Customers_Bills_of_Lading:49]ShippersNo:1)
			uConfirm("Warning: this release, "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+", is also on BOL#: "+String:C10([Customers_ReleaseSchedules:46]B_O_L_pending:45); "OK"; "Stop")
			If (OK=0)
				$problems:=$problems+"Release "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" is on BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_pending:45)
			End if 
		End if 
	End if 
	
	If (FG_LaunchItem("hold"; [Customers_ReleaseSchedules:46]ProductCode:11))
		$problems:=$problems+"Release "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" is a LAUNCH item on HOLD."
	End if 
	
	If (Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; 1)="<")
		$problems:=$problems+" Forecasted Release "
	End if 
	
	If ([Customers_ReleaseSchedules:46]Actual_Qty:8>0)
		$problems:=$problems+" Release already shipped "
	End if 
	
	If (Length:C16([Customers_Bills_of_Lading:49]BillTo:4)>0)
		If ([Customers_Bills_of_Lading:49]BillTo:4#[Customers_ReleaseSchedules:46]Billto:22)
			$problems:=$problems+" Bill-To mismatch "
		End if 
	End if 
	
	If (Length:C16([Customers_Bills_of_Lading:49]ShipTo:3)>0)
		If ([Customers_Bills_of_Lading:49]ShipTo:3#[Customers_ReleaseSchedules:46]Shipto:10)
			$problems:=$problems+" Ship-To mismatch "
		End if 
	End if 
	
	Case of   //payuse test
		: ([Customers_Bills_of_Lading:49]PayUseFlag:11=-1)  //not determined yet
			$setPayUse:=True:C214
			
		: ([Customers_Bills_of_Lading:49]PayUseFlag:11=0)  //regular shipment
			If ([Customers_ReleaseSchedules:46]PayU:31#0)
				$problems:=$problems+" Can't mix Pay-Use (consignments) with regular shipments. "
			End if 
			
		: ([Customers_Bills_of_Lading:49]PayUseFlag:11=1)  //consignment shipment
			If ([Customers_ReleaseSchedules:46]PayU:31#1)
				$problems:=$problems+" Can't mix regular shipments with Pay-Use (consignments). "
			End if 
	End case 
	
	If ([Customers_ReleaseSchedules:46]RemarkLine1:25="Bill and Hold") & ([Customers_ReleaseSchedules:46]Billto:22="N/A")
		
	End if 
	
	// Removed by: Mel Bohince (7/21/20) 
	// Modified by: Mel Bohince (11/6/19) mode test
	//If ([Customers_Bills_of_Lading]Mode#"")  //mode has been specified and must match
	//If ([Customers_ReleaseSchedules]Mode#"")
	//If ([Customers_Bills_of_Lading]Mode#[Customers_ReleaseSchedules]Mode)
	//$problems:=$problems+" BOL's mode is "+[Customers_Bills_of_Lading]Mode+" Release's is "+[Customers_ReleaseSchedules]Mode+", they must match"
	//End if 
	//End if 
	//End if   //mode
	
	
	RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
	If ([Customers_ReleaseSchedules:46]ProductCode:11#[Customers_Order_Lines:41]ProductCode:5)
		$problems:=$problems+" Release CPN differs from Orderlines CPN "
	End if 
	
	RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_ReleaseSchedules:46]OrderNumber:2)
	//     switched to orderline status instead of order status
	Case of 
		: (Records in selection:C76([Customers_Order_Lines:41])=0)
			$problems:=$problems+"Release's Order "+String:C10([Customers_ReleaseSchedules:46]OrderNumber:2)+" was not found."
		: ([Customers_Order_Lines:41]Status:9="Hold@")
			$problems:=$problems+"Release's Order "+String:C10([Customers_ReleaseSchedules:46]OrderNumber:2)+" is ON-HOLD."
		: (util_isOnlyAlpha([Customers_Order_Lines:41]PONumber:21))
			If (util_isOnlyAlpha([Customers_ReleaseSchedules:46]CustomerRefer:3))  //maybe the release is reasonable
				$problems:=$problems+"Release's Order "+String:C10([Customers_ReleaseSchedules:46]OrderNumber:2)+" has invalid PO."  // Added by: Mel Bohince (6/28/19)
			End if 
		: ([Customers_Order_Lines:41]Status:9="Accept@")
			//$statusOKToShip:=True
		: ([Customers_Order_Lines:41]Status:9="Budget@")
			//$statusOKToShip:=True
			//: ([Customers_Orders]Status="Contract@")`removed 12/3/07
			//$statusOKToShip:=True
		Else 
			$problems:=$problems+"Release's 'ORDERLINE' "+[Customers_ReleaseSchedules:46]OrderLine:4+"'s status is not 'Accepted' or 'Budgeted'."  //, or 'Contract'
	End case 
	
	
Else 
	$problems:=$problems+"Release "+String:C10($1)+" was not found."
End if 

If (Length:C16($problems)=0)
	[Customers_Bills_of_Lading:49]CustID:2:=[Customers_ReleaseSchedules:46]CustID:12
	[Customers_Bills_of_Lading:49]BillTo:4:=[Customers_ReleaseSchedules:46]Billto:22
	tText12:=fGetAddressText([Customers_Bills_of_Lading:49]BillTo:4; "*")
	
	[Customers_Bills_of_Lading:49]ShipTo:3:=[Customers_ReleaseSchedules:46]Shipto:10
	tText10:=fGetAddressText([Customers_Bills_of_Lading:49]ShipTo:3; "*")
	sCountry:=ADDR_getCountry([Customers_Bills_of_Lading:49]ShipTo:3)
	If (Records in selection:C76([Addresses:30])=1)
		If ((sCountry="") | (sCountry="USA") | (sCountry="U.S.A.") | (sCountry="US"))
			[Customers_Bills_of_Lading:49]International:10:=False:C215
			Core_ObjectSetColor(->[Customers_Bills_of_Lading:49]International:10; -(Black:K11:16+(256*White:K11:1)))
		Else 
			[Customers_Bills_of_Lading:49]International:10:=True:C214
			Core_ObjectSetColor(->[Customers_Bills_of_Lading:49]International:10; -(Red:K11:4+(256*White:K11:1)))
		End if 
	End if 
	REDUCE SELECTION:C351([Addresses:30]; 0)
	
	If (Length:C16([Customers_Bills_of_Lading:49]Mode:36)=0)
		[Customers_Bills_of_Lading:49]Mode:36:=[Customers_ReleaseSchedules:46]Mode:56
		If (Length:C16([Customers_Bills_of_Lading:49]Mode:36)=0)
			If ([Customers_ReleaseSchedules:46]Air_Shipment:51)
				[Customers_Bills_of_Lading:49]Mode:36:="Air"
			Else 
				If (Position:C15(sCountry; " USA U.S.A. Canada CA Mexico ")>0) | (Length:C16(sCountry)=0)  //north america
					[Customers_Bills_of_Lading:49]Mode:36:="Road"
				Else 
					[Customers_Bills_of_Lading:49]Mode:36:="Ocean"
				End if 
			End if 
		End if 
	End if 
	
	If (ELC_isEsteeLauderCompany([Customers_Bills_of_Lading:49]CustID:2))  // Modified by: Mel Bohince (5/25/16) yet another stupid request
		If (Not:C34([Customers_Bills_of_Lading:49]International:10))  //(ADDR_getCountry ([Customers_Bills_of_Lading]ShipTo)="USA")  //($domestic)
			If (Position:C15("Bill Freight To"; [Customers_Bills_of_Lading:49]Notes:7)=0)
				[Customers_Bills_of_Lading:49]Notes:7:="Bill Freight To: Estee Lauder c/o Technical Traffic 30 Hemlock Dr Congers NY 10920"
			End if 
		End if 
	End if 
	
	[Customers_Bills_of_Lading:49]BillTo_BOL:25:=[Customers_ReleaseSchedules:46]Billto_BOL:43
	
	[Customers_Bills_of_Lading:49]FOB:15:=[Customers_Orders:40]FOB:25
	
	If ($setPayUse)
		[Customers_Bills_of_Lading:49]PayUseFlag:11:=[Customers_ReleaseSchedules:46]PayU:31
		[Customers_Bills_of_Lading:49]PayUse:23:=([Customers_Bills_of_Lading:49]PayUseFlag:11=1)
		sPayU:=([Customers_Bills_of_Lading:49]PayUseFlag:11*"Pay-U")+([Customers_Bills_of_Lading:49]PayUseFlag:11*" ")
	End if 
	
	$0:=True:C214
	
Else 
	uConfirm("Problems: "+$problems; "Try Again"; "Help")
	$0:=False:C215
	//If (OK=0) & (Current user="Designer")
	//$0:=True
	//End if 
	
End if 