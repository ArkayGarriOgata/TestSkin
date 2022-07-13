//%attributes = {"publishedWeb":true}
//(P) sSemiFini
//•082997  MLB 
NewWindow(320; 290; 6; 8; "Remove Material From Job"; "wCloseCancel")
SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Raw_Materials_Locations:25])
//iMode:=5
DIALOG:C40([zz_control:1]; "SemiFinished")
CLOSE WINDOW:C154
uWinListCleanup
//