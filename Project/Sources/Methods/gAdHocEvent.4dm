//%attributes = {"publishedWeb":true}
//(P) AdHocEvent  -  Adhoc Event Handler

NewWindow(500; 80; 1; 0; "Search/Report Palette"; "wCloseWinBox")
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "AdhocEvent")
uWinListCleanup
POST OUTSIDE CALL:C329(-1)