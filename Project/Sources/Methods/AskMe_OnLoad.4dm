//%attributes = {"publishedWeb":true}
// Method: AskMe_OnLoad
// ----------------------------------------------------
// User name (OS): MLB
// Date: 020896
// ----------------------------------------------------
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------
// Modified by: Mel Bohince (5/14/20) add user group for the All checkboxes

C_LONGINT:C283(BillingId)
fAdHoc:=False:C215
iMode:=3  //pBeforeAskMe
BillingId:=0  //process id for the PayU billing layout
fAdHocLocal:=False:C215
sCPN:=""
sCustID:=""
sBrand:=""
sDesc:=""
sCustName:=""
iBillAndHoldQty:=0
totalDemand:=0
totalSupply:=0
totalStatus:=0
iitotal1:=0
iitotal2:=0
iitotal3:=0
iitotal4:=0
bCache:=0
READ ONLY:C145([Job_Forms:42])  // Modified by: Mel Bohince (1/16/20) 

SetObjectProperties(""; ->bFgNotes; True:C214; "")  //Yes "" is correct
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)

CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "displayOrders")  //•021596  mBohince  
CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "oneLoaded")
CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "displayRels")
CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "twoLoaded")
CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "threeLoaded")
CREATE EMPTY SET:C140([Job_Forms_Items:44]; "fourLoaded")

Case of   // Modified by: Mel Bohince (5/14/20) add user group for the All checkboxes
	: (User in group:C338(Current user:C182; "AskMeShowAllCheckboxes"))  //was RoleQA and RoleMaterialHandler
		allorderlines:=1
		allinventory:=1
		allreleases:=1
		alljobs:=1
		
	Else 
		allorderlines:=0
		allinventory:=0
		allreleases:=0
		alljobs:=0
End case 

sCustID:=<>AskMeCust
<>AskMeCust:=""
If (<>AskMeFG#"")
	sAskMeCPN(<>AskMeFG)
	<>AskMeFG:=""
	
Else 
	sAskMeButtons(0)
End if 