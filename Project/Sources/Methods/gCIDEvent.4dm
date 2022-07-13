//%attributes = {"publishedWeb":true}
//(P) mCIDEvent  -  CID Event Handler

Open window:C153(2; 180; 502; 330; 0; "PO Clause Palette"; "wCloseWinBox")
SET MENU BAR:C67(<>DefaultMenu)
Repeat 
	DIALOG:C40([zz_control:1]; "CIDEvent")
Until (bDone=1)
<>fCls:=False:C215
<>ClsProcess:=0
//OBJECT SET ENABLED(◊ibCls;True)
POST OUTSIDE CALL:C329(-1)