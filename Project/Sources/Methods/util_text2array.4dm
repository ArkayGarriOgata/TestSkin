//%attributes = {}
// Method: util_text2array () -> 
// ----------------------------------------------------
// by: mel: 07/27/05, 16:40:09
// ----------------------------------------------------
// Description:
// see also uText2Array2
// Updates:

// ----------------------------------------------------
C_LONGINT:C283($line; $char)
C_TEXT:C284($r)
$r:=Char:C90(13)
C_POINTER:C301($1)
$source:=$1
ARRAY TEXT:C222(axText; 0)
ARRAY TEXT:C222(axText; 50)  //pre size
$line:=1

For ($char; 1; Length:C16($source->))
	If ($source->[[$char]]=$r)
		$line:=$line+1
		If ($line>Size of array:C274(axText))
			ARRAY TEXT:C222(axText; Size of array:C274(axText)+50)
		End if 
	Else 
		axText{$line}:=axText{$line}+$source->[[$char]]
	End if 
End for 

If (Length:C16(axText{$line})=0)
	$line:=$line-1
End if 
ARRAY TEXT:C222(axText; $line)

$0:=$line
