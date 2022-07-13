[Customers_Order_Lines:41]NeedDateOld:51:=[Customers_Order_Lines:41]NeedDate:14
[Customers_Order_Lines:41]NeedDate:14:=[Customers_Order_Lines:41]edi_dock_date:64
C_DATE:C307($shipOn)
$shipOn:=[Customers_Order_Lines:41]NeedDate:14-ADDR_getLeadTime([Customers_Order_Lines:41]defaultShipTo:17)

uConfirm("Suggest shipping on "+String:C10($shipOn; System date long:K1:3)+". Apply to Releases?"; "Apply"; "Ignore")
If (ok=1)
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5:=$shipOn)
End if 