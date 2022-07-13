//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/09/13, 10:07:33
// ----------------------------------------------------
// Method: WindowPositionCloseWindows
// Description:
// Closes all open supported windows, Palettes and other windows.
// ----------------------------------------------------

WINDOW LIST:C442($hWinRefs)

For ($i; 1; Size of array:C274($hWinRefs))
	$tWinTitle:=Get window title:C450($hWinRefs{$i})
	If (WindowPositionWindows($tWinTitle))
		$xlProcID:=Window process:C446($hWinRefs{$i})
		HIDE PROCESS:C324($xlProcID)
	End if 
End for 