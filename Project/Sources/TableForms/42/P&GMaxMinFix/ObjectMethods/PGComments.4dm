// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/18/13, 16:00:56
// ----------------------------------------------------
// Method: [Job_Forms].P&GMaxMinFix.PGComments
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Data Change:K2:15)
		[Job_Forms:42]PandGProbsComments:85:=PGComments
		
	: (Form event code:C388=On Getting Focus:K2:7)
		SetMandatoryOM(Self:C308; "This is a mandatory field."; "On Getting Focus")
		
	: (Form event code:C388=On Losing Focus:K2:8)
		SetMandatoryOM(Self:C308; "This is a mandatory field."; "On Losing Focus")
		
End case 