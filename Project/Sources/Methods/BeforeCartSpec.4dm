//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): cs
// Date: 10/16/97
// ----------------------------------------------------
// Method: BeforeCartSpec
// ----------------------------------------------------
//
// Modified by: Garri Ogata (9/21/21) - Add EsCS_SetItemT to find unreproducable error

If (Not:C34(User_AllowedCustomer([Estimates_Carton_Specs:19]CustID:6; ""; "via CSP:"+[Estimates_Carton_Specs:19]ProductCode:5)))
	bDone:=1
	CANCEL:C270
End if 

wWindowTitle("push"; "Carton Spec for Est "+[Estimates_Carton_Specs:19]Estimate_No:2+"Diff: "+[Estimates_Carton_Specs:19]diffNum:11+" Item: "+[Estimates_Carton_Specs:19]Item:1+" : "+[Estimates_Carton_Specs:19]ProductCode:5)
OBJECT SET ENABLED:C1123(bDelete; False:C215)
OBJECT SET ENABLED:C1123(bTrashCarto; False:C215)
If (Is new record:C668([Estimates_Carton_Specs:19]))
	[Estimates_Carton_Specs:19]Estimate_No:2:=[Estimates:17]EstimateNo:1
	[Estimates_Carton_Specs:19]diffNum:11:=<>sQtyWorksht  //defined in OOCompileString() indicates a Quantity worksheet record
	//[Estimates_Carton_Specs]Item:=String(nextItem;"00")
	[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(nextItem)
	
	nextItem:=nextItem+1  //see plus button on Estimate Worksheet
	[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
	[Estimates_Carton_Specs:19]Classification:72:="20"  //• 1/21/98 cs default to 
	[Estimates_Carton_Specs:19]OriginalOrRepeat:9:="Original"
	[Estimates_Carton_Specs:19]zCount:51:=1
	[Estimates_Carton_Specs:19]PONumber:73:=[Estimates:17]POnumber:18
	//• 1/10/97 -cs - mods for multiple customer/job
	If ([Estimates:17]Cust_ID:2=<>sCombindID)  //if this is a combined job
		[Estimates_Carton_Specs:19]CustID:6:=""  //do not specify the customer id
	Else   //get carton spec data from Estimate 
		[Estimates_Carton_Specs:19]CustID:6:=[Estimates:17]Cust_ID:2
	End if 
	CartSpecOvrUndr("*")
End if 

If ([Estimates_Carton_Specs:19]StripHoles:46)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowMatl:35; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowGauge:36; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowWth:37; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowHth:38; True:C214; ""; True:C214)  // Modified by: Mark Zinke (4/26/13)
Else   //•061395  MLB  UPR 1637
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowMatl:35; True:C214; ""; False:C215)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowGauge:36; True:C214; ""; False:C215)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowWth:37; True:C214; ""; False:C215)  // Modified by: Mark Zinke (4/26/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowHth:38; True:C214; ""; False:C215)  // Modified by: Mark Zinke (4/26/13)
End if 

If (iMode>2)
	OBJECT SET ENABLED:C1123(bChange; False:C215)
	OBJECT SET ENABLED:C1123(bZoomCode; False:C215)
	OBJECT SET ENABLED:C1123(iTotal; False:C215)
	OBJECT SET ENABLED:C1123(iTotal2; False:C215)
End if 

qryFinishedGood("#CPN"; [Estimates_Carton_Specs:19]ObsoleteCPN:63)
QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Estimates_Carton_Specs:19]Classification:72)
RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)

RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)  //see what forms they are on

If ([Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)  //defined in OOCompileString() indicates a Quantity worksheet record
	SetObjectProperties("want@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/9/13) Doesn't apply for Worksheet cartons
Else 
	SetObjectProperties("want@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/9/13) Doesn't apply for Worksheet cartons
End if 

$CombinedJob:=([Estimates:17]Cust_ID:2=<>sCombindID)
SetObjectProperties(""; ->[Estimates_Carton_Specs:19]CustID:6; True:C214; ""; $CombinedJob)  // Modified by: Mark Zinke (4/26/13)
If ($CombinedJob)
	OBJECT SET ENABLED:C1123(bZoomCust; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bZoomCust; False:C215)
End if 

If (<>fisSalesRep) | (<>fisCoord)
	SetObjectProperties("cost@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/9/13) 
Else 
	SetObjectProperties("cost@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/9/13) 
End if 