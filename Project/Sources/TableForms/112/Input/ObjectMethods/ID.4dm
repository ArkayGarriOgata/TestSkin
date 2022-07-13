//OM: ID() -> 
//@author mlb - 2/8/02  11:05

If (Length:C16([JTB_Job_Transfer_Bags:112]ID:1)#6)
	BEEP:C151
	ALERT:C41("[JobTransferBag]ID must be 6 character long, you entered "+String:C10(Length:C16([JTB_Job_Transfer_Bags:112]ID:1)))
	[JTB_Job_Transfer_Bags:112]ID:1:=""
	GOTO OBJECT:C206([JTB_Job_Transfer_Bags:112]ID:1)
End if 