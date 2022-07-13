//%attributes = {"publishedWeb":true}
//PM: FG_PrepSetupBillDetail($order;$line;custid) -> 
//@author mlb - 8/28/02  13:20
C_LONGINT:C283($1; $2)
C_TEXT:C284($3)  //custid
CREATE RECORD:C68([Customers_Order_Lines:41])
[Customers_Order_Lines:41]OrderNumber:1:=$1
[Customers_Order_Lines:41]LineItem:2:=$2
[Customers_Order_Lines:41]OrderLine:3:=fMakeOLkey([Customers_Order_Lines:41]OrderNumber:1; [Customers_Order_Lines:41]LineItem:2)
[Customers_Order_Lines:41]CustID:4:=$3
$pCode:="Preparatory"
[Customers_Order_Lines:41]ProductCode:5:=$pCode
uLinesLikeOrder
[Customers_Order_Lines:41]Status:9:="Opened"
[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
[Customers_Order_Lines:41]Qty_Shipped:10:=0
[Customers_Order_Lines:41]Quantity:6:=0
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
[Customers_Order_Lines:41]InvoiceComment:43:="Work Order#:"+[Finished_Goods_Specifications:98]ControlNumber:2+" For item code "+[Finished_Goods_Specifications:98]ProductCode:3+". "
[Customers_Order_Lines:41]OrderType:22:="Preparatory"  //•071495  MLB  UPR 222  
[Customers_Order_Lines:41]SpecialBilling:37:=True:C214
[Customers_Order_Lines:41]OverRun:25:=0
[Customers_Order_Lines:41]UnderRun:26:=0
[Customers_Order_Lines:41]Classification:29:="25"