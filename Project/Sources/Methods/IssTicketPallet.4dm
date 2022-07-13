//%attributes = {"publishedWeb":true}
//(P) IssTicketPallet  -  Issue ticket Event Handler

uWinListCleanup
NewWindow(300; 70; 1; 0; "Issue Ticket Palette"; "wCloseWinBox")
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "IssTicketEvent")
uWinListCleanup
POST OUTSIDE CALL:C329(-1)