SET QUERY DESTINATION:C396(Into variable:K19:4; $numAddress)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Order_Lines:41]defaultShipTo:17)
SET QUERY DESTINATION:C396(Into current selection:K19:1)

If ($numAddress=1)
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17)
	USE NAMED SELECTION:C332("its_releases")
	
Else 
	uConfirm(" was not found in the Address table."; "Try Again"; "Help")
	[Customers_Order_Lines:41]defaultShipTo:17:=Old:C35([Customers_Order_Lines:41]defaultShipTo:17)
End if 
