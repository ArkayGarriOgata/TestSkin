//%attributes = {"publishedWeb":true}
//PM: ToDo_postTask() -> 

//@author mlb - 8/22/02  13:58

If ($2#"Prep Work")
	CREATE RECORD:C68([To_Do_Tasks:100])
	[To_Do_Tasks:100]AssignedTo:9:=User_ResolveInitials($1)
	[To_Do_Tasks:100]Category:2:=$2
	[To_Do_Tasks:100]Task:3:=$3
	[To_Do_Tasks:100]PjtNumber:5:=$4
	[To_Do_Tasks:100]DateDue:10:=$5
	[To_Do_Tasks:100]CreatedBy:8:=<>zResp
	SAVE RECORD:C53([To_Do_Tasks:100])
	REDUCE SELECTION:C351([To_Do_Tasks:100]; 0)
End if 
//