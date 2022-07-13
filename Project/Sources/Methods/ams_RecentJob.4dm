//%attributes = {"publishedWeb":true}
//PM: ams_RecentJob() -> 
//@author mlb - 7/1/02  10:49

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""

If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Job_Forms:42])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]VersionDate:58>=$cutOffDate)
		//QUERY([JobForm]; | ;[JobForm]StartDate=!00/00/00!)
		
		CREATE SET:C116([Job_Forms:42]; "recentJobForms")
		$0:="recentJobForms"
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentJobForms")
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]VersionDate:58>=$cutOffDate)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentJobForms"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentJobForms")
End if 