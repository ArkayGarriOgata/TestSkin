// _______
// Method: [Finished_Goods].AskMe.AskMeEditRelease   ( ) ->
//zSetUsageStat ("AskMe";"Mod Rel";sCustID+":"+sCPN)
//• mlb - 2/12/03  16:19 use named selection
// Modified by: Mel Bohince (3/3/21) restrict modification (locking) of releases by group membership

If (Records in set:C195("Customers_ReleaseSchedules")>0)
	COPY SET:C600("Customers_ReleaseSchedules"; "◊PassThroughSet")
	<>PassThrough:=True:C214
	If ((User in group:C338(Current user:C182; "RolePlanner")) | (User in group:C338(Current user:C182; "RoleCustomerService")))
		ViewSetter(2; ->[Customers_ReleaseSchedules:46])
	Else 
		ViewSetter(3; ->[Customers_ReleaseSchedules:46])
	End if 
	
Else 
	BEEP:C151
End if 
