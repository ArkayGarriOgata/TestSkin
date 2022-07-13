//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_Test
//Description:  This method can be used to test macros
//  it is already defined in the macros document.

If (True:C214)  //Initialize
	
	C_TEXT:C284($tTest)
	
End if   //Done Initialize

GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $tTest)

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "Changed")
