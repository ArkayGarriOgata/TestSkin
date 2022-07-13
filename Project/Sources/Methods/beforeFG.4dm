//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// ----------------------------------------------------
// Method: beforeFG
// Description:
// Before phase processing for [FINISHED_GOODS]
// ----------------------------------------------------

If (Not:C34(User_AllowedCustomer([Finished_Goods:26]CustID:2; ""; "via FG:"+[Finished_Goods:26]ProductCode:1)))
	bDone:=1
	CANCEL:C270
End if 

sFGAction:=fGetMode(iMode)
fFGMaint:=True:C214
<>asFGPages:=1
vAskMePID:=0

If ([Finished_Goods:26]PreflightAt:74#0)
	TS2DateTime([Finished_Goods:26]PreflightAt:74; ->dDate; ->tTime)
Else 
	dDate:=!00-00-00!
	tTime:=?00:00:00?
End if 

ARRAY TEXT:C222(aBilltos; 0)  //so arrow arrays get built on orderline and release input
ARRAY TEXT:C222(aShiptos; 0)  //so arrow arrays get built on orderline and release input

READ ONLY:C145([Estimates:17])
READ ONLY:C145([Estimates_Carton_Specs:19])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Salesmen:32])
READ ONLY:C145([Finished_Goods_Specifications:98])
READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Customers_Projects:9])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])

QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=([Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProcessSpec:33))

If (Length:C16([Finished_Goods:26]ProjectNumber:82)>0)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods:26]ProjectNumber:82)
End if 

RELATE ONE:C42([Finished_Goods:26]CustID:2)
RELATE ONE:C42([Finished_Goods:26]ControlNumber:61)  //for art dates
RELATE ONE:C42([Finished_Goods:26]OutLine_Num:4)  //for s & s dates
RELATE ONE:C42([Finished_Goods:26]ColorSpecMaster:77)  //for color

// Modified by: Mel Bohince (1/25/20) causes problems and is not necessary here:
//READ WRITE([Job_Forms_Items])//for HRD/MAD date
//QUERY([Job_Forms_Items];[Job_Forms_Items]ProductCode=[Finished_Goods]ProductCode;*)
//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Qty_Actual=0)

QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)

