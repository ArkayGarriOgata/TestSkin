//(S) [JobForm]'List'bInclude
qryJobsInWIP(4D_Current_date)
ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]StartDate:10; >)
CREATE SET:C116([Job_Forms:42]; "◊LastSelection"+String:C10(Table:C252(->[Job_Forms:42])))
SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms:42]))
//EOS