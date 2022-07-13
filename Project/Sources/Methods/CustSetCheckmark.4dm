//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 09/27/13, 14:00:22
// ----------------------------------------------------
// Method: CustSetCheckmark
// Description
// Set/Removed a checkmark from the asBull column.
// ----------------------------------------------------

If (Form event code:C388=On Clicked:K2:4)
	If (asBull{bTeam}="√")  //Checkmark
		asBull{bTeam}:=""
	Else 
		asBull{bTeam}:="√"
	End if 
End if 