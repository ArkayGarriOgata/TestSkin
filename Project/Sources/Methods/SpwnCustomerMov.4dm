//%attributes = {"publishedWeb":true}
//(p) SpwnCustomerMove
//• 9/16/97 cs created
SET MENU BAR:C67(<>DefaultMenu)
NewWindow(540; 300; 0; 5; "ReAssign Customer/Sales Rep")
DIALOG:C40([zz_control:1]; "ReAssignCust")
uWinListCleanup