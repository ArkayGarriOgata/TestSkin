//%attributes = {"publishedWeb":true}
//(p) BeforeRelease
//moved code from Before phase here - effieceny
//• 10/23/97 cs created
//4/25/95 this is so sales can use Askme
//5/4/95 add brand to release for Shipment qty by cust and brand rpt
//•061495  MLB  UPR 176 add count
//•092695  MLB  UPR 1729
//•101095  MLB  default the payU state
//•022597  MLB  clear some selections
//•102297  MLB  Chg Defaut to THC state
//`03/29/12 mlb - disable payuse btn, hasn't been needed and being turned on inadvertantly
// SetObjectProperties, Mark Zinke (5/16/13)

ARRAY TEXT:C222(aShiptos; 0)
ARRAY TEXT:C222(aBilltos; 0)

OBJECT SET ENABLED:C1123(bInvoice; False:C215)
OBJECT SET ENABLED:C1123(bASN; False:C215)

Case of 
	: (Is new record:C668([Customers_ReleaseSchedules:46]))
		[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
		[Customers_ReleaseSchedules:46]OrderNumber:2:=[Customers_Order_Lines:41]OrderNumber:1
		[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
		[Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17
		[Customers_ReleaseSchedules:46]Billto:22:=[Customers_Order_Lines:41]defaultBillto:23
		[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Lines:41]ProductCode:5
		[Customers_ReleaseSchedules:46]CustID:12:=[Customers_Order_Lines:41]CustID:4
		[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Customers_Order_Lines:41]PONumber:21
		[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Order_Lines:41]CustomerLine:42  //•060295  MLB  UPR 184
		[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
		[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
		[Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Order_Lines:41]PayUse:47)  //•101095  MLB 
		[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
		[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
		[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Customers_Order_Lines:41]ProjectNumber:50  //•5/04/00  mlb 
		[Customers_ReleaseSchedules:46]B_O_L_pending:45:=0
		//5/4/95 begin
		If ([Customers_Orders:40]OrderNumber:1#[Customers_ReleaseSchedules:46]OrderNumber:2)
			READ ONLY:C145([Customers_Orders:40])
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_ReleaseSchedules:46]OrderNumber:2)
		End if 
		[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Orders:40]CustomerLine:22
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_ReleaseSchedules:46]CustID:12; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Bill to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aBilltos)
		aBilltos{0}:=[Customers_ReleaseSchedules:46]CustID:12
		SORT ARRAY:C229(aBilltos; >)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_ReleaseSchedules:46]CustID:12; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aShiptos)
		aShiptos{0}:=[Customers_ReleaseSchedules:46]CustID:12
		SORT ARRAY:C229(aShiptos; >)
		REDUCE SELECTION:C351([Customers_Addresses:31]; 0)  //•022597  MLB  UPR §
		
	: (iMode>2)
		OBJECT SET ENABLED:C1123(bUp; False:C215)
		OBJECT SET ENABLED:C1123(bDown; False:C215)
		OBJECT SET ENABLED:C1123(bUp2; False:C215)
		OBJECT SET ENABLED:C1123(bDown2; False:C215)
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		//OBJECT SET ENABLED(bRerelease;False)
		OBJECT SET ENABLED:C1123(bPayU; False:C215)  //•101095  MLB
		OBJECT SET ENABLED:C1123(b_Dummy; False:C215)
		OBJECT SET ENABLED:C1123(bChg; False:C215)
		
	Else 
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_ReleaseSchedules:46]CustID:12; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Bill to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aBilltos)
		aBilltos{0}:=[Customers_ReleaseSchedules:46]CustID:12
		SORT ARRAY:C229(aBilltos; >)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_ReleaseSchedules:46]CustID:12; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aShiptos)
		aShiptos{0}:=[Customers_ReleaseSchedules:46]CustID:12
		SORT ARRAY:C229(aShiptos; >)
		REDUCE SELECTION:C351([Customers_Addresses:31]; 0)  //•022597  MLB  UPR §
		
		If ([Customers_ReleaseSchedules:46]B_O_L_number:17>0) & (User in group:C338(Current user:C182; "RoleAccounting"))
			OBJECT SET ENABLED:C1123(bInvoice; True:C214)
		End if 
		
		If ([Customers_ReleaseSchedules:46]B_O_L_number:17>0) & (User in group:C338(Current user:C182; "RolePlanner"))
			OBJECT SET ENABLED:C1123(bASN; True:C214)
		End if 
		
		If ([Customers_ReleaseSchedules:46]B_O_L_pending:45#0)
			uConfirm("Can't update release while BOL "+String:C10([Customers_ReleaseSchedules:46]B_O_L_pending:45)+"  is pending."; "OK"; "Help")
		End if 
End case 

LIST TO ARRAY:C288("ShippingMode"; aMode)
If ([Customers_ReleaseSchedules:46]Air_Shipment:51) & (Length:C16([Customers_ReleaseSchedules:46]Mode:56)=0)
	[Customers_ReleaseSchedules:46]Mode:56:="AIR"
End if 
util_ComboBoxSetup(->aMode; [Customers_ReleaseSchedules:46]Mode:56)



bPayU:=[Customers_ReleaseSchedules:46]PayU:31  //•092695  MLB  UPR 1729

C_DATE:C307(releaseFence)
releaseFence:=REL_getAvailableToPromise([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
If ([Customers_ReleaseSchedules:46]Sched_Date:5=!00-00-00!)
	[Customers_ReleaseSchedules:46]Sched_Date:5:=releaseFence
End if 

Text23:=fGetAddressText([Customers_ReleaseSchedules:46]Billto:22)
Text25:=fGetAddressText([Customers_ReleaseSchedules:46]Shipto:10)

lValue1:=0
If ([Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
	If ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
		lValue1:=[Customers_ReleaseSchedules:46]Sched_Date:5-[Customers_ReleaseSchedules:46]Actual_Date:7
	End if 
End if 

Case of   //4/25/95 this is so sales can use Askme
	: ([Customers_ReleaseSchedules:46]B_O_L_pending:45#0)
		uSetEntStatus(->[Customers_ReleaseSchedules:46]; False:C215)
		OBJECT SET ENABLED:C1123(bRefresh; False:C215)
		OBJECT SET ENABLED:C1123(bNA1; False:C215)
		OBJECT SET ENABLED:C1123(bUp; False:C215)
		OBJECT SET ENABLED:C1123(bUp2; False:C215)
		OBJECT SET ENABLED:C1123(bDown; False:C215)
		OBJECT SET ENABLED:C1123(bDown2; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bPayU; False:C215)  //•101095  MLB
		OBJECT SET ENABLED:C1123(bChg; False:C215)
		OBJECT SET ENABLED:C1123(aMode; False:C215)
		
	: (User in group:C338(Current user:C182; "SalesCoordinator"))
		uSetEntStatus(->[Customers_ReleaseSchedules:46]; False:C215)
		OBJECT SET ENABLED:C1123(bRefresh; False:C215)
		OBJECT SET ENABLED:C1123(bNA1; False:C215)
		OBJECT SET ENABLED:C1123(bUp; False:C215)
		OBJECT SET ENABLED:C1123(bUp2; False:C215)
		OBJECT SET ENABLED:C1123(bDown; False:C215)
		OBJECT SET ENABLED:C1123(bDown2; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bPayU; False:C215)  //•101095  MLB
		OBJECT SET ENABLED:C1123(bChg; False:C215)
		
	: (User in group:C338(Current user:C182; "SalesReps"))
		uSetEntStatus(->[Customers_ReleaseSchedules:46]; False:C215)
		OBJECT SET ENABLED:C1123(bRefresh; False:C215)
		OBJECT SET ENABLED:C1123(bNA1; False:C215)
		OBJECT SET ENABLED:C1123(bUp; False:C215)
		OBJECT SET ENABLED:C1123(bUp2; False:C215)
		OBJECT SET ENABLED:C1123(bDown; False:C215)
		OBJECT SET ENABLED:C1123(bDown2; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bPayU; False:C215)  //•101095  MLB
		OBJECT SET ENABLED:C1123(bChg; False:C215)
	Else 
		//no prevlges revoked
End case 

If (Length:C16([Customers_ReleaseSchedules:46]EDI_Disposition:36)>0)
	SetObjectProperties("edi@"; -><>NULL; True:C214)
Else 
	SetObjectProperties("edi@"; -><>NULL; False:C215)
End if 

If ([Customers_ReleaseSchedules:46]InvoiceNumber:9>0)
	SetObjectProperties("inv@"; -><>NULL; True:C214)
Else 
	SetObjectProperties("inv@"; -><>NULL; False:C215)
End if 

If ([Customers_ReleaseSchedules:46]B_O_L_number:17>0)
	SetObjectProperties("bol@"; -><>NULL; True:C214)
	SetObjectProperties("pending@"; -><>NULL; False:C215)
	
Else 
	SetObjectProperties("bol@"; -><>NULL; False:C215)
	If ([Customers_ReleaseSchedules:46]B_O_L_pending:45>0)
		SetObjectProperties("pending@"; -><>NULL; True:C214)
	Else 
		SetObjectProperties("pending@"; -><>NULL; False:C215)
	End if 
End if 
// Modified by: Mel Bohince (9/3/14) allow planners and csr's "mustship" access
If (User in group:C338(Current user:C182; "RoleOperations")) | (User in group:C338(Current user:C182; "RolePlanner")) | (User in group:C338(Current user:C182; "RoleCustomerService"))
	SetObjectProperties(""; ->[Customers_ReleaseSchedules:46]MustShip:53; True:C214; ""; True:C214)
Else 
	If ([Customers_ReleaseSchedules:46]MustShip:53)
		SetObjectProperties(""; ->[Customers_ReleaseSchedules:46]MustShip:53; True:C214; ""; False:C215; Red:K11:4; Light grey:K11:13)
	Else 
		SetObjectProperties(""; ->[Customers_ReleaseSchedules:46]MustShip:53; True:C214; ""; False:C215; Light grey:K11:13; Light grey:K11:13)
	End if 
End if 

t9:=THC_decode([Customers_ReleaseSchedules:46]THC_State:39)

If (Position:C15("not"; t9)>0)
	
	Core_ObjectSetColor(->bPayU; -(Black:K11:16+(256*Light blue:K11:8)))
	
Else 
	
	Core_ObjectSetColor(->bPayU; -(Black:K11:16+(256*Light blue:K11:8)))
	
End if 

OBJECT SET ENABLED:C1123(bPayU; False:C215)  //03/29/12 mlb - hasn't been needed and being turned on inadvertantly

Core_ObjectSetColor(->bPayU; -(Grey:K11:15+(256*Light blue:K11:8)))

//7/5/12 will be used for gaylords sent to rama
If ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	If ([Customers_ReleaseSchedules:46]CustID:12="00199") | ([Customers_ReleaseSchedules:46]CustID:12="00074")  // Modified by: Mel Bohince (5/13/14) add arden to payuse program
		OBJECT SET ENABLED:C1123(bPayU; True:C214)
		
		Core_ObjectSetColor(->bPayU; -(Black:K11:16+(256*Light blue:K11:8)))
		
	End if 
End if 


Case of 
	: ([Customers_ReleaseSchedules:46]CustID:12="00074")
		OBJECT SET TITLE:C194(*; "userdate1"; "Complete")
		OBJECT SET TITLE:C194(*; "userdate2"; "Expired")
		
	: ([Customers_ReleaseSchedules:46]CustID:12="02085")
		OBJECT SET TITLE:C194(*; "userdate1"; "Complete")
		OBJECT SET TITLE:C194(*; "userdate2"; "Expired")
		
	: ([Customers_ReleaseSchedules:46]CustID:12="00765")
		OBJECT SET TITLE:C194(*; "userdate1"; "Complete")
		OBJECT SET TITLE:C194(*; "userdate2"; "Expired")
		
	: (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))  // Modified by: Mel Bohince (3/5/21) 
		OBJECT SET TITLE:C194(*; "userdate1"; "TMC_EPD")
		OBJECT SET TITLE:C194(*; "userdate2"; "ARK_EPD")
		OBJECT SET TITLE:C194(*; "userdate3"; "TMC_LPD")
		OBJECT SET TITLE:C194(*; "userdefined1"; "OddLot?")
		
	Else 
		OBJECT SET TITLE:C194(*; "userdate1"; "UserDate1")
		OBJECT SET TITLE:C194(*; "userdate2"; "UserDate2")
		OBJECT SET TITLE:C194(*; "userdate3"; "UserDate3")
		OBJECT SET TITLE:C194(*; "userdefined1"; "UserDefined1")
End case 
