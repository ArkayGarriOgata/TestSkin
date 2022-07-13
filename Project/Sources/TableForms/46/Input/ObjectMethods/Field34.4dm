Case of 
	: (Position:C15("!!"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
		[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "!!"; "")
		
	: (Position:C15("%%"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
		[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "%%"; "")
		
	: (Position:C15("$$"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
		[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "$$"; "")
		
End case 

If ([Customers_ReleaseSchedules:46]Billto:22="01190") | ([Customers_ReleaseSchedules:46]Billto:22="02742")
	Case of 
		: (Position:C15("!"; Old:C35([Customers_ReleaseSchedules:46]Expedite:35))>0)
			[Customers_ReleaseSchedules:46]Expedite:35:="!"+[Customers_ReleaseSchedules:46]Expedite:35
			
		: (Position:C15("%"; Old:C35([Customers_ReleaseSchedules:46]Expedite:35))>0)
			[Customers_ReleaseSchedules:46]Expedite:35:="%"+[Customers_ReleaseSchedules:46]Expedite:35
			
		: (Position:C15("$"; Old:C35([Customers_ReleaseSchedules:46]Expedite:35))>0)
			[Customers_ReleaseSchedules:46]Expedite:35:="$"+[Customers_ReleaseSchedules:46]Expedite:35
	End case 
End if 