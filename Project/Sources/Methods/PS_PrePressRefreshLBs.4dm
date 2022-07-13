//%attributes = {}
// _______
// Method: PS_PrePressRefreshLBs   ( ) ->
// By: MelvinBohince @ 03/02/22, 15:24:44
// Description
//  refresh the listboxes
// ----------------------------------------------------


Form:C1466.topLeft_es:=Form:C1466.topLeft_es
Form:C1466.bottomLeft_es:=Form:C1466.bottomLeft_es
Form:C1466.topRight_es:=Form:C1466.topRight_es
Form:C1466.bottomRight_es:=Form:C1466.bottomRight_es

OBJECT SET ENABLED:C1123(*; "jsSelected_@"; False:C215)
Form:C1466.activeJobSequence_t:=""

//deselection last selected row
LISTBOX SELECT ROW:C912(*; "LB_@"; 0; lk remove from selection:K53:3)
