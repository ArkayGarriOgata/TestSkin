//%attributes = {"publishedWeb":true}
//(P) FG_destroy was gXferFGdestroy: allows moving fg between Locations

windowTitle:=nGetPrcsName
$winRef:=OpenFormWindow(->[zz_control:1]; "FGTranfers"; ->windowTitle; windowTitle)
SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Finished_Goods_Locations:35])
iMode:=4
DIALOG:C40([zz_control:1]; "FGTranfers")

uClearSelection(->[Finished_Goods_Transactions:33])  //• 3/26/97 cs
uClearSelection(->[Finished_Goods_Locations:35])
uClearSelection(->[Finished_Goods:26])
uClearSelection(->[Job_Forms_Items:44])
uClearSelection(->[Customers_Order_Lines:41])
uClearSelection(->[Customers_Orders:40])
uClearSelection(->[Jobs:15])
uClearSelection(->[Job_Forms:42])
uClearSelection(->[Customers:16])

CLOSE WINDOW:C154