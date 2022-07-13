//[issuetickets]input

C_BOOLEAN:C305(fUpdate)
Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(bdelete; False:C215)
		fUpdate:=True:C214
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Job_Forms_Issue_Tickets:90]ModDate:11; ->[Job_Forms_Issue_Tickets:90]ModWho:10)
End case 
//