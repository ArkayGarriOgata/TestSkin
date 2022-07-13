If ([Customers_ReleaseSchedules:46]COA_required:50="Sent")
	[Customers_ReleaseSchedules:46]COA_required:50:=String:C10(4D_Current_date; System date short:K1:1)
End if 