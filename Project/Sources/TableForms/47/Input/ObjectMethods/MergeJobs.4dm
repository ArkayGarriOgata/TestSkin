// ----------------------------------------------------
// Method: [Estimates].Input.MergeJobs   ( ) ->
// By: Mel Bohince @ 02/12/16, 12:07:27
// Description
// pull in cartons and bom from other jobs and set this estimate up as a combined customer, <>sCombindID <>CombinedCustomerName <>JobMergePjtID
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(Self:C308->; False:C215)
		If (User in group:C338(Current user:C182; "RolePlanner"))
			OBJECT SET ENABLED:C1123(Self:C308->; True:C214)
		End if 
		
	Else 
		Est_MergeForms(True:C214)
		
End case   //form event

