//OM:  i3  3/01/00  mlb
//mnthly
If (i3=1)
	//Batch_runnerMonthly ("√")
	Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "X")
Else 
	//Batch_runnerMonthly ("")
	Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "")
End if 