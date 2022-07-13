//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 11:21:57
// ----------------------------------------------------
// Method: DieBoardInvAdd
// Description
// 
//
// Parameters
// ----------------------------------------------------

$xlWin:=Open form window:C675([Job_DieBoard_Inv:168]; "Input"; Movable form dialog box:K39:8)
FORM SET INPUT:C55([Job_DieBoard_Inv:168]; "Input")
ADD RECORD:C56([Job_DieBoard_Inv:168]; *)
CLOSE WINDOW:C154

DieBoardLoadAllRecs

