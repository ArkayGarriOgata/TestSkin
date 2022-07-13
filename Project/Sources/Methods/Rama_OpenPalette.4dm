//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/09/12, 15:02:27
// ----------------------------------------------------
// Method: Rama_OpenPalette
// ----------------------------------------------------

uWinListCleanup

DEFAULT TABLE:C46([zz_control:1])

SET WINDOW TITLE:C213("Rama/Cayey Palette")
SET MENU BAR:C67(<>DefaultMenu)

$RamaPalette:=Open form window:C675("Rama_Palette"; Plain form window:K39:10; <>mewLeft; <>mewTop)
DIALOG:C40("Rama_Palette")

uWinListCleanup