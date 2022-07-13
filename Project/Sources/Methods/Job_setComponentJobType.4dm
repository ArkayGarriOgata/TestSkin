//%attributes = {}
// -------
// Method: Job_setComponentJobType   ( ) ->
// By: Mel Bohince @ 03/07/17, 10:51:40
// Description
// nightly batch to assure jobtype is set to "3 COMPONENT" where applicable
// see also _version20170307
// ----------------------------------------------------

READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Master_Schedule:67])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	SET BLOB SIZE:C606($blob; 0)
	ARRAY TEXT:C222($aAssemblyJobs; 0)
	ARRAY TEXT:C222($aJobformsChanged; 0)
	//get all the component jobs
	$blob:=FG_getAssemblyJobs("Component")
	BLOB TO VARIABLE:C533($blob; $aAssemblyJobs)
	
	QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aAssemblyJobs)
	//find ones not already fixed
	QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]JobType:33#"3 COMPONENT")
	//set the jobtype
	If (Records in selection:C76([Job_Forms:42])>0)  // Modified by: Mel Bohince (3/21/17) 
		APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 COMPONENT")
		
		
		//carry the fix over to the jobmaster log
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobformsChanged)
		
		QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $aJobformsChanged)
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 COMPONENT")
	End if 
	
	
	//make sure the assembly jobtypes are set
	SET BLOB SIZE:C606($blob; 0)
	ARRAY TEXT:C222($aAssemblyJobs; 0)
	ARRAY TEXT:C222($aJobformsChanged; 0)
	
	$blob:=FG_getAssemblyJobs("Assembly")
	BLOB TO VARIABLE:C533($blob; $aAssemblyJobs)
	QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aAssemblyJobs)
	QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]JobType:33#"3 ASSEMBLY")
	If (Records in selection:C76([Job_Forms:42])>0)  // Modified by: Mel Bohince (3/21/17)
		APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 ASSEMBLY")
		
		//carry the fix over to the jobmaster log
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobformsChanged)
		QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $aJobformsChanged)
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 ASSEMBLY")
	End if 
	
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
Else 
	
	<>USE_SUBCOMPONENT:=True:C214
	
	
	QUERY BY FORMULA:C48([Job_Forms:42]; \
		([Job_Forms_Items:44]ProductCode:3=[Job_Forms_Materials:55]Raw_Matl_Code:7)\
		 & ([Job_Forms_Materials:55]Commodity_Key:12="33@")\
		 & ([Job_Forms:42]JobFormID:5=[Job_Forms_Items:44]JobForm:1)\
		 & ([Job_Forms:42]JobType:33#"3 COMPONENT")\
		)
	
	
	If (Records in selection:C76([Job_Forms:42])>0)  // Modified by: Mel Bohince (3/21/17) 
		APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 COMPONENT")
		RELATE MANY SELECTION:C340([Job_Forms_Master_Schedule:67]JobForm:4)
		
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 COMPONENT")
	End if 
	
	
	QUERY BY FORMULA:C48([Job_Forms:42]; \
		([Job_Forms:42]JobFormID:5=[Job_Forms_Materials:55]JobForm:1)\
		 & ([Job_Forms_Materials:55]Commodity_Key:12="33@")\
		 & ([Job_Forms:42]JobType:33#"3 ASSEMBLY")\
		)
	
	
	If (Records in selection:C76([Job_Forms:42])>0)  // Modified by: Mel Bohince (3/21/17)
		APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]JobType:33:="3 ASSEMBLY")
		RELATE MANY SELECTION:C340([Job_Forms_Master_Schedule:67]JobForm:4)
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobType:31:="3 ASSEMBLY")
	End if 
	
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	
End if   // END 4D Professional Services : January 2019 query selection
