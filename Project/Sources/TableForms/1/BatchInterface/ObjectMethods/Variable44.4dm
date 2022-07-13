//OM:  i1  3/01/00  mlb
//dily
If (i1=1)
	//Batch_runnerDaily ("√")
	Batch_RunnerGetSet(->[y_batches:10]Daily:5; "X")
Else 
	//Batch_runnerDaily ("")
	Batch_RunnerGetSet(->[y_batches:10]Daily:5; "")
End if 