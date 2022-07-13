// Method: Form Method: [USER]Input () -> 
// ----------------------------------------------------
// by: mel: 04/18/05, 12:27:17
// • mel (4/18/05, 12:19:30) auto delete user
// ----------------------------------------------------
Case of 
	: (Form event code:C388=On Load:K2:1)
		HR_inputOnLoad
		
	: (Form event code:C388=On Validate:K2:3)
		HR_inputOnValidate
		
	: (Form event code:C388=On Data Change:K2:15)
		HR_inputOnDataChange
		
	: (Form event code:C388=On Unload:K2:2)
		ARRAY TEXT:C222(aDepartment; 0)
		
	: (Form event code:C388=On Close Box:K2:21)
		ARRAY TEXT:C222(aDepartment; 0)
		CANCEL:C270
End case 
