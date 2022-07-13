//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/01/09, 15:09:45
// ----------------------------------------------------
// Method: util_uuid
// Description
// see Techtip 75873 How to generate a UUID
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (2/17/16) native 4D command now exists

C_TEXT:C284($0; $UUID_T)
C_LONGINT:C283($Ndx; $Idx; $SOA; $RIS; $Rnd_L; $End_L)
C_TEXT:C284($Chars_T)
If (True:C214)  // Modified by: Mel Bohince (2/17/16) native 4D command now exists
	$0:=Generate UUID:C1066
	
Else 
	//====================== Initialize and Setup ================================
	
	$Chars_T:="0123456789abcdef"
	$End_L:=Length:C16($Chars_T)-1
	
	//======================== Method Actions ==================================
	
	// // rfc 4122 requires this format for a version 4 (random number) UUID
	$UUID_T:="########-####-4###-####-############"
	
	
	For ($Ndx; 1; Length:C16($UUID_T))
		If ($UUID_T[[$Ndx]]="#")
			$Rnd_L:=util_random(0; $End_L)
			If ($Ndx=20)
				//Must be a value of 8, 9, a, or b
				$Idx:=($Rnd_L & 0x0003) | 0x0008
			Else 
				$Idx:=$Rnd_L
			End if 
			$UUID_T[[$Ndx]]:=$Chars_T[[$Idx+1]]
		End if 
	End for 
	
	//======================== Clean up and Exit =================================
	
	$0:=$UUID_T
End if 