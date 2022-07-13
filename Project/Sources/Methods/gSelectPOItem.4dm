//%attributes = {"publishedWeb":true}
//gSelectPOItem: Procedure for selecting from PO Item array
//• 1/13/97 upr 0235 - cs - modification to insure that the default 
//  bin location is better selected.
//•2/13/97 cs - allow user to change location while tracking company seperatly
//• 6/20/97 cs determine department description, and display who/dept ordered item
//• 8/20/97 cs replaced alert about <10 rule
//• 11/4/97 cs insure that enterablity of rqty2 is set corrrectly
//• 5/21/98 cs coversion between 3UOM was not working correctly
//•4/26/00  mlb go back to setting by recervers location

OBJECT SET ENABLED:C1123(bAdd; False:C215)
SetObjectProperties(""; ->rQty2; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->sRMCode; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
sBinNo:=""  //clear bin area on-site mod 12/1/94
sCompany:=""  //• clear company on site cs
gClrRMFields

If (aPOItem>0)  //user clicked on array element, not blank line 
	<>RMBarCodePO:=sPoNum+aPoItem{aPoItem}  //used for printing Barcodes
	<>RMPOICount:=aQtyAvl{aPoItem}
	sRMCode:=aPOPartNo{aPOPartNo}
	C_LONGINT:C283(receipt_type)
	receipt_type:=0
	$directPurchase:=RMG_is_DirectPurchase(aComm{aPOItem}; ->receipt_type)
	Case of 
		: (receipt_type=1)  //rm
			zwStatusMsg("INVENTORY ITEM"; "")
		: (receipt_type=2)  //dp
			POI_showJobs(<>RMBarCodePO)
		: (receipt_type=3)  //ex
			zwStatusMsg("EXPENSE ITEM"; "")
			
		Else 
			$Comm:=Num:C11(Substring:C12(aComm{aPoItem}; 1; 2))  //• 8/20/97 cs 
			
			If ($Comm<=9)  //• 8/20/97 cs rewrote alert to make it more meaningful for user
				uConfirm("Commodity "+aComm{aPOItem}+" receipt type has not been set, Defaulting to 1 - Raw material."+Char:C90(13)+"Please Report this to the Purchasing department."; "OK"; "Help")
				receipt_type:=1
			Else 
				uConfirm("Commodity "+aComm{aPOItem}+" receipt type has not been set, Defaulting to 3 - Expense Item."+Char:C90(13)+"Please Report this to the Purchasing department."; "OK"; "Help")
				receipt_type:=3
			End if 
	End case 
	
	If (sRMCode#"")
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sRMCode)
		
		If (Records in selection:C76([Raw_Materials:21])>0)
			OBJECT SET ENABLED:C1123(bAdd; True:C214)
			SetObjectProperties(""; ->rQty2; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			sDesc:=[Raw_Materials:21]Description:4
			sPONumber:=sPONum
			sItemNumber:=aPOItem{aPOItem}
			vendor_bin:=SupplyChain_BinManager("supplied-to-vendor?"; sPONum)
			SetObjectProperties(""; ->sBinNo; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
			Case of 
				: (Length:C16(vendor_bin)>0)
					sBinNo:=vendor_bin
					SetObjectProperties(""; ->sBinNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
					sCompany:="Roanoke"
				: (User in group:C338(Current user:C182; "RoanokeWarehouse"))
					sBinNo:="Roanoke"
					sCompany:="Roanoke"
				: (User in group:C338(Current user:C182; "Roanoke"))
					sBinNo:="Roanoke"  //•091196  MLB  
					sCompany:=sBinNo
				Else 
					sBinNo:="Roanoke"  //`• mlb - 7/11/02  13:51
					sCompany:=sBinNo
			End case 
			
			//• 2/13/97 cs on site allow user to change location and then specify company     
			rQty:=0
			rQty2:=0
			sUM2:=aUM1{aPOItem}  //Arkay  `• 5/21/98 cs reverse so that recev quantity converts to issue quantity
			sUM1:=aUM2{aPOItem}  //ship
			sUM3:=aUM3{aPOItem}
			r2:=arNum1{aPOPrice}
			r1:=arDenom1{aPOPrice}
			rPOPrice:=aPOPrice{aPOPrice}
			//• 5/21/98 cs incomplete price convert when there are 3 Uom ex:lf -> Rolls -> Msf
			//  following code converts from billing units -> shipping units -> Arkay units
			rPriceConv:=arNum2{aPOPrice}/arDenom2{aPOPrice}  //shipping to billing = ([PO_ITEMS]FactNship2price/[PO_ITEMS]FactDship2price)
			rPriceConv:=rPriceConv*(r2/r1)  //arkay to shipping =([PO_ITEMS]FactNship2cost/[PO_ITEMS]FactDship2cost
			rActPrice:=aPOPrice{aPOPrice}*rPriceConv
			
			sCC:=aRep{aPoItem}  //• 6/20/97 cs who ordered item
			sName:=User_ResolveInitials(sCC)
			$Loc:=Find in array:C230(<>aDepartment; aDeptCode{aPoItem}+"@")  //locate department description  
			
			If ($Loc>0)
				sLocation:=<>aDepartment{$loc}
			Else 
				sLocation:=aDeptCode{aPoItem}
			End if 
			
			If (Length:C16(sReceiveNum)>3)  //A-1 would have been a failure to get
				POI_ReceivingNumberManager("setNext"; 0)  //release the number
			End if 
			sReceiveNum:=POI_ReceivingNumberManager("getNext")
			
			GOTO OBJECT:C206(rQty)
			
		Else 
			uConfirm("RM code "+sRMCode+" was not found."; "Try Again"; "Help")
		End if 
		
	Else 
		uConfirm("ERROR: Blank R/M Code!  Entry needed by Purchasing Dept."; "OK"; "Help")
	End if 
End if 