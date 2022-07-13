[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "!"; "")
[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "%"; "")
If (Position:C15("$"; [Customers_ReleaseSchedules:46]Expedite:35)=0)
	[Customers_ReleaseSchedules:46]Expedite:35:="$"+[Customers_ReleaseSchedules:46]Expedite:35
End if 