Case of 
	: (Is new record:C668([Finished_Goods:26]))
		sFGAction:="NEW"
		[Finished_Goods:26]Status:14:="New"
		[Finished_Goods:26]OriginalOrRepeat:71:="Original"
		[Finished_Goods:26]ModDate:24:=4D_Current_date
		[Finished_Goods:26]ModWho:25:=<>zResp
		ARRAY TEXT:C222(aBrand; 0)
		aBrand{0}:=""
		
		Case of 
			: (sFile="Estimate")  //got here via the estimate screen
				[Finished_Goods:26]ProductCode:1:=[Estimates_Carton_Specs:19]ProductCode:5
				[Finished_Goods:26]CustID:2:=[Estimates:17]Cust_ID:2
				[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
				[Finished_Goods:26]Line_Brand:15:=[Estimates:17]Brand:3
				[Finished_Goods:26]ProjectNumber:82:=[Estimates:17]ProjectNumber:63
				RELATE ONE:C42([Finished_Goods:26]CustID:2)
				If ([Finished_Goods:26]CustID:2#"")
					uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
					aBrand{0}:=aBrand{aBrand}
				End if 
				
			: (Length:C16(<>pjtId)=5)  //got here via the project screen
				[Finished_Goods:26]ProjectNumber:82:=<>pjtId
				READ ONLY:C145([Customers_Projects:9])
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=<>pjtId)
				
				If ([Customers_Projects:9]PromotionalPjt:8)
					[Finished_Goods:26]OrderType:59:="Promotional"
				Else 
					[Finished_Goods:26]OrderType:59:="Regular"
				End if 
				
				If ([Customers_Projects:9]LaunchProject:17)
					[Finished_Goods:26]DateLaunchReceived:84:=4D_Current_date
				End if 
				
				[Finished_Goods:26]ELProject:81:=Substring:C12([Customers_Projects:9]Name:2; 1; 20)
				[Finished_Goods:26]Developer:78:=Substring:C12([Customers_Projects:9]Name:2; 1; 20)
				
				[Finished_Goods:26]CustID:2:=[Customers_Projects:9]Customerid:3
				[Finished_Goods:26]Line_Brand:15:=Substring:C12([Customers_Projects:9]Name:2; 1; 20)
				
				If ([Finished_Goods:26]CustID:2#"")
					RELATE ONE:C42([Finished_Goods:26]CustID:2)
					FgArtDefaults  //set enterablity of & possibly values of art fields
					uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
					If (aBrand>-1)  //valid line requested
						[Finished_Goods:26]Developer:78:=""  //can't be the developer
					Else 
						[Finished_Goods:26]Line_Brand:15:=""  //gonna have to pick from combo
					End if 
				End if 
				GOTO OBJECT:C206([Finished_Goods:26]ProductCode:1)
		End case 
		
	: (iMode=2)
		uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
		If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
			If ([Finished_Goods:26]DateSnSReceived:57=!00-00-00!)
				[Finished_Goods:26]DateSnSReceived:57:=[Finished_Goods_SizeAndStyles:132]DateCreated:3
			End if 
			
			If ([Finished_Goods_SizeAndStyles:132]Approved:9)
				[Finished_Goods:26]DateSnS_Approved:83:=[Finished_Goods_SizeAndStyles:132]DateApproved:8
			End if 
		End if 
		
		If (Records in selection:C76([Finished_Goods_Color_SpecMaster:128])>0)
			If ([Finished_Goods_Color_SpecMaster:128]Approved:23)
				[Finished_Goods:26]DateColorApproved:86:=[Finished_Goods_Color_SpecMaster:128]DateReturned:22
			End if 
		End if 
		
	: (iMode=3)  //review mode, 2/6/95 chip stop unneeded record locking
		uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
		
		OBJECT SET ENABLED:C1123(mbLock1; False:C215)  //locked
		OBJECT SET ENABLED:C1123(mbLock2; False:C215)  //open
		OBJECT SET ENABLED:C1123(aBrand; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		OBJECT SET ENABLED:C1123(bRenameFG; False:C215)  //•060796  MLB  
		OBJECT SET ENABLED:C1123(bDupFG; False:C215)
		OBJECT SET ENABLED:C1123(bDupFG2; False:C215)
		OBJECT SET ENABLED:C1123(bFixFG; False:C215)  //•060796  MLB 
		OBJECT SET ENABLED:C1123(bFix; False:C215)
		OBJECT SET ENABLED:C1123(aBrand; False:C215)
		OBJECT SET ENABLED:C1123(bAddSub; False:C215)
		OBJECT SET ENABLED:C1123(bDeleteSub; False:C215)
		OBJECT SET ENABLED:C1123(bRejected; False:C215)
		OBJECT SET ENABLED:C1123(b_dummy; False:C215)
		OBJECT SET ENABLED:C1123(b_Mad; False:C215)
		
	: (iMode=4)
		
	Else 
		uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
		
End case 

If ([Finished_Goods:26]Status:14="Final") | (Position:C15("obsolete"; [Finished_Goods:26]Status:14)>0)
	FG_LockDown(True:C214)
Else 
	FG_LockDown(False:C215)
End if 

If (User in group:C338(Current user:C182; "RoleAccounting")) | (True:C214)
	SetObjectProperties(""; ->[Finished_Goods:26]Bill_and_Hold_Qty:108; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]InventoryLiability:111; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties(""; ->[Finished_Goods:26]Bill_and_Hold_Qty:108; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]InventoryLiability:111; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (User in group:C338(Current user:C182; "RoleQA_Mgr"))
	SetObjectProperties(""; ->[Finished_Goods:26]BoardCOC_Type:109; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties(""; ->[Finished_Goods:26]BoardCOC_Type:109; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 