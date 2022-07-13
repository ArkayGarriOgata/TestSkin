
// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 16:14:38
// ----------------------------------------------------
// Method: [Job_DieBoard_Inv].DieBoardInventory.List Box
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($xlCol; $xlRow)
LISTBOX GET CELL POSITION:C971(lrDieBoards; $xlCol; $xlRow)
If ((Form event code:C388=On Double Clicked:K2:5) & ($xlRow>0))
	GOTO SELECTED RECORD:C245([Job_DieBoard_Inv:168]; $xlRow)
	$xlWin:=Open form window:C675([Job_DieBoard_Inv:168]; "Input"; Movable form dialog box:K39:8)
	FORM SET INPUT:C55([Job_DieBoard_Inv:168]; "Input")
	MODIFY RECORD:C57([Job_DieBoard_Inv:168]; *)
	CLOSE WINDOW:C154
	
	REDRAW:C174(lrDieBoards)
End if 
