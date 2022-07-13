//%attributes = {"publishedWeb":true}
//(p) ReqCommCode
//code called to handle commodity code in layout [po_item]ReqItems
//• 6/30/97 cs created
//• 9/4/97 cs try to solve some problems Carol is having with array ranges-subgrp
//• 9/18/97 cs START to restrict deptarments and expense codes

C_TEXT:C284($ComKey)

If (Find in array:C230(aCommCode; String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"@")>0)
	If ([Purchase_Orders_Items:12]SubGroup:13="")
		PoItemBldSubGrp
	Else 
		PoItemBldSubGrp([Purchase_Orders_Items:12]SubGroup:13)
	End if 
	
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		If (iComm#[Purchase_Orders_Items:12]CommodityCode:16)  //need to refresh popup for subgroups          
			iComm:=[Purchase_Orders_Items:12]CommodityCode:16
		End if 
		//• 9/4/97 cs moved to be more specific when executed , was below failure cases 
		[Purchase_Orders_Items:12]Commodity_Key:26:=String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"-"+[Purchase_Orders_Items:12]SubGroup:13  //insure that commodity key has at least comm code entered for search
		sRMflexFields([Purchase_Orders_Items:12]CommodityCode:16; 1)
		sSetPurchaseUM([Purchase_Orders_Items:12]CommodityCode:16)
		//ReqBudgetDisply 
		GOTO OBJECT:C206([Purchase_Orders_Items:12]SubGroup:13)
		//• 9/4/97 cs   
	Else 
		iComm:=0
		
		If ($ComKey="")  //search only on Commodity code
			ALERT:C41("The entered Commodity Code '"+String:C10([Purchase_Orders_Items:12]CommodityCode:16)+"' is not Valid in this context.")
		Else 
			ALERT:C41("The entered Commodity Key '"+$ComKey+"' is not Valid.")
		End if 
		[Purchase_Orders_Items:12]CommodityCode:16:=0
		[Purchase_Orders_Items:12]SubGroup:13:=""  //• 9/4/97 cs clear subgroup
		ARRAY TEXT:C222(aSubGroup; 0)  //• 9/4/97 cs clear array
		GOTO OBJECT:C206([Purchase_Orders_Items:12]CommodityCode:16)  //• 9/4/97 cs go back to commodity code
	End if 
Else 
	ALERT:C41("The Commodity code Entered is invalid."+Char:C90(13)+"Please select from the Pop up list.")
	
	If (Records in selection:C76([Raw_Materials:21])=1)
		[Purchase_Orders_Items:12]CommodityCode:16:=[Raw_Materials:21]CommodityCode:26
	Else 
		[Purchase_Orders_Items:12]CommodityCode:16:=Old:C35([Purchase_Orders_Items:12]CommodityCode:16)
	End if 
	
	If ([Purchase_Orders_Items:12]CommodityCode:16#0) | ([Purchase_Orders_Items:12]SubGroup:13#"")
		[Purchase_Orders_Items:12]Commodity_Key:26:=String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"-"+[Purchase_Orders_Items:12]SubGroup:13
	Else 
		[Purchase_Orders_Items:12]Commodity_Key:26:=""
	End if 
	ARRAY TEXT:C222(aSubGroup; 0)
	GOTO OBJECT:C206([Purchase_Orders_Items:12]CommodityCode:16)
	iComm:=0
End if 
//• 9/4/97 cs insure that aSubgroup array element selected is valid in current lis
$Loc:=Find in array:C230(aSubgroup; [Purchase_Orders_Items:12]SubGroup:13)

If ($Loc>0)
	aSubGroup:=$Loc
Else 
	aSubGroup:=0
End if 