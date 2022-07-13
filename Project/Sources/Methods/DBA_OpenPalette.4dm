//%attributes = {"publishedWeb":true}
//(P) mAdminEvent  -  Admin Event Handler
//--------------------------------

uWinListCleanup

READ WRITE:C146([zz_control:1])
DEFAULT TABLE:C46([zz_control:1])
ALL RECORDS:C47([zz_control:1])
filePtr:=->[zz_control:1]
READ WRITE:C146([z_administrators:2])
ALL RECORDS:C47([z_administrators:2])
SET WINDOW TITLE:C213(<>sAPPNAME)
//NewWindow (635;438;2;0;"Data Base Administrator";"wCloseWinBox")
windowTitle:="Data Base Administrator"
$winRef:=OpenFormWindow(->[zz_control:1]; "AdminEvent"; ->windowTitle; windowTitle)
SET MENU BAR:C67(<>DefaultMenu)
C_LONGINT:C283(iTabControl)
iTabControl:=0
//DIALOG([CONTROL];"AdminEvent")
FORM SET INPUT:C55([zz_control:1]; "AdminEvent")
MODIFY RECORD:C57([zz_control:1]; *)
SAVE RECORD:C53([zz_control:1])
SAVE RECORD:C53([z_administrators:2])
UNLOAD RECORD:C212([x_id_numbers:3])
CLOSE WINDOW:C154
uWinListCleanup