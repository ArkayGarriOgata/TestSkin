//%attributes = {"publishedWeb":true}
//util_ScreenCoordinatesInbounds(left;top;right;bottom)->True or false
C_LONGINT:C283($left; $right; $bottom; $top; $border; $screens; $1; $2; $3; $4; $sLeft; $sTop; $sRight; $sBottom)
$left:=$1
$top:=$2
$right:=$3
$bottom:=$4
C_BOOLEAN:C305($0; $fits)
$fits:=False:C215
$screens:=Count screens:C437

//test for size
If (Abs:C99($left-$right)>70) & (Abs:C99($top-$bottom)>70)
	For ($i; 1; $screens)
		SCREEN COORDINATES:C438($sLeft; $sTop; $sRight; $sBottom; $i)
		If ($left>=$sLeft)
			If ($top>=$sTop)
				If ($right<=$sRight)
					If ($bottom<=$sBottom)
						$fits:=True:C214
						$i:=999  //break
					End if 
				End if 
			End if 
		End if 
	End for   //each screen
End if 
$0:=$fits