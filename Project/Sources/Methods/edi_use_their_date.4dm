//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/11/10, 17:00:55
// ----------------------------------------------------
// Method: edi_use_their_date
// Description
// accept their date and apply changes to ams orderes and releases
// assume that orderline is loaded and its releases are in current selection
// ----------------------------------------------------

USE NAMED SELECTION:C332("its_releases")

C_DATE:C307($shipOn)

$shipOn:=[Customers_Order_Lines:41]NeedDate:14-ADDR_getLeadTime([Customers_Order_Lines:41]defaultShipTo:17)
$shipOn:=REL_NoWeekEnds($shipOn)

QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5:=$shipOn)
USE NAMED SELECTION:C332("its_releases")
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Promise_Date:32:=[Customers_Order_Lines:41]NeedDate:14)
USE NAMED SELECTION:C332("its_releases")
//CLEAR NAMED SELECTION("its_releases")