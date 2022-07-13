//%attributes = {"publishedWeb":true}
//  //uPO2RM mod 6/27/94
//  //•082295  MLB  UPR 1707
//  //•092595  MLB  UPR 1707 check for locked status
//  //Upr 0235 Cs - 12/3/96 - chargecode change
//  //• 6/12/97 cs  added parameter 1 upr 1972
//  //$1 - string (optional) anyhting - flag - called from Requisition
//  //• 4/9/98 cs nan checking/removal
//  //see also uPO2RM2, RM_makeLikePOI2
//
//C_BOOLEAN($continue)  //•092595  MLB  UPr 1707
//
//READ WRITE([Raw_Materials])
//
//If ([Raw_Materials]Raw_Matl_Code#[Purchase_Orders_Items]Raw_Matl_Code)
//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=[Purchase_Orders_Items]Raw_Matl_Code)
//End if 
//
//If (Records in selection([Raw_Materials])=0)
//CREATE RECORD([Raw_Materials])
//If (Count parameters=1)  //• 6/12/97 cs called from req flag as new
//[Raw_Materials]NewFromReq:=True
//End if 
//$Continue:=True
//Else 
//$Continue:=fLockNLoad (->[Raw_Materials])  //•092595  MLB  UPR 1707
//End if 
//
//If ($Continue)  //•092595  MLB  UPR 1707
//[Raw_Materials]Raw_Matl_Code:=[Purchase_Orders_Items]Raw_Matl_Code
//[Raw_Materials]CommodityCode:=[Purchase_Orders_Items]CommodityCode
//[Raw_Materials]SubGroup:=[Purchase_Orders_Items]SubGroup
//[Raw_Materials]Commodity_Key:=[Purchase_Orders_Items]Commodity_Key
//
//  //Upr 0235
//  //  [RAW_MATERIALS]ChargeCode:=[PO_ITEMS]ChargeCode
//If ([Raw_Materials]CompanyID="")
//[Raw_Materials]CompanyID:=[Purchase_Orders_Items]CompanyID
//End if 
//If ([Raw_Materials]DepartmentID="")
//[Raw_Materials]DepartmentID:=[Purchase_Orders_Items]DepartmentID
//End if 
//If ([Raw_Materials]Obsolete_ExpCode="")
//[Raw_Materials]Obsolete_ExpCode:=[Purchase_Orders_Items]ExpenseCode
//End if 
//  //end Upr 0235
//
//[Raw_Materials]Description:=[Purchase_Orders_Items]RM_Description
//[Raw_Materials]ReceiptUOM:=[Purchase_Orders_Items]UM_Ship
//[Raw_Materials]IssueUOM:=[Purchase_Orders_Items]UM_Arkay_Issue
//[Raw_Materials]ConvertRatio_N:=[Purchase_Orders_Items]FactNship2cost
//[Raw_Materials]ConvertRatio_D:=[Purchase_Orders_Items]FactDship2cost  //•082295  MLB  UPR 1707
//[Raw_Materials]LastPurCost:=uNANCheck ([Purchase_Orders_Items]UnitPrice)
//[Raw_Materials]ActCost:=uNANCheck ([Purchase_Orders_Items]UnitPrice*([Purchase_Orders_Items]FactNship2price/[Purchase_Orders_Items]FactDship2price))
//[Raw_Materials]Flex1:=[Purchase_Orders_Items]Flex1
//[Raw_Materials]Flex2:=[Purchase_Orders_Items]Flex2
//[Raw_Materials]Flex3:=[Purchase_Orders_Items]Flex3
//[Raw_Materials]Flex4:=[Purchase_Orders_Items]Flex4
//[Raw_Materials]Flex5:=[Purchase_Orders_Items]Flex5
//[Raw_Materials]Flex6:=[Purchase_Orders_Items]Flex6
//RELATE MANY([Raw_Materials]Suggest_Vendors)
//QUERY SELECTION([Raw_Materials_Suggest_Vendors];[Raw_Materials_Suggest_Vendors]VendorID=[Purchase_Orders]VendorID)
//If (Records in subselection([Raw_Materials]Suggest_Vendors)=0)
//CREATE RECORD([Raw_Materials_Suggest_Vendors])
//[Raw_Materials_Suggest_Vendors]VendorID:=[Purchase_Orders]VendorID
//[Raw_Materials_Suggest_Vendors]Name:=sName  //assigned on PO header\ 
//[Raw_Materials_Suggest_Vendors]id_added_by_converter:=[Raw_Materials]Suggest_Vendors
//End if 
//[Raw_Materials_Suggest_Vendors]VendorPartNumber:=[Purchase_Orders_Items]VendPartNo
//[Raw_Materials_Suggest_Vendors]FactNShip2price:=[Purchase_Orders_Items]FactNship2price
//[Raw_Materials_Suggest_Vendors]FactDship2price:=[Purchase_Orders_Items]FactDship2price
//[Raw_Materials_Suggest_Vendors]UMprice:=[Purchase_Orders_Items]UM_Price
//SAVE RECORD([Raw_Materials_Suggest_Vendors])
//UNLOAD RECORD([Raw_Materials_Suggest_Vendors])
//fNewRM:=False
//
//Else 
//BEEP
//ALERT("The R/M record is locked, update couldn't be made.")
//End if 