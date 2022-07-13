USE SET:C118("fourLoaded")
If (allJobs=0)
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //•08.25.04  MLB 
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
End if 
sAskMeTotals
ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >; [Job_Forms_Items:44]SubFormNumber:32; >)  // Modified by: Mel Bohince (6/5/18)