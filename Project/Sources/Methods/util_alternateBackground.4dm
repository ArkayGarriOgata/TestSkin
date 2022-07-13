//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/01/06, 14:31:28
// ----------------------------------------------------
// Method: util_alternateBackground
// Description
// form method for alternating backgound
//set the fill color to white and pattern to white on "BackRect"
//make the fields transparent
//use DigitalColor Meter.app to get settings 22
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($1; $2; $3; $4; $5; $6)
If (Form event code:C388=On Display Detail:K2:22)
	$n:=Displayed line number:C897
	$n:=$n%2
	If (Count parameters:C259=0)
		If ($n=0)
			$r:=230  //light blue
			$v:=230
			$b:=255
		Else 
			$r:=255  //light white
			$v:=255
			$b:=255
		End if 
	Else 
		If ($n=0)
			$r:=$1  //light blue
			$v:=$2
			$b:=$3
		Else 
			$r:=$4  //light grey
			$v:=$5
			$b:=$6
		End if 
	End if 
	$rvb:=($r*256*256)+($v*256)+$b
	OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)
End if 