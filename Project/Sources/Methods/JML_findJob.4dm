//%attributes = {"publishedWeb":true}
//JML_findJob 

$job:=Request:C163("Enter at least the last 3 digits of the jobform:"; "014"; "Find"; "Cancel")
If (OK=1)
	If (Length:C16($job)=3)
		$job1:="83"+$job+"@"
		$job2:="82"+$job+"@"
	Else 
		$job1:=$job
		$job2:=$job
	End if 
	CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "before")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$job1; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  | [Job_Forms_Master_Schedule:67]JobForm:4=$job2)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		CLEAR NAMED SELECTION:C333("before")
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4; >)
		b1:=0
		b2:=1
		b3:=0
		b4:=0
		b5:=0
	Else 
		BEEP:C151
		zwStatusMsg("NOT FOUND"; $job)
		USE NAMED SELECTION:C332("before")
	End if 
End if 