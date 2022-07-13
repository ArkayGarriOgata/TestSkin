If (Find in array:C230(aBilltos; [Customers_ReleaseSchedules:46]Billto:22)=-1)
	BEEP:C151
	ALERT:C41("WARNING: "+[Customers_ReleaseSchedules:46]Billto:22+" is not a 'bill to' for this customer."+Char:C90(13)+"Modify the Customer to link it.")
	Text23:=[Customers_ReleaseSchedules:46]Billto:22+" is not a 'bill to' for this customer."
	[Customers_ReleaseSchedules:46]Billto:22:=""
Else 
	Text23:=fGetAddressText([Customers_ReleaseSchedules:46]Billto:22)
End if 
//