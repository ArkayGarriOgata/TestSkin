//%attributes = {"publishedWeb":true}
//(P) RmCleanUp  -  RMCleanUp event handler

NewWindow(500; 150; 1; 0; "Raw Material CleanUp Palette"; "wCloseWinBox")
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "RmCleanUp")
CLOSE WINDOW:C154
uWinListCleanup  //• 7/24/97 cs cleanup process list