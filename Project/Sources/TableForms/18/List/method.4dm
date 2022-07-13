app_basic_list_form_method

If (Form event code:C388=On Outside Call:K2:11)
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=<>TheEstID)
	RELATE MANY:C262([Estimates:17]EstimateNo:1)
	RELATE ONE SELECTION:C349([Estimates_PSpecs:57]; [Process_Specs:18])
End if 
