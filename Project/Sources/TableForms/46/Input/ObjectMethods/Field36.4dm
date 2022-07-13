If (Find in array:C230(aShiptos; [Customers_ReleaseSchedules:46]Shipto:10)=-1)
	BEEP:C151
	ALERT:C41("WARNING: "+[Customers_ReleaseSchedules:46]Shipto:10+" is not a 'ship to' for this customer."+Char:C90(13)+"Modify the Customer to link it.")
	Text25:=[Customers_ReleaseSchedules:46]Shipto:10+" is not a 'ship to' for this customer."
	[Customers_ReleaseSchedules:46]Shipto:10:=""
Else 
	Text25:=fGetAddressText([Customers_ReleaseSchedules:46]Shipto:10)
End if 