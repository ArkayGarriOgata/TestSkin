//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/11/10, 17:08:02
// ----------------------------------------------------
// Method: edi_use_their_quantity
// Description
// 
//  ` accept their qty and apply changes to ams orderes and releases
// assume that orderline is loaded and its releases are in current selection
// ----------------------------------------------------

[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35
[Customers_Order_Lines:41]chgd_qty:28:=True:C214
change_ams_status:=True:C214
USE NAMED SELECTION:C332("its_releases")
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_Order_Lines:41]Qty_Open:11)
USE NAMED SELECTION:C332("its_releases")
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6)
USE NAMED SELECTION:C332("its_releases")
//CLEAR NAMED SELECTION("its_releases")