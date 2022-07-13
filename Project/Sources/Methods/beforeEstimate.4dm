//%attributes = {"publishedWeb":true}
//(p)BeforeEstimate
//C_BOOLEAN(fFromDiff)
//fFromDiff:=False  `tells CartonSpec what relations are allowed.
//mod 9/22/94 upr 1162, 1186
//upr 1240 10/10/94
//upr 95 10/11/94
//upr 1115   11/18/94 chip
//upr 1138b 2/15/95
//• 12/2/97 cs remove creation of Est_Ship_to records Jim b Request
//• 1/9/98 cs added code to reset ids at start of year
//• 1/9/98 cs enabled delete button for new records & mod records
//• 3/25/98 cs ralph request for a change of default on breakoutspl
//090198 calc with spl rates
//•010499  MLB  fix id and chg to function
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Projects:9])
READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([Raw_Materials_Groups:22])
READ ONLY:C145([Salesmen:32])  // Modified by: Mel Bohince (12/11/20) 
READ ONLY:C145([Finished_Goods_SizeAndStyles:132])  // Modified by: Mel Bohince (12/11/20) 
READ ONLY:C145([Finished_Goods_Classifications:45])  // Modified by: Mel Bohince (12/11/20) 

If (Not:C34(User_AllowedCustomer([Estimates:17]Cust_ID:2; ""; "via EST:"+[Estimates:17]EstimateNo:1)))
	bDone:=1
	CANCEL:C270
End if 

Case of 
		//: (Current user="Designer")  // | (Current user="Kris Koertge")
		//uConfirm ("Simulate Saleman/SaleCoordinator mode?";"Yes";"No")
		//If (OK=1)
		//testRestrictions:=True
		//Else 
		//testRestrictions:=False
		//End if 
	: (<>fisSalesRep)
		testRestrictions:=True:C214
	: (<>fisCoord)
		testRestrictions:=True:C214
	Else 
		testRestrictions:=False:C215
End case 
SetObjectProperties("restricted_access"; -><>NULL; testRestrictions)

MESSAGES OFF:C175
C_LONGINT:C283(bTestRates)  //090198
bTestRates:=0  //090198
COPY ARRAY:C226(<>asEstStat; astat)  //upr 1138b 2/15/95 localize this array

ARRAY TEXT:C222(aReports; 0)
ARRAY TEXT:C222(aReports; 7)
aReports{1}:="Pick One"
aReports{2}:="-"
aReports{3}:="RFQ"
aReports{4}:="Cost & Quantity"
aReports{5}:="Quote..."
aReports{6}:="Quote Detail"
aReports{7}:="Quote Letter"
aReports:=1
If (Length:C16([Estimates:17]Comments:34)>0)
	$msg:=Replace string:C233([Estimates:17]Comments:34; "Based on Estimate Number "; "via:")
	util_FloatingAlert("Comments:"+Char:C90(13)+$msg)
End if 

ARRAY TEXT:C222(aORqty; 0)
ARRAY LONGINT:C221(aORund; 0)
ARRAY LONGINT:C221(aORove; 0)

OBJECT SET ENABLED:C1123(bDelete; False:C215)

SetObjectProperties(""; ->bEditPSpec; True:C214; "Edit")
SetObjectProperties(""; ->bEditCartn; True:C214; "Edit")
SetObjectProperties(""; ->bEditDiff; True:C214; "Edit")

$onePageEstimate:=False:C215

