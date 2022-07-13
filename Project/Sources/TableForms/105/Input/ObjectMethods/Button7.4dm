
CREATE RECORD:C68([To_Do_Tasks:100])
[To_Do_Tasks:100]Category:2:="CAR"+[QA_Corrective_Actions:105]RequestNumber:1
[To_Do_Tasks:100]CreatedBy:8:=<>zResp
[To_Do_Tasks:100]Jobform:1:=Substring:C12([QA_Corrective_Actions:105]Jobit:9; 1; 8)

READ ONLY:C145([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[To_Do_Tasks:100]Jobform:1)
[To_Do_Tasks:100]PjtNumber:5:=[Job_Forms:42]ProjectNumber:56
REDUCE SELECTION:C351([Job_Forms:42]; 0)

[To_Do_Tasks:100]Task:3:="<enter_new_task_here>"
[To_Do_Tasks:100]AssignedTo:9:=Current user:C182
SAVE RECORD:C53([To_Do_Tasks:100])
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2="CAR"+[QA_Corrective_Actions:105]RequestNumber:1)
ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3; >)
