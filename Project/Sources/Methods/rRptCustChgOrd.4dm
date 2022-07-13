//%attributes = {"publishedWeb":true}
//(P) rRptCustChgOrd : [OrderChgHistory] Change Order

fChg:=True:C214
FORM SET OUTPUT:C54([Customers_Order_Change_Orders:34]; "ChgOrderRpt")
util_PAGE_SETUP(->[Customers_Order_Change_Orders:34]; "ChgOrderRpt")
iPage:=1
//----------------------- SET UP MAIN HEADER -----------
// t1:="Order Number: "+String([OrderChgHistory]OrderNo;"000000")
t2:="ARKAY CHANGE ORDER"
t3:=String:C10(4D_Current_date; 2)+" "+String:C10(4d_Current_time; 2)
t3a:="Last Update on "+String:C10([Customers_Order_Change_Orders:34]ModDate:18; 1)+" by "+[Customers_Order_Change_Orders:34]ModWho:19
// Text1:=[CUSTOMER]Name
PRINT SELECTION:C60([Customers_Order_Change_Orders:34])

FORM SET OUTPUT:C54([Customers_Order_Change_Orders:34]; "List")