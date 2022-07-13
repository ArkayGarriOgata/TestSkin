//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gPhyInvEvent
// Description:
// Physical Inventory Event Handler
// ----------------------------------------------------

NewWindow(500; 85; 1; 4; "Physical Inventory Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/8/13) Type was 0, Heigth was 75
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "PhyInvEvent")

<>fPhyInv:=False:C215
<>PIProcess:=0
POST OUTSIDE CALL:C329(-1)