Case of   //•1/06/00  mlb  UPR try to avoid id collisions
	: (Is new record:C668([Estimates:17]))
		Estimate_new($onePageEstimate)
		
	: (iMode=2)  //modify mode  `1162    
		Case of 
			: (Estimate_StatusCheck)
				CANCEL:C270
			: (Estimate_UserCheck)
				CANCEL:C270
		End case 
		fModCForm:=False:C215  //tells [caseform] that it was accessed via included and not directly.
		
		Cust_getBrandLines([Estimates:17]Cust_ID:2; ->aBrand)
		
		Case of 
			: (Position:C15([Estimates:17]Status:30; "Quoted Priced Excess RFQ")>0)
				
			: (Position:C15([Estimates:17]Status:30; "Accepted Order")>0)
				ARRAY TEXT:C222(astat; 1)
				astat{1}:=[Estimates:17]Status:30
				ARRAY TEXT:C222(aBrand; 1)
				aBrand{1}:=[Estimates:17]Brand:3
		End case 
		
		If ([Estimates:17]JobNo:50=0)
			SetObjectProperties(""; ->bReviseJob; True:C214; "Create Job")
		Else 
			SetObjectProperties(""; ->bReviseJob; True:C214; "Revise Job")
		End if 
		
		OBJECT SET ENABLED:C1123(bDelete; True:C214)
		
	: (iMode=3)  //insure that all records searched are NOT locked    
		ARRAY TEXT:C222(astat; 1)
		astat{1}:=[Estimates:17]Status:30
		ARRAY TEXT:C222(aBrand; 1)
		aBrand{1}:=[Estimates:17]Brand:3
		
		READ ONLY:C145([Finished_Goods:26])
		READ ONLY:C145([Estimates_Materials:29])
		READ ONLY:C145([Estimates_Machines:20])
		READ ONLY:C145([Customers_Addresses:31])
		READ ONLY:C145([Estimates_Carton_Specs:19])
		READ ONLY:C145([Estimates_DifferentialsForms:47])
		
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bDupPspec; False:C215)
		OBJECT SET ENABLED:C1123(bAddPS; False:C215)
		OBJECT SET ENABLED:C1123(bDelPS; False:C215)
		OBJECT SET ENABLED:C1123(bDupCarton; False:C215)
		OBJECT SET ENABLED:C1123(bAddCarton; False:C215)
		OBJECT SET ENABLED:C1123(bDelCarton; False:C215)
		OBJECT SET ENABLED:C1123(bRefresh; False:C215)
		OBJECT SET ENABLED:C1123(bRunEstCalc; False:C215)
		OBJECT SET ENABLED:C1123(bTestRates; False:C215)
		OBJECT SET ENABLED:C1123(bDupGrp; False:C215)
		OBJECT SET ENABLED:C1123(bAddDiff; False:C215)
		OBJECT SET ENABLED:C1123(bDupDiff; False:C215)
		OBJECT SET ENABLED:C1123(bDelDiff; False:C215)
		
		If ([Estimates:17]JobNo:50#0)
			SetObjectProperties(""; ->bReviseJob; True:C214; "Review Job")
		Else 
			SetObjectProperties(""; ->bReviseJob; True:C214; "Create Job")
			OBJECT SET ENABLED:C1123(bReviseJob; False:C215)
		End if 
		
		SetObjectProperties(""; ->bEditPSpec; True:C214; "View")
		SetObjectProperties(""; ->bEditCartn; True:C214; "View")
		SetObjectProperties(""; ->bEditDiff; True:C214; "View")
End case 
wWindowTitle("push"; "Estimate "+[Estimates:17]EstimateNo:1)
gEstimateLDWkSh("Wksht")
C_REAL:C285(rTotal1; rTotal2; rTotal3; rTotal4; rTotal5; rTotal6)
rTotal1:=Sum:C1([Estimates_Carton_Specs:19]Qty1Temp:52)
rTotal2:=Sum:C1([Estimates_Carton_Specs:19]Qty2Temp:53)
rTotal3:=Sum:C1([Estimates_Carton_Specs:19]Qty3Temp:54)
rTotal4:=Sum:C1([Estimates_Carton_Specs:19]Qty4Temp:55)
rTotal5:=Sum:C1([Estimates_Carton_Specs:19]Qty5Temp:56)
rTotal6:=Sum:C1([Estimates_Carton_Specs:19]Qty6Temp:57)

If ([Customers_Projects:9]id:1#[Estimates:17]ProjectNumber:63)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Estimates:17]ProjectNumber:63)
End if 

If ([Customers_Projects:9]Customerid:3#[Estimates:17]Cust_ID:2)
	uConfirm([Estimates:17]ProjectNumber:63+" is not a valid project for customer "+[Estimates:17]Cust_ID:2; "OK"; "Help")
	If (iMode=1) | (iMode=2)
		[Estimates:17]ProjectNumber:63:=""
		SAVE RECORD:C53([Estimates:17])
		If (Not:C34(User in group:C338(Current user:C182; "RoleSuperUser")))
			CANCEL:C270
		End if 
	End if 
End if 

ORDER BY:C49([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2; >)

If (testRestrictions)
	estimateDifferentialPage:=2
	SetObjectProperties(""; ->bEditDiff; True:C214; "View")
Else 
	estimateDifferentialPage:=1
	If (iMode=1) | (iMode=2)
		SetObjectProperties(""; ->bEditDiff; True:C214; "Edit")
	Else 
		SetObjectProperties(""; ->bEditDiff; True:C214; "View")
	End if 
End if 

CREATE EMPTY SET:C140([Estimates_Differentials:38]; "clickedDifferential")

util_ComboBoxSetup(->aBrand; [Estimates:17]Brand:3)
util_ComboBoxSetup(->astat; [Estimates:17]Status:30)
<>jobform:=String:C10([Estimates:17]JobNo:50)