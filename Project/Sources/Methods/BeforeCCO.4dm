//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): cs
// Date: 10/16/97
// ----------------------------------------------------
// Method: BeforeCCO
// ----------------------------------------------------

C_DATE:C307(dDate1)  //• 7/24/97 cs 

MESSAGES OFF:C175
COPY ARRAY:C226(<>asChgStat; asChgStat)  //3/8/95   

FORM GOTO PAGE:C247(1)  // • mel (11/4/04, 10:11:13)aways force gatekeeping 

dDate1:=[Customers_Orders:40]NeedDate:51  //• 7/24/97 cs track order need date
sOCHAction:=fGetMode(iMode)

OBJECT SET ENABLED:C1123(hdFGIS; False:C215)  //delete button

$permitEntries:=False:C215  // • mel(11/4/4101113)refactor

If (fLoop)
	OBJECT SET ENABLED:C1123(bZoomOrd; False:C215)  //we just came from there
End if 

Case of 
	: (Record number:C243([Customers_Order_Change_Orders:34])=-3)
		uNewRecReject("You are not permitted to create a Change Order in this manner!")
		
		//note that since subrecords cant be set to non-enterable,
		//the accept btn must be disabled sometimes.
		
	: (iMode>2)  //review
		//no worries
		
	: (Locked:C147([Customers_Order_Change_Orders:34]))  //its locked, nothing can be done anyway      
		BEEP:C151
		ALERT:C41("Change order is locked, try again later.")
		
	: (Position:C15("New"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)#0)
		$permitEntries:=True:C214
		
	: (Position:C15("Customer Service"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)#0)  //upr 1242 3/1/95
		If (User in group:C338(Current user:C182; "CustomerService"))  //lock out other users
			$permitEntries:=True:C214
		End if 
		
	: (Position:C15("Pricing"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)#0)
		If (User in group:C338(Current user:C182; "CCO_Approval"))
			$permitEntries:=True:C214
		End if 
		
	: (Position:C15("Open"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)#0)
		If (User in group:C338(Current user:C182; "Planners"))
			$permitEntries:=True:C214
		End if 
		
	Else 
		//must be in "Proceed@" | "Reject@") | "Cancel@"
End case 

If ($permitEntries) | (Current user:C182="Designer")
	uSetEntStatus(->[Customers_Order_Change_Orders:34]; True:C214)
	OBJECT SET ENABLED:C1123(bNLine; True:C214)
	OBJECT SET ENABLED:C1123(bDLine; True:C214)
	OBJECT SET ENABLED:C1123(bPriceChg; True:C214)
	OBJECT SET ENABLED:C1123(*; "save@"; True:C214)
	asChgStat:=Find in array:C230(asChgStat; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)
Else 
	uSetEntStatus(->[Customers_Order_Change_Orders:34]; False:C215)
	OBJECT SET ENABLED:C1123(bNLine; False:C215)
	OBJECT SET ENABLED:C1123(bDLine; False:C215)
	OBJECT SET ENABLED:C1123(bPriceChg; False:C215)
	OBJECT SET ENABLED:C1123(*; "save@"; False:C215)  //upr 1438 2/28/95
	ARRAY TEXT:C222(asChgStat; 1)
	asChgStat{1}:=[Customers_Order_Change_Orders:34]ChgOrderStatus:20
End if 

//input logic
OBJECT SET ENABLED:C1123(bItemPage; True:C214)
Case of   //• mel (11/4/04, 10:11:13) refactor
	: ([Customers_Order_Change_Orders:34]AddOrDeleteItem:13)
	: ([Customers_Order_Change_Orders:34]Cancel_:32)
	: ([Customers_Order_Change_Orders:34]GraphicChg:12)
	: ([Customers_Order_Change_Orders:34]HoldOtherReason:31)
	: ([Customers_Order_Change_Orders:34]ProcessChg:9)
	: ([Customers_Order_Change_Orders:34]QtyChg:8)
	: ([Customers_Order_Change_Orders:34]SizeChg:7)
	: ([Customers_Order_Change_Orders:34]SpecialServiceC:11)
	: ([Customers_Order_Change_Orders:34]PriceChg:21)
	Else 
		zwStatusMsg("†"; "New Estimate not required")
		OBJECT SET ENABLED:C1123(bItemPage; False:C215)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]AddOrDeleteItem:13; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]Cancel_:32; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]GraphicChg:12; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]HoldOtherReason:31; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]ProcessChg:9; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]QtyChg:8; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]SizeChg:7; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]SpecialServiceC:11; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
		SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]PriceChg:21; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
End case 

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
//• 5/22/97 cs upr 1882 start
C_BOOLEAN:C305(fOnlyOne)
C_LONGINT:C283($numRels)
$numRels:=0  // Modified by: Mel Bohince (6/9/21) 
SET QUERY DESTINATION:C396(Into variable:K19:4; $numRels)
READ ONLY:C145([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=String:C10([Customers_Order_Change_Orders:34]OrderNo:5)+"@"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
If ($numRels>0)
	ALERT:C41("This order has started shipping!")  //• 5/22/97 cs warn that this order has started shipping
	fOnlyOne:=True:C214
Else 
	fOnlyOne:=False:C215
End if 

selected_item:=0