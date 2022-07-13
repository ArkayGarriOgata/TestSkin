//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/01/09, 15:11:41
// ----------------------------------------------------
// Method: util_random(min;max)
// Description
// see techtip 75874 "A wrapper for Random with added functionality"
//
// Parameters
// ----------------------------------------------------
//UTIL_Random ($Min_L;$Max_L) -> LONGINT

C_LONGINT:C283($0; $Rand_L)
C_LONGINT:C283($Min_L; $1)
C_LONGINT:C283($Max_L; $2)
//--------------------------------------------------------------------------------
C_BOOLEAN:C305(<>RandomWarmed_b)
//--------------------------------------------------------------------------------
C_LONGINT:C283($Ndx; $Jdx; $Kdx; $SOA; $RIS)

//====================== Initialize and Setup ================================

$Min_L:=$1
$Max_L:=$2

// // For speed purposes this is only done once
If (Not:C34(<>RandomWarmed_b))
	$RIS:=(Milliseconds:C459%(32768-10+1))+10
	For ($Ndx; 1; $RIS)
		$SOA:=Random:C100
	End for 
End if 

//======================== Method Actions ==================================

If ($Max_L<$Min_L)
	$Ndx:=$Max_L
	$Max_L:=$Min_L
	$Min_L:=$Ndx
End if 

If ($Max_L>MAXINT:K35:1)
	$Max_L:=MAXINT:K35:1
End if 

If ($Min_L=$Max_L)
	$Jdx:=0
	$Kdx:=MAXINT:K35:1-1
	$Ndx:=$Kdx-$Jdx
	$Rand_L:=$Jdx+(Int:C8(((Random:C100/32768)*$Ndx)+1))
	$Rand_L:=$Rand_L/MAXINT:K35:1
	
Else 
	$Jdx:=$Min_L-1
	If ($Max_L=MAXINT:K35:1)
		$Max_L:=$Max_L-1
	End if 
	$Kdx:=$Max_L
	$Ndx:=$Kdx-$Jdx
	$Rand_L:=$Jdx+(Int:C8(((Random:C100/32768)*$Ndx)+1))
	
End if 

//======================== Clean up and Exit =================================

$0:=$Rand_L