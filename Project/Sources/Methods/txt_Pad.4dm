//%attributes = {"publishedWeb":true}
//PM:  txt_Pad(padThis;withThis;atEnd;finalLength)->paddedText  
//formerly  ` (P) gPad
// $1 = value to be padded
// $2 = pad character
// $3 = direction :: -1 pad beginning; 1 pad end ; 0 both direction, centering src
// $4 = length of final string

C_TEXT:C284($2)  // pad character
C_LONGINT:C283($3; $4)  // direction of pad & desired length of return string
C_LONGINT:C283($pad; $padLeft; $padRight)
C_TEXT:C284($0; $1)

Case of 
	: (Count parameters:C259<4)
		BEEP:C151
		ALERT:C41("Error: txt_Pad requires 4 parameters.")
		
	: ($3<0)  // pad beginning: A => 000A
		$0:=($2*($4-Length:C16($1)))+$1
		
	: ($3=0)  // pad both: A => 00A0
		$pad:=$4-Length:C16($1)
		$padRight:=$pad\2
		$padLeft:=$pad-$padRight
		$0:=($2*$padLeft)+$1+($2*$padRight)
		
	: ($3>0)  // pad ending: A => A000
		$0:=$1+($2*($4-Length:C16($1)))
		
	Else 
		ALERT:C41("Error: txt_Pad encountered a bad padding code: "+$2)
End case 