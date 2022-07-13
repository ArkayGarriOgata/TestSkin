CREATE RECORD:C68([To_Do_Tasks:100])
[To_Do_Tasks:100]Category:2:="jBag"
[To_Do_Tasks:100]CreatedBy:8:=<>zResp
[To_Do_Tasks:100]Jobform:1:=sCriterion5
[To_Do_Tasks:100]PjtNumber:5:=[JTB_Job_Transfer_Bags:112]PjtNumber:2
[To_Do_Tasks:100]Task:3:="enter_new_task_here"
SAVE RECORD:C53([To_Do_Tasks:100])
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=sCriterion5)
ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3; >)