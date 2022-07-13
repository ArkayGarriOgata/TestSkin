//OM: Jobform() -> 
//@author mlb - 5/13/02  16:16
If (Length:C16([To_Do_Tasks:100]Jobform:1)>=5)
	READ ONLY:C145([Jobs:15])
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([To_Do_Tasks:100]Jobform:1; 1; 5))))
	[To_Do_Tasks:100]PjtNumber:5:=[Jobs:15]ProjectNumber:18
	REDUCE SELECTION:C351([Jobs:15]; 0)
	<>jobform:=[To_Do_Tasks:100]Jobform:1
End if 

If (Length:C16([To_Do_Tasks:100]Jobform:1)>5) & ([To_Do_Tasks:100]DateDue:10=!00-00-00!)
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[To_Do_Tasks:100]Jobform:1)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		[To_Do_Tasks:100]DateDue:10:=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	End if 
End if 