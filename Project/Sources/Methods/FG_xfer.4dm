//%attributes = {"publishedWeb":true}
//(P) FG_xfer was gXferfg: allows moving fg between Locations
//OPEN WINDOW(2;40;368;330;8;nGetPrcsName ;"wCloseCancel")

SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Finished_Goods_Locations:35])
iMode:=0

CONFIRM:C162("Use new 'Skid Based' Move screen?"; "by Skid"; "by Jobit")
If (OK=1)
	windowTitle:="Finished Good Moves by Skid#"
	$winRef:=OpenFormWindow(->[zz_control:1]; "FGmove"; ->windowTitle; windowTitle)
	DIALOG:C40([zz_control:1]; "FGmove")
Else 
	//NewWindow (366;290;1;8;nGetPrcsName ;"wCloseCancel")
	windowTitle:="Finished Good Moves"
	$winRef:=OpenFormWindow(->[zz_control:1]; "FGTranfers"; ->windowTitle; windowTitle)
	DIALOG:C40([zz_control:1]; "FGTranfers")
End if 
CLOSE WINDOW:C154
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
UNLOAD RECORD:C212([Finished_Goods:26])