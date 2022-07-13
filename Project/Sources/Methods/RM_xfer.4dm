//%attributes = {"publishedWeb":true}
//(P) RM_xfer was gXferRM: allows moving Raw Materials between Locations
//upr 1261 10/27/94

Open window:C153(2; 40; 312; 200; 0; nGetPrcsName; "wCloseCancel")
SET MENU BAR:C67(4)
READ WRITE:C146([Raw_Materials_Locations:25])
DIALOG:C40([zz_control:1]; "RMTransfer")
UNLOAD RECORD:C212([Raw_Materials_Locations:25])
CLOSE WINDOW:C154
uWinListCleanup