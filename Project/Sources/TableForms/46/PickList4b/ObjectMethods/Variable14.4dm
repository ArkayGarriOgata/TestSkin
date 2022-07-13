//tText:=fBarCodeSym (39;String([Customers_ReleaseSchedules]ReleaseNumber))
tText:=WMS_SkidId(String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1); "barcode")