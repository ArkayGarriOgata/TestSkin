// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 09/26/13, 11:40:37
// ----------------------------------------------------
// Form Method: [Raw_Materials].RMSelection
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		rbBoard:=1
		rbSensors:=0
		rbColdFoil:=0
		cb1:=1  // Added by: Mark Zinke (2/3/14) 
		cb2:=1
		//OBJECT SET ENABLED(bOK;False)
		
	: (Form event code:C388=On Clicked:K2:4)
		If ((rbBoard=1) | (rbSensors=1) | (rbColdFoil=1))
			OBJECT SET ENABLED:C1123(bOK; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bOK; False:C215)
		End if 
End case 