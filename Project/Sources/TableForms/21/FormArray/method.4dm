
// Method: [Raw_Materials].FormArray ( )  -> 
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		gClrRMFields
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		bCancel:=1
End case 