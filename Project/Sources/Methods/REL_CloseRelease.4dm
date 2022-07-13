//%attributes = {"publishedWeb":true}
//REL_CloseRelease upr90 8/9/94
//•100797  mBohince preset dispositions

C_TEXT:C284($1)

If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
	//  [ReleaseSchedule]Sched_Qty:=[ReleaseSchedule]Actual_Qty
	[Customers_ReleaseSchedules:46]OpenQty:16:=0
	//[Customers_ReleaseSchedules]ModDate:=4D_Current_date
	//[Customers_ReleaseSchedules]ModWho:=◊zResp
	[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+Char:C90(13)+$1
	
	If (Length:C16([Customers_ReleaseSchedules:46]Expedite:35)=0)  //•100797  mBohince preset dispositions
		Case of 
			: ([Customers_ReleaseSchedules:46]Sched_Date:5<[Customers_ReleaseSchedules:46]Actual_Date:7)
				[Customers_ReleaseSchedules:46]Expedite:35:="LATE"
				
			: (([Customers_ReleaseSchedules:46]Sched_Qty:6*0.95)>[Customers_ReleaseSchedules:46]Actual_Qty:8)  //allow a 5% tolerence
				[Customers_ReleaseSchedules:46]Expedite:35:="PARTIAL"
				
			Else 
				[Customers_ReleaseSchedules:46]Expedite:35:="ON TIME"
		End case 
	End if 
	
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
Else 
	//BEEP
	//ALERT("Release# "+String([Customers_ReleaseSchedules]ReleaseNumber)+" was locked and could not be closed, do it manually.")
End if 