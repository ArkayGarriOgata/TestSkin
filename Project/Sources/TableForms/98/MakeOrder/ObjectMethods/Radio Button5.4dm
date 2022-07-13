// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 8/28/02  11:00
// ----------------------------------------------------
// Object Method: [Finished_Goods_Specifications].MakeOrder.Radio Button5
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

SetObjectProperties("order1@"; -><>NULL; False:C215)
SetObjectProperties("order2@"; -><>NULL; True:C214)
SetObjectProperties("order3@"; -><>NULL; False:C215)
SetObjectProperties("creating@"; -><>NULL; True:C214)
GOTO OBJECT:C206(vOrd)
b1:=0
b2:=0
OBJECT SET ENABLED:C1123(b1; False:C215)
OBJECT SET ENABLED:C1123(b2; False:C215)
cb1:=0
cb2:=0
cb3:=0
OBJECT SET ENABLED:C1123(cb1; False:C215)
OBJECT SET ENABLED:C1123(cb2; False:C215)
OBJECT SET ENABLED:C1123(cb3; False:C215)

ARRAY TEXT:C222(aPickList; 0)
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=[Finished_Goods_Specifications:98]ProjectNumber:4; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5="Prep@")
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Customers_Orders:40])
	SELECTION TO ARRAY:C260([Customers_Orders:40]OrderNumber:1; $aOrder; [Customers_Orders:40]PONumber:11; $aPO)
	ARRAY TEXT:C222(aPickList; Size of array:C274($aOrder))
	For ($i; 1; Size of array:C274($aOrder))
		aPickList{$i}:=String:C10($aOrder{$i})+" PO: "+$aPO{$i}
	End for 
	SORT ARRAY:C229(aPickList; >)
	INSERT IN ARRAY:C227(aPickList; 1; 1)
	aPickList{1}:="00000  <none>"
End if 