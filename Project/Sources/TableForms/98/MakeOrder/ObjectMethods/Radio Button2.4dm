// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 8/28/02  10:59
// ----------------------------------------------------
// Object Method: [Finished_Goods_Specifications].MakeOrder.Radio Button2
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

SetObjectProperties("order1@"; -><>NULL; True:C214)
SetObjectProperties("order2@"; -><>NULL; False:C215)
SetObjectProperties("order3@"; -><>NULL; False:C215)
SetObjectProperties("creating@"; -><>NULL; True:C214)
GOTO OBJECT:C206(vOrd)
OBJECT SET ENABLED:C1123(b1; True:C214)
OBJECT SET ENABLED:C1123(b2; True:C214)
b1:=1

OBJECT SET ENABLED:C1123(cb1; True:C214)
OBJECT SET ENABLED:C1123(cb2; True:C214)
OBJECT SET ENABLED:C1123(cb3; True:C214)
cb1:=1
cb2:=1
cb3:=1
If (r2=0)
	OBJECT SET ENABLED:C1123(cb2; False:C215)
	cb2:=0
End if 

If (r1=0)
	OBJECT SET ENABLED:C1123(cb1; False:C215)
	cb1:=0
End if 

If (r3=0)
	OBJECT SET ENABLED:C1123(cb3; False:C215)
	cb3:=0
End if 

Case of 
	: (cb2=1)  //nothing to bill
		cb1:=0
		cb3:=0
	: (cb1=1)
		cb3:=0
	: (cb3=1)
		//just leave it on        
	Else 
		OBJECT SET ENABLED:C1123(bOk; False:C215)
End case 

ARRAY TEXT:C222(aPickList; 0)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=[Finished_Goods_Specifications:98]ProjectNumber:4)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Customers_Orders:40])
		QUERY SELECTION:C341([Customers_Orders:40]; [Customers_Orders:40]Status:10#"c@")
		SELECTION TO ARRAY:C260([Customers_Orders:40]OrderNumber:1; $aOrder; [Customers_Orders:40]PONumber:11; $aPO)
		ARRAY TEXT:C222(aPickList; Size of array:C274($aOrder))
		For ($i; 1; Size of array:C274($aOrder))
			aPickList{$i}:=String:C10($aOrder{$i})+" PO: "+$aPO{$i}
		End for 
		SORT ARRAY:C229(aPickList; >)
		INSERT IN ARRAY:C227(aPickList; 1; 1)
		aPickList{1}:="00000  <none>"
	End if 
	
Else 
	C_LONGINT:C283($nb_records)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $nb_records)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=[Finished_Goods_Specifications:98]ProjectNumber:4)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($nb_records>0)
		
		QUERY BY FORMULA:C48([Customers_Orders:40]; \
			([Customers_Order_Lines:41]ProjectNumber:50=[Finished_Goods_Specifications:98]ProjectNumber:4)\
			 & ([Customers_Orders:40]Status:10#"c@")\
			)
		SELECTION TO ARRAY:C260([Customers_Orders:40]OrderNumber:1; $aOrder; [Customers_Orders:40]PONumber:11; $aPO)
		ARRAY TEXT:C222(aPickList; Size of array:C274($aOrder))
		For ($i; 1; Size of array:C274($aOrder))
			aPickList{$i}:=String:C10($aOrder{$i})+" PO: "+$aPO{$i}
		End for 
		SORT ARRAY:C229(aPickList; >)
		INSERT IN ARRAY:C227(aPickList; 1; 1)
		aPickList{1}:="00000  <none>"
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
