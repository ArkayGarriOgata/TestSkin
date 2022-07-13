//%attributes = {}
// -------
// Method: FG_getAssemblyJobs   ( ) ->
// By: Mel Bohince @ 02/28/17, 16:31:36
// Description
// 
// ----------------------------------------------------
<>USE_SUBCOMPONENT:=True:C214
C_TEXT:C284($1)
C_BLOB:C604($0; $anArray)
SET BLOB SIZE:C606($0; 0)
SET BLOB SIZE:C606($anArray; 0)

ARRAY TEXT:C222($aAssemblyJobs; 0)
ARRAY TEXT:C222($aComponentJobs; 0)

If ($1="Assembly")  //get all the parent jobs
	Begin SQL
		select distinct(JobForm) from Job_Forms_Materials where Commodity_Key like '33%' order by JobForm
		into :$aAssemblyJobs
	End SQL
	
	VARIABLE TO BLOB:C532($aAssemblyJobs; $anArray)
	
Else   //find Component jobs
	Begin SQL
		select distinct(JobForm) from Job_Forms_Items where ProductCode in 
		(select distinct(Raw_Matl_Code) from Job_Forms_Materials where Commodity_Key like '33%') order by JobForm
		into :$aComponentJobs
	End SQL
	
	VARIABLE TO BLOB:C532($aComponentJobs; $anArray)
	
End if 

//[Job_Forms_Items]ProductCode
$0:=$anArray