//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/12/06, 12:29:21
// ----------------------------------------------------
// Method: POI_ItemsToReceive
// ----------------------------------------------------

C_LONGINT:C283($1; numItems; $item; $pending)
C_TEXT:C284($2)

If (Count parameters:C259>=2)
	Case of 
		: ($2="Load")
			POI_ItemsToReceive(0)
			SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]ItemNo:3; aPOItem; [Purchase_Orders_Items:12]Qty_Shipping:4; aPOQty; [Purchase_Orders_Items:12]Qty_Open:27; aQtyAvl; [Purchase_Orders_Items:12]Raw_Matl_Code:15; aPOPartNo; [Purchase_Orders_Items:12]UnitPrice:10; aPOPrice; [Purchase_Orders_Items:12]UM_Arkay_Issue:28; aUM1; [Purchase_Orders_Items:12]UM_Ship:5; aUM2; [Purchase_Orders_Items:12]FactNship2cost:29; arNum1; [Purchase_Orders_Items:12]FactDship2cost:37; arDenom1; [Purchase_Orders_Items:12]FactNship2price:25; arNum2; [Purchase_Orders_Items:12]FactDship2price:38; arDenom2; [Purchase_Orders_Items:12]Commodity_Key:26; aComm; [Purchase_Orders_Items:12]RM_Description:7; axPoRemark; [Purchase_Orders_Items:12]CompanyID:45; aCompany; [Purchase_Orders_Items:12]DepartmentID:46; aDeptCode; [Purchase_Orders_Items:12]ReqnBy:18; aRep; [Purchase_Orders_Items:12]UM_Price:24; aUM3)
			SORT ARRAY:C229(aPOItem; aPOQty; aQtyAvl; aPOPartNo; aPOPrice; aUM1; aUM2; aUM3; arNum1; arDenom1; arNum2; arDenom2; aComm; axPoRemark; aDeptCode; aRep; >)  //1/23/95
			aPOItem:=1  //2/9/95
			aPOQty:=1
			aQtyAvl:=1
			aPOPartNo:=1
			aPOPrice:=1
			aUM1:=1
			aUM2:=1
			aUM3:=1
			arNum1:=1
			arDenom1:=1
			arNum2:=1
			arDenom2:=1
			aComm:=1
			axPoRemark:=1
			aRep:=1
			
			//look to see if this is a re-entry to the po with posts pending
			If (numToPost>0)  //set by POI_ItemsToPost
				For ($pending; 1; numToPost)
					For ($item; 1; Size of array:C274(aPOItem))
						If (aRMPONum{$pending}=sPOnum) & (aRMPOItem{$pending}=aPOItem{$item})  //then reduce the qty
							aQtyAvl{$item}:=aQtyAvl{$item}-aRMPOQty{$pending}
						End if 
					End for 
				End for 
			End if 
	End case 
	
Else 
	$size:=$1
	ARRAY TEXT:C222(aPOItem; $size)
	ARRAY TEXT:C222(aUM1; $size)
	ARRAY TEXT:C222(aUM2; $size)
	ARRAY TEXT:C222(aUM3; $size)
	ARRAY REAL:C219(aPOQty; $size)
	ARRAY REAL:C219(aQtyAvl; $size)
	ARRAY TEXT:C222(aPOPartNo; $size)
	ARRAY REAL:C219(aPOPrice; $size)
	ARRAY REAL:C219(arNum1; $size)
	ARRAY REAL:C219(arDenom1; $size)
	ARRAY REAL:C219(arNum2; $size)
	ARRAY REAL:C219(arDenom2; $size)
	ARRAY TEXT:C222(aComm; $size)
	ARRAY TEXT:C222(aCompany; $size)  //• 1/13/97 added to allow tracking/default of company the po item is for
	ARRAY TEXT:C222(axPoRemark; $size)
	ARRAY TEXT:C222(aRep; $size)
End if 

numItems:=Size of array:C274(aPOItem)