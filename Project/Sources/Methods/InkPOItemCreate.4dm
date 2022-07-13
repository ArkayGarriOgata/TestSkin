//%attributes = {"publishedWeb":true}
//(p) InkPoItemCreate
//creates PO Items for ink which is now going to be direct bill
//assumes record in selection([material Job, AND thatthis is the record
//for which to create a PO item
//$1 String - PO number
//$2 - longint -item number to create
//$3 - string (optional) - anything flag to use current selection of Material Job
//• 6/1/98 cs created
//• 6/8/98 cs insure that inks being ordered are actually Inx inks
//• 6/9/98 cs left out a next subrecord command
//• 8/4/98 cs modification to try to get form to print consistantly
//• 8/11/98 cs added 3rd parameter for calls from elsewhere besides job bag
//• 8/25/98 cs fixes problem with 'invalid' commkey
//•102798  MLB  UPR 1983 added sort
//•082799  mlb  dupkey problems persist

C_TEXT:C284($1)
C_TEXT:C284($3)
C_REAL:C285($Dollars; $0)
C_LONGINT:C283($2; $i; $ItemCount)
C_BOOLEAN:C305($Inx)

$Dollars:=0

//If (Count parameters<3)  //appareently this if is obsolete?,lmlb
//USE SET("Keep")  //• 8/4/98 cs from procedure InkPo [material job] inks w/ valid rmcode
//ORDER BY([Job_Forms_Materials];[Job_Forms_Materials]Sequence;>)
//
//If (Records in selection([Purchase_Orders_Items])>0)  //ther are items with receiving against them
//CREATE SET([Purchase_Orders_Items];"Carryovers")  //this set represents those items that have receiving
//CREATE SET([Job_Forms_Materials];"ToCreate")  //materials to create items for
//uRelateSelect (->[Job_Forms_Materials]Raw_Matl_Code;->[Purchase_Orders_Items]Raw_Matl_Code)
//CREATE SET([Job_Forms_Materials];"CrossRef")  //materials which have recieving
//INTERSECTION("CrossRef";"ToCreate";"CrossRef")  //those Materials which are to be created & are part of the po_tems with recv
//DIFFERENCE("ToCreate";"CrossRef";"ToCreate")  //tocreate now contins materials to create which have no receiving
//USE SET("ToCreate")
//Else 
//CREATE EMPTY SET([Purchase_Orders_Items];"CarryOvers")
//CREATE EMPTY SET([Job_Forms_Materials];"CrossRef")
//CREATE SET([Job_Forms_Materials];"ToCreate")
//End if 
//CLEAR SET("CrossRef")
//Else   //• 8/11/98 cs create these sets so the follwing code works -
//  //with out worrying about receiving since this will be creating a new item
//CREATE EMPTY SET([Purchase_Orders_Items];"Carryovers")
//CREATE EMPTY SET([Job_Forms_Materials];"ToCreate")
//CREATE EMPTY SET([Job_Forms_Materials];"CrossRef")
//End if 
//
//If ([Purchase_Orders]PONo#$1)
//QUERY([Purchase_Orders];[Purchase_Orders]PONo=$1)
//End if 
//
//ORDER BY([Job_Forms_Materials];[Job_Forms_Materials]Sequence;>)  //•102798  MLB  UPR 1983 could loose sort order above
//
//  //$ItemCount:=Records in selection([PO_Items])+1  `•042999  MLB don't want duplica
//$ItemCount:=Num(gFindPOItem )+1  //•08/30/1999  Mel Bohince  dup key problems persist
//
//FIRST RECORD([Job_Forms_Materials])  //• 8/25/98 cs fixes problem with 'invalid' commkey
//For ($i;1;Records in selection([Job_Forms_Materials]))  //• 8/11/98 cs this will be correct from incomming call with 3 paramet
//If (Records in set("CarryOvers")>0)  //there are PO s which have receiving
//USE SET("CarryOvers")
//QUERY SELECTION([Purchase_Orders_Items];[Purchase_Orders_Items]ItemNo=String($i;"00"))  //do not duplicate item numbers
//$Dollars:=$Dollars+[Purchase_Orders_Items]ExtPrice
//Else 
//uClearSelection (->[Purchase_Orders_Items])
//End if 
//
//If (Records in selection([Purchase_Orders_Items])=0)  //this item is NOT a carryover po_item
//If ([Raw_Materials]Raw_Matl_Code#[Job_Forms_Materials]Raw_Matl_Code)  //locate a Raw Mat code
//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=[Job_Forms_Materials]Raw_Matl_Code)
//End if 
//
//If (Records in selection([Raw_Materials])>0)  //if this is a VALID budget Raw mat code
//RELATE MANY([Raw_Materials]Suggest_Vendors)  //now determine that this specific ink is for an INX ink
//
//If (Records in selection([Raw_Materials_Suggest_Vendors])=0)  //no suggested vendor - default to INX
//$Inx:=True
//Else 
//$inx:=False
//
//For ($j;1;Records in selection([Raw_Materials_Suggest_Vendors]))
//If (Position("Inx";[Raw_Materials_Suggest_Vendors]Name)>0) | ((Position("Arkay";[Raw_Materials_Suggest_Vendors]Name)>0) & (Records in selection([Raw_Materials_Suggest_Vendors])=1))
//$Inx:=True
//End if 
//NEXT RECORD([Raw_Materials_Suggest_Vendors])
//End for 
//End if 
//
//If ($Inx)
//CREATE RECORD([Purchase_Orders_Items])  //create PO Item
//[Purchase_Orders_Items]PONo:=[Purchase_Orders]PONo
//$ItemNo:=String($ItemCount;"00")
//[Purchase_Orders_Items]ItemNo:=$ItemNo
//$ItemCount:=$ItemCount+1  //increment item counter
//[Purchase_Orders_Items]POItemKey:=[Purchase_Orders_Items]PONo+[Purchase_Orders_Items]ItemNo
//[Purchase_Orders_Items]ReqdDate:=[Purchase_Orders]Required
//[Purchase_Orders_Items]ModDate:=4D_Current_date
//[Purchase_Orders_Items]ModWho:=<>zResp
//[Purchase_Orders_Items]VendorID:=[Purchase_Orders]VendorID
//[Purchase_Orders_Items]PoItemDate:=4D_Current_date
//[Purchase_Orders_Items]PromiseDate:=[Job_Forms]NeedDate
//[Purchase_Orders_Items]ReqnBy:=<>zResp  //• 11/14/97 cs this slipped through the cracks
//[Purchase_Orders_Items]ModWho:=<>zResp
//[Purchase_Orders_Items]ExpeditingNote:="This Item created from budget for Job Form "+[Job_Forms]JobFormID
//POI_makeLikeRM 
//$sap_cost:=Ink_get_cost ([Raw_Materials]Raw_Matl_Code)
//If ($sap_cost>0)
//[Purchase_Orders_Items]UnitPrice:=$sap_cost
//[Purchase_Orders_Items]ExpeditingNote:=[Purchase_Orders_Items]ExpeditingNote+Char(13)+"SAP Price Used "
//End if 
//
//If ([Purchase_Orders_Items]UM_Arkay_Issue="") | ([Purchase_Orders_Items]UM_Price="") | ([Purchase_Orders_Items]UM_Ship="")
//[Purchase_Orders_Items]UM_Price:="LB"
//[Purchase_Orders_Items]UM_Ship:="LB"
//[Purchase_Orders_Items]UM_Arkay_Issue:="LB"
//End if 
//
//If ([Purchase_Orders_Items]UnitPrice=0)  //use std cost
//If ([Raw_Materials_Groups]Commodity_Key#[Raw_Materials]Commodity_Key)
//QUERY([Raw_Materials_Groups];[Raw_Materials_Groups]Commodity_Key=[Raw_Materials]Commodity_Key)
//
//If ([Raw_Materials_Groups]Std_Cost=0)
//$Cost:=JCOIssDtermCost 
//Else 
//$Cost:=[Raw_Materials_Groups]Std_Cost
//End if 
//End if 
//[Purchase_Orders_Items]UnitPrice:=$Cost
//[Purchase_Orders_Items]ExpeditingNote:=[Purchase_Orders_Items]ExpeditingNote+Char(13)+"Costing taken from Standard, for : "+[Raw_Materials_Groups]SubGroup
//  //Insert located price into Raw materials
//fLockNLoad (->[Raw_Materials])
//[Raw_Materials]LastPurCost:=$Cost
//[Raw_Materials]LastPurDate:=4D_Current_date
//[Raw_Materials]ActCost:=$Cost  //OKed by Fred
//SAVE RECORD([Raw_Materials])
//End if 
//[Purchase_Orders_Items]Qty_Ordered:=[Job_Forms_Materials]Planned_Qty
//  //ReqCalcItmValue 
//CalcPOitem   //•042999  MLB  std version
//$Dollars:=$Dollars+[Purchase_Orders_Items]ExtPrice  //return $ so that we can sum these for the PO header
//[Purchase_Orders_Items]UM_Arkay_Issue:="LB"
//If (False)
//sSetPurchaseUM ([Purchase_Orders_Items]CommodityCode)
//End if 
//SAVE RECORD([Purchase_Orders_Items])
//uClearSelection (->[Purchase_Orders_Job_forms])  //make sure relation gets correct records
//RELATE MANY([Purchase_Orders_Items]POItemKey)  //get job form tie ins
//
//If (Records in selection([Purchase_Orders_Job_forms])=0)  //create direct bill tie in        
//CREATE RECORD([Purchase_Orders_Job_forms])
//[Purchase_Orders_Job_forms]JobFormID:=[Job_Forms]JobFormID
//[Purchase_Orders_Job_forms]POItemKey:=[Purchase_Orders_Items]POItemKey
//[Purchase_Orders_Job_forms]NeedDate:=[Job_Forms]NeedDate
//[Purchase_Orders_Job_forms]QtyRequired:=[Purchase_Orders_Items]Qty_Ordered
//SAVE RECORD([Purchase_Orders_Job_forms])
//End if 
//End if   //end test for Inx ink        
//End if   //no po_item created due to no valid Raw Matl Code
//End if   //no prior poitem
//
//NEXT RECORD([Job_Forms_Materials])
//End for 

$0:=$Dollars

CLEAR SET:C117("CarryOvers")
CLEAR SET:C117("ToCreate")