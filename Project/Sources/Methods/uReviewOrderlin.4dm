//%attributes = {"publishedWeb":true}
//Procedure: uReviewOrderlin()  101395  MLB

OBJECT SET ENABLED:C1123(bUp; False:C215)
OBJECT SET ENABLED:C1123(bDown; False:C215)
OBJECT SET ENABLED:C1123(bUp2; False:C215)
OBJECT SET ENABLED:C1123(bDown2; False:C215)
OBJECT SET ENABLED:C1123(bDelete; False:C215)
OBJECT SET ENABLED:C1123(bValidate; False:C215)
OBJECT SET ENABLED:C1123(bZoomSpec; False:C215)
OBJECT SET ENABLED:C1123(bRelAdd; False:C215)
OBJECT SET ENABLED:C1123(bRelEdit; False:C215)
OBJECT SET ENABLED:C1123(bRelDel; False:C215)

SetObjectProperties(""; ->bContract; False:C215)
uSetEntStatus(->[Customers_Order_Lines:41]; False:C215)