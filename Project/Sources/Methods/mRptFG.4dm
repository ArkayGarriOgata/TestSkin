//%attributes = {"publishedWeb":true}
//(P) mRptFG

FORM SET OUTPUT:C54([Finished_Goods:26]; "Rpt")
iPage:=1
xReptTitle:="Finished Goods Profile Report"
xComment:=""
PRINT SELECTION:C60([Finished_Goods:26])
FORM SET OUTPUT:C54([Finished_Goods:26]; "List")