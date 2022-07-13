//%attributes = {"publishedWeb":true}
//PM: FG_PrepSetupBillHeader($custid) -> ord number
//@author mlb - 8/28/02  13:08
C_TEXT:C284($1)
C_LONGINT:C283($0; $Ord)
CREATE RECORD:C68([Customers_Orders:40])
C_TEXT:C284($server)
$server:="?"
vord:=-3
app_getNextID(Table:C252(->[Customers_Orders:40]); ->$server; ->vord)
$Ord:=vord  //Seque444nce number([Customers_Orders])+◊aOffSet{Table(->[Customers_Orders])}
[Customers_Orders:40]OrderNumber:1:=$Ord
zwStatusMsg("ORDERING"; " Opening order..."+String:C10($Ord))
[Customers_Orders:40]Status:10:="Opened"
[Customers_Orders:40]PONumber:11:=""

[Customers_Orders:40]ProjectNumber:53:=[Finished_Goods_Specifications:98]ProjectNumber:4
[Customers_Orders:40]EstimateNo:3:=[Finished_Goods_Specifications:98]ControlNumber:2
[Customers_Orders:40]CaseScenario:4:="**"

[Customers_Orders:40]CustID:2:=$1
[Customers_Orders:40]CustomerName:39:=[Customers:16]Name:2
[Customers_Orders:40]CustomerLine:22:=[Finished_Goods:26]Line_Brand:15
[Customers_Orders:40]Terms:23:=[Customers:16]Std_Terms:13
[Customers_Orders:40]z_DiscountPct:41:=[Customers:16]Std_Discount:14
[Customers_Orders:40]z_DiscountNetDays:42:=[Customers:16]DiscountDaysDue:43
[Customers_Orders:40]z_NetDaysDue:43:=[Customers:16]NetDaysDue:44
[Customers_Orders:40]ShipVia:24:=[Customers:16]Std_ShipVia:9
[Customers_Orders:40]FOB:25:=[Customers:16]Std_Incoterms:11
[Customers_Orders:40]PlannedBy:30:=[Customers:16]PlannerID:5
[Customers_Orders:40]SalesRep:13:=[Customers:16]SalesmanID:3
[Customers_Orders:40]SalesCoord:46:=[Customers:16]SalesCoord:45
[Customers_Orders:40]CustomerService:47:=[Customers:16]CustomerService:46

[Customers_Orders:40]defaultBillTo:5:=""
[Customers_Orders:40]defaultShipto:40:=""
[Customers_Orders:40]DateOpened:6:=4D_Current_date
[Customers_Orders:40]EnteredBy:7:=<>zResp
uUpdateTrail(->[Customers_Orders:40]ModDate:9; ->[Customers_Orders:40]ModWho:8)
$0:=$Ord
//