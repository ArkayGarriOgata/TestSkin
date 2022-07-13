//%attributes = {"publishedWeb":true}
//(P) RM_Return was gRtnRM: allows returning Raw Materials between Locations

Open window:C153(2; 40; 312; 200; 0; nGetPrcsName; "wCloseCancel")
SET MENU BAR:C67(4)
READ WRITE:C146([Raw_Materials_Locations:25])
DIALOG:C40([zz_control:1]; "RMreturn")
UNLOAD RECORD:C212([Raw_Materials_Locations:25])
CLOSE WINDOW:C154
uWinListCleanup