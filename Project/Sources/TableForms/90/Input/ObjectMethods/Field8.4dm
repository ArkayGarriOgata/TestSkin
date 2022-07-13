//(s) costcenter [issueticeks] input

If (Self:C308->#"")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=Self:C308->)
	
	If (Records in selection:C76([Cost_Centers:27])=0)
		ALERT:C41("Entered Cost Center was not found."+Char:C90(13)+"Please try again.")
		Self:C308->:=""
	End if 
End if 
//