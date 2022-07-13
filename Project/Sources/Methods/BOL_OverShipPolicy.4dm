//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/06/08, 14:36:59
// ----------------------------------------------------
// Method: BOL_OverShipPolicy
// Description
// rewrite of section from FG_ShipOvershipmentPolicy in FG_ShipItemAfterProcess
// ----------------------------------------------------

C_LONGINT:C283($qtyCredited; $1)

$qtyCredited:=$1

sCriterion1:=[Customers_ReleaseSchedules:46]ProductCode:11
sCriterion2:=[Customers_ReleaseSchedules:46]CustID:12
sCriterion3:="Customer"
sCriterion4:="Scrap"
//2/10/95 make jobform not null on overshipmnets

sCriterion6:=[Customers_ReleaseSchedules:46]OrderLine:4+"/"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)  //aOL2{$i}+"/"+String(aRel2{$i};"00000")
READ ONLY:C145([Finished_Goods_Transactions:33])
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=sCriterion6)
sCriterion5:=[Finished_Goods_Transactions:33]JobForm:5  //aJob2{$i}
i1:=[Finished_Goods_Transactions:33]JobFormItem:30  //•080495  MLB  UPR 1490

sCriterion9:="Overshipment"  //Reason field
sCriterion7:="Overshipment on BOL: "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)
rReal1:=$qtyCredited

FGX_post_transaction([Customers_ReleaseSchedules:46]Actual_Date:7; 1; "Ship")

LOAD RECORD:C52([Finished_Goods_Transactions:33])
[Finished_Goods_Transactions:33]PricePerM:19:=-[Finished_Goods_Transactions:33]PricePerM:19
[Finished_Goods_Transactions:33]ExtendedPrice:20:=-[Finished_Goods_Transactions:33]ExtendedPrice:20
//cost already in ship transaction
[Finished_Goods_Transactions:33]CoGSExtended:8:=0  //-[FG_Transactions]CoGSExtended
[Finished_Goods_Transactions:33]CoGS_M:7:=0  //-[FG_Transactions]CoGS_M
[Finished_Goods_Transactions:33]CoGSextendedMatl:32:=0
[Finished_Goods_Transactions:33]CoGSextendedLabor:33:=0
[Finished_Goods_Transactions:33]CoGSextendedBurden:34:=0
SAVE RECORD:C53([Finished_Goods_Transactions:33])