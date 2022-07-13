//%attributes = {"publishedWeb":true}
//(P) DeptPallet  -  Department Event Handler

uWinListCleanup
NewWindow(500; 70; 1; 0; "Department Palette"; "wCloseWinBox")
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "DeptEvent")
uWinListCleanup
POST OUTSIDE CALL:C329(-1)