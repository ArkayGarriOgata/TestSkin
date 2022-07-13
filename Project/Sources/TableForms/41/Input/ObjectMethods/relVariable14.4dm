If (Records in set:C195("Customers_ReleaseSchedules")>0)
	COPY SET:C600("Customers_ReleaseSchedules"; "◊PassThroughSet")
	<>PassThrough:=True:C214
	ViewSetter(iMode; ->[Customers_ReleaseSchedules:46])
	
Else 
	uConfirm("Select a Release first."; "OK"; "Help")
End if 