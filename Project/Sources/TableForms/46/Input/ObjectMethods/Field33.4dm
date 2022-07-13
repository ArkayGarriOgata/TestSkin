If (Self:C308->=True:C214)
	If (Position:C15("Air"; [Customers_ReleaseSchedules:46]Mode:56)=0)
		[Customers_ReleaseSchedules:46]Mode:56:=Replace string:C233([Customers_ReleaseSchedules:46]Mode:56; "Ocean"; "")
		[Customers_ReleaseSchedules:46]Mode:56:=Replace string:C233([Customers_ReleaseSchedules:46]Mode:56; "Road"; "")
		[Customers_ReleaseSchedules:46]Mode:56:="AIR"+[Customers_ReleaseSchedules:46]Mode:56
	End if 
	
Else 
	[Customers_ReleaseSchedules:46]Mode:56:=Replace string:C233([Customers_ReleaseSchedules:46]Mode:56; "AIR"; "")
End if 

util_ComboBoxSetup(->aMode; [Customers_ReleaseSchedules:46]Mode:56)