//%attributes = {}
// -------
// Method: _version20170307   ( ) ->
// By: Mel Bohince @ 03/06/17, 15:55:48
// Description
// set jobtypes on assemble jobs
// ----------------------------------------------------
<>USE_SUBCOMPONENT:=True:C214

ARRAY TEXT:C222($aAssemblyJobs; 0)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)

$blob:=FG_getAssemblyJobs("Assembly")

BLOB TO VARIABLE:C533($blob; $aAssemblyJobs)

READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Master_Schedule:67])

QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aAssemblyJobs)
APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 ASSEMBLY")

QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $aAssemblyJobs)
APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 ASSEMBLY")

SET BLOB SIZE:C606($blob; 0)
ARRAY TEXT:C222($aAssemblyJobs; 0)
$blob:=FG_getAssemblyJobs("Component")
BLOB TO VARIABLE:C533($blob; $aAssemblyJobs)

QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aAssemblyJobs)
APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 COMPONENT")

QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $aAssemblyJobs)
APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 COMPONENT")

REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)