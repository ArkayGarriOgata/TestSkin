// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 16:16:06
// ----------------------------------------------------
// Method: Form Method: Shipping_Form()  --> 

Case of 
	: (Form event code:C388=On Load:K2:1)
		BOL_inputOnLoad
		
	: (Form event code:C388=On Data Change:K2:15) | (Form event code:C388=On Double Clicked:K2:5)
		BOL_inputOnDataChange
		
	: (Form event code:C388=On Validate:K2:3)
		BOL_inputOnValidate  //put picks into blob
		
	: (Form event code:C388=On Unload:K2:2)
		BOL_inputOnUnLoad
		
	: (Form event code:C388=On Close Box:K2:21)
		BOL_inputOnCloseBox
		
End case 
