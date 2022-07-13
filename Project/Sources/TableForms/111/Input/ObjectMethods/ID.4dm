//OM: ID() -> 
//@author mlb - 2/8/02  10:51

If (Length:C16([JPSI_Job_Physical_Support_Items:111]ID:1)#7)
	BEEP:C151
	ALERT:C41("[JobPhysSuptItem]ID must be 7 character long, you entered "+String:C10(Length:C16([JPSI_Job_Physical_Support_Items:111]ID:1)))
	[JPSI_Job_Physical_Support_Items:111]ID:1:=""
	GOTO OBJECT:C206([JPSI_Job_Physical_Support_Items:111]ID:1)
End if 