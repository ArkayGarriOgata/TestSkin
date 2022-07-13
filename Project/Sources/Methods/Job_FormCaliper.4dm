//%attributes = {"publishedWeb":true}
//PM:  Job_FormCaliper  110999  mlb
//formerly  `(p) gJobFormCaliper
//determine the jobform caliper - use over ride if needed
//• 6/4/98 cs created

If ([Estimates_DifferentialsForms:47]Caliper:32=0)
	If ([Process_Specs:18]ID:1#[Job_Forms:42]ProcessSpec:46)  //• 3/4/98 cs add caliper to form level
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46)
	End if 
	[Job_Forms:42]Caliper:49:=[Process_Specs:18]Caliper:8
Else 
	[Job_Forms:42]Caliper:49:=[Estimates_DifferentialsForms:47]Caliper:32
End if 