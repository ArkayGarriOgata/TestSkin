READ ONLY:C145([Customers_Projects:9])
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Customers_Brand_Lines:39]ProjectNumber:14)
uConfirm("Project set to: "+[Customers_Projects:9]Name:2+" for line "+[Customers_Brand_Lines:39]LineNameOrBrand:2; "OK"; "Cancel")
If (ok=0)
	[Customers_Brand_Lines:39]ProjectNumber:14:=""
End if 