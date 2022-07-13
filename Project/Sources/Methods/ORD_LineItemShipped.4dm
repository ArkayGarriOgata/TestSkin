//%attributes = {"publishedWeb":true}
//PM: ORD_LineItemShipped(qty;date;orderline) -> success or failure
//formerly:
//Procedure: uManifestOL()  092995  MLB
//•022897  MLB  try to prevent premature closings by regenerating qtyOpen
//        rather than just decrementing it

C_LONGINT:C283($1; $qty; $4)
C_DATE:C307($2; $XactDate)
C_TEXT:C284($3; $ordLine)
C_BOOLEAN:C305($0; $success; $pay_use)

$qty:=$1
$XactDate:=$2
$ordLine:=$3
$success:=False:C215

If (Count parameters:C259>3)
	$pay_use:=($4=1)
Else 
	$pay_use:=[Customers_Bills_of_Lading:49]PayUse:23
End if 

READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$ordLine)
If (Count parameters:C259<4)  //don't think these are needed
	READ WRITE:C146([Customers_Orders:40])
	RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
End if 
If ((Records in selection:C76([Customers_Order_Lines:41])=1) & (fLockNLoad(->[Customers_Order_Lines:41])))
	If ($pay_use)  //•092695  MLB  UPR 1729
		[Customers_Order_Lines:41]PayUxfers:41:=[Customers_Order_Lines:41]PayUxfers:41+$qty
		
	Else   //normal
		[Customers_Order_Lines:41]Qty_Shipped:10:=[Customers_Order_Lines:41]Qty_Shipped:10+$qty
		[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35  //•022897  MLB 
		
		If ([Customers_Order_Lines:41]Qty_Open:11<=0)
			[Customers_Order_Lines:41]DateCompleted:12:=$XactDate
			[Customers_Order_Lines:41]ReasonForClose:46:="Met Order Quantity"
			If ([Customers:16]ID:1#[Customers_Order_Lines:41]CustID:4)
				READ ONLY:C145([Customers:16])
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
			End if 
			If (Not:C34([Customers:16]ManualOrdClose:48))  //•082395 mlb upr 1718
				[Customers_Order_Lines:41]Status:9:="Closed"
			End if 
			
		Else 
			[Customers_Order_Lines:41]DateCompleted:12:=!00-00-00!
			If ([Customers_Order_Lines:41]Status:9="Closed")  //mlb 082395
				[Customers_Order_Lines:41]Status:9:="Adjusted"
				[Customers_Order_Lines:41]ReasonForClose:46:=""
			End if 
		End if   //open=0
	End if   //payu
	SAVE RECORD:C53([Customers_Order_Lines:41])
	$success:=True:C214
	
Else 
	$success:=False:C215
	If (Count parameters:C259<4)
		BEEP:C151
		ALERT:C41(" Order Line record locked"; "Cancel")
	End if 
End if 

$0:=$success