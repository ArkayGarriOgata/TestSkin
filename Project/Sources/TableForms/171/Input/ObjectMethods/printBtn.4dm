// _______
// Method: [Raw_Material_Labels].Input.printBtn   ( ) ->
// By: MelvinBohince @ 04/05/22, 14:26:27
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (4/5/22) save record before printing, manage the selection 

C_LONGINT:C283($selectedRecord)

SAVE RECORD:C53([Raw_Material_Labels:171])  // Modified by: MelvinBohince (4/5/22) in case chg was made
$selectedRecord:=Selected record number:C246([Raw_Material_Labels:171])

ARRAY LONGINT:C221($_beforePrint; 0)
LONGINT ARRAY FROM SELECTION:C647([Raw_Material_Labels:171]; $_beforePrint)

ONE RECORD SELECT:C189([Raw_Material_Labels:171])

RIM_PrintLabels

CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_beforePrint)
GOTO SELECTED RECORD:C245([Raw_Material_Labels:171]; $selectedRecord)
LOAD RECORD:C52([Raw_Material_Labels:171])  // Added by: Mel Bohince (4/17/19) 
