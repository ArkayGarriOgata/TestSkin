//%attributes = {"publishedWeb":true}
//Procedure: uSplStatOrderli()  101395  MLB
//• 4/20/98 cs users want to combine multiple divisions of same customer
//•120998  MLB  UPR allow over/under modes
OBJECT SET ENABLED:C1123(bUp; False:C215)
OBJECT SET ENABLED:C1123(bDown; False:C215)
OBJECT SET ENABLED:C1123(bUp2; False:C215)
OBJECT SET ENABLED:C1123(bDown2; False:C215)

OBJECT SET ENABLED:C1123(bRelAdd; False:C215)
OBJECT SET ENABLED:C1123(bRelEdit; False:C215)
OBJECT SET ENABLED:C1123(bRelDel; False:C215)

If (iMode<3)
	uSetEntStatus(->[Customers_Order_Lines:41]; False:C215)
End if 