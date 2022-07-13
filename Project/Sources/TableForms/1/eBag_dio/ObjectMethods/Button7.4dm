CREATE RECORD:C68([To_Do_Tasks:100])
[To_Do_Tasks:100]Category:2:="eBag"
[To_Do_Tasks:100]CreatedBy:8:=<>zResp
[To_Do_Tasks:100]Jobform:1:=[Job_Forms:42]JobFormID:5
[To_Do_Tasks:100]PjtNumber:5:=[Job_Forms:42]ProjectNumber:56
[To_Do_Tasks:100]Task:3:="<enter_new_task_here>"
SAVE RECORD:C53([To_Do_Tasks:100])
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=[Job_Forms:42]JobFormID:5)
ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3; >)