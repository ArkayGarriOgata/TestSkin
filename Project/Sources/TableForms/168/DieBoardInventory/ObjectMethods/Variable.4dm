
// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/28/18, 14:19:17
// ----------------------------------------------------
// Method: [Job_DieBoard_Inv].DieBoardInventory.Variable
// Description
// 
//
// Parameters
// ----------------------------------------------------

If (Form event code:C388=On After Keystroke:K2:26)
	ttQueryString:=Get edited text:C655
	SET TIMER:C645(30)
End if 