//OM:  i2  3/01/00  mlb
//wkly
If (i2=1)
	//Batch_runnerWeekly ("√")
	Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "X")
Else 
	//Batch_runnerWeekly ("")
	Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "")
End if 

