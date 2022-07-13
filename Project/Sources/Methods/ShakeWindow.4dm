//%attributes = {}
// ----------------------------------------------------
// Method: ShakeWindow
// Description:
// Shakes the window 5 times
// ----------------------------------------------------

C_LONGINT:C283($lLeft; $lTop; $lRight; $lBottom; $lCurrentProcess)
C_LONGINT:C283($lLeft_Left; $lRight_Left; $lLeft_Right; $lRight_Right)

GET WINDOW RECT:C443($lLeft; $lTop; $lRight; $lBottom)

$lLeft_Left:=$lLeft-10
$lRight_Left:=$lRight-10

$lLeft_Right:=$lLeft+10
$lRight_Right:=$lRight+10

$lCurrentProcess:=Current process:C322

For ($i; 1; 5)
	SET WINDOW RECT:C444($lLeft_Left; $lTop; $lRight_Left; $lBottom)
	DELAY PROCESS:C323($lCurrentProcess; 1)
	SET WINDOW RECT:C444($lLeft_Right; $lTop; $lRight_Right; $lBottom)
	DELAY PROCESS:C323($lCurrentProcess; 1)
End for 

SET WINDOW RECT:C444($lLeft; $lTop; $lRight; $lBottom)