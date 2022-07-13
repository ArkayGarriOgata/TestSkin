//%attributes = {"publishedWeb":true}
//PM: JML_getJobInfo() -> 
//@author mlb - 3/4/02  12:17

C_TEXT:C284($1)

READ ONLY:C145([Job_Forms:42])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)  //**      Get Gross sheets
If (Records in selection:C76([Job_Forms:42])=1)
	[Job_Forms_Master_Schedule:67]SheetQty:6:=[Job_Forms:42]EstGrossSheets:27
	[Job_Forms_Master_Schedule:67]JobType:31:=[Job_Forms:42]JobType:33
	[Job_Forms_Master_Schedule:67]PlannerReleased:14:=[Job_Forms:42]PlnnerReleased:59
	If ([Job_Forms_Master_Schedule:67]LocationOfMfg:30="")
		[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=[Job_Forms:42]Run_Location:55
	End if 
	
	Case of 
		: ([Job_Forms:42]Status:6="Kill")
			[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
			[Job_Forms_Master_Schedule:67]Comment:22:="Form found to be Killed"+Char:C90(13)+[Job_Forms_Master_Schedule:67]Comment:22
		: ([Job_Forms:42]Status:6="Closed")
			[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
			[Job_Forms_Master_Schedule:67]Comment:22:="Form found to be Closed"+Char:C90(13)+[Job_Forms_Master_Schedule:67]Comment:22
		: ([Job_Forms:42]Status:6="Complete")
			[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
			[Job_Forms_Master_Schedule:67]Comment:22:="Form found to be Complete"+Char:C90(13)+[Job_Forms_Master_Schedule:67]Comment:22
	End case 
	
	If ([Job_Forms_Master_Schedule:67]EarliestStart_PrintFlow:90=!00-00-00!)
		[Job_Forms_Master_Schedule:67]EarliestStart_PrintFlow:90:=Add to date:C393([Job_Forms:42]VersionZeroDate:89; 0; 0; 14)
	End if 
	
End if 