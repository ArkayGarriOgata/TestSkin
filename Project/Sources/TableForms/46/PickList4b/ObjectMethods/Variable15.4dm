//tText:=fBarCodeSym (39;String([Customers_ReleaseSchedules]ReleaseNumber))
If ([Customers_ReleaseSchedules:46]B_O_L_pending:45>0)
	xText:=WMS_SkidId(String:C10([Customers_ReleaseSchedules:46]B_O_L_pending:45); "barcode")
Else 
	xText:=""
End if 