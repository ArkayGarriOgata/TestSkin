//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/02/13, 13:57:17
// ----------------------------------------------------
// Method: WindowPositionMove
// Description:
// Moves an existing window.
// There is a current record in [WindowSets].
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($x1; $y1; $x2; $y2; $xlLeft; $xlTop; $xlRight; $xlBottom)

WindowPositionGet($1; ->$x1; ->$y1; ->$x2; ->$y2)  //New position

SHOW PROCESS:C325([WindowSets:185]ProcID:12)
UNLOAD RECORD:C212([WindowSets:185])

WINDOW LIST:C442($hWinRefs)

For ($i; 1; Size of array:C274($hWinRefs))
	If (Get window title:C450($hWinRefs{$i})=$1)
		SET WINDOW RECT:C444($x1; $y1; $x2; $y2; $hWinRefs{$i})
		$i:=Size of array:C274($hWinRefs)
	End if 
End for 