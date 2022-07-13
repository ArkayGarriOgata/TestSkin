// ----------------------------------------------------
// Form Method: [Job_Forms_Master_Schedule].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_DATE:C307(newHRD)
		C_LONGINT:C283(vAskMePID)
		
		JML_OnLoadForm
		fSetMAD:=False:C215
		newHRD:=[Job_Forms_Master_Schedule:67]MAD:21
		SetObjectProperties(""; ->bApplyMAD; True:C214; "Set Items' HRD")  // Modified by: Mark Zinke (5/15/13)
		
	: (Form event code:C388=On Validate:K2:3)
		JML_OnValidateForm
		
	: (Form event code:C388=On Unload:K2:2)
		JML_OnUnLoadForm
End case 
