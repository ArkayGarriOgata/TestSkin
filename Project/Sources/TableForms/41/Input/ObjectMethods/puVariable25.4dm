wWindowTitle("push"; "Billed Pay-Use History for "+[Customers_Order_Lines:41]OrderLine:3)
$winRef:=OpenSheetWindow(->[Customers_BilledPayUse:86]; "DisplayArrays")
DIALOG:C40([Customers_BilledPayUse:86]; "DisplayArrays")
CLOSE WINDOW:C154
wWindowTitle("pop")