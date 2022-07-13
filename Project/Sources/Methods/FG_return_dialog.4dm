//%attributes = {"publishedWeb":true}
//(P) gXferFGrtn: allows moving fg between Locations
//•030596  MLB separate from other transfers
C_TEXT:C284(sCriterion9)

windowTitle:=nGetPrcsName
$winRef:=OpenFormWindow(->[zz_control:1]; "FGtransfer_rtns"; ->windowTitle; windowTitle)
SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Finished_Goods_Locations:35])
iMode:=1
DIALOG:C40([zz_control:1]; "FGtransfer_rtns")  //•030596  MLB separate from other transfers
//see also [CONTROL];"FGTranfers"
CLOSE WINDOW:C154