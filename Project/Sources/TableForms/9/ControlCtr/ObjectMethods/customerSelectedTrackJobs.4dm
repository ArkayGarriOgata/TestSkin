// Method: [Customers_Projects].ControlCtr.customerSelectedTrackJobs   ( ) ->
// By: Mel Bohince 
// Modified by: Mel Bohince (6/4/21) lock in 4D Professional Services : January 2019 

zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Users_Record_Accesses:94])+" file. Please Wait...")
User_AllowedRecords(Table name:C256(->[Customers_Projects:9]))

ARRAY TEXT:C222($_id; 0)  // BEGIN 4D Professional Services : January 2019 query selection
DISTINCT VALUES:C339([Customers_Projects:9]id:1; $_id)
QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]ProjectNumber:26; $_id)
QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
zwStatusMsg(""; "")

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "◊PassThroughSet")
	<>PassThrough:=True:C214
	ViewSetter(2; ->[Job_Forms_Master_Schedule:67])
Else 
	uConfirm("There are no JobMaster records for your projects."; "Good!"; "What?")
End if 