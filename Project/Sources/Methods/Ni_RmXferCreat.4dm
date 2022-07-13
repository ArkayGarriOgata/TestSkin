//%attributes = {"publishedWeb":true}
//Ni_RmXferCreat:
//$1 long -Issue Index
//$2 Long - POI Index
//• 10/31/97 cs created

C_LONGINT:C283($1; $2)
C_TEXT:C284($3)

CREATE RECORD:C68([Raw_Materials_Transactions:23])
[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=aPOIRMCode{$2}
[Raw_Materials_Transactions:23]Xfer_Type:2:="ISSUE"
[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
[Raw_Materials_Transactions:23]POItemKey:4:=aPOIPoiKey{$2}
[Raw_Materials_Transactions:23]JobForm:12:=Substring:C12(aIssueJf{$1}; 1; 8)
[Raw_Materials_Transactions:23]Sequence:13:=Num:C11(Substring:C12(aIssueJf{$1}; 10; 3))
[Raw_Materials_Transactions:23]ReferenceNo:14:="VF Issue"  //• 5/19/98 cs flag tansaction as occuring from VF
[Raw_Materials_Transactions:23]Location:15:="WIP"
[Raw_Materials_Transactions:23]CompanyID:20:=aPOICompid{$2}
[Raw_Materials_Transactions:23]DepartmentID:21:=aPOIDept{$2}
[Raw_Materials_Transactions:23]ExpenseCode:26:=aPOIExpCode{$2}

If ($3="")
	[Raw_Materials_Transactions:23]viaLocation:11:=("Arkay"*Num:C11(aPOICompId{$2}="1"))+("Roanoke"*Num:C11(aPOICompId{$2}="2"))+("Labels"*Num:C11(aPOICompId{$2}="3"))
Else 
	[Raw_Materials_Transactions:23]viaLocation:11:=$3
End if 
[Raw_Materials_Transactions:23]Qty:6:=-aIssueQty{$1}
[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(aPOIPrice{$2}/aPOIOrdAmt{$2})  //calc unit price since shipper may deliver in differnt units
[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9; 2))
[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time

If (Count parameters:C259=4)
	[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
Else 
	[Raw_Materials_Transactions:23]ModWho:18:="Btch"
End if 

[Raw_Materials_Transactions:23]Commodity_Key:22:=aPOIComKey{$2}
[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12(aPOIComKey{$2}; 1; 2))
SAVE RECORD:C53([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Raw_Materials_Transactions:23])