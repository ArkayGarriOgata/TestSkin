$picked:=ToDo_StdTaskList("pick"; ->[To_Do_Tasks:100]Category:2; ->[To_Do_Tasks:100]Task:3)
If (Length:C16([To_Do_Tasks:100]Category:2)=0)
	GOTO OBJECT:C206([To_Do_Tasks:100]Category:2)
Else 
	GOTO OBJECT:C206([To_Do_Tasks:100]DateDue:10)
End if 