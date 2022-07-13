//%attributes = {"publishedWeb":true}
//(P) sBillnHold: allows moving fg between Locations

windowTitle:=nGetPrcsName
$winRef:=OpenFormWindow(->[zz_control:1]; "FGTranfers"; ->windowTitle; windowTitle)
//MENU BAR(◊DefaultMenu)
app_Log_Usage("log"; "sBillnHold"; "Button on FG palette")
READ WRITE:C146([Finished_Goods_Locations:35])
iMode:=5
DIALOG:C40([zz_control:1]; "FGTranfers")
CLOSE WINDOW:C154