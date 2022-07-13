[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Order_Lines:41]edi_shipto:63
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)


// ******* Verified  - 4D PS - January 2019 (end) *********
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17)
USE NAMED SELECTION:C332("its_releases")

