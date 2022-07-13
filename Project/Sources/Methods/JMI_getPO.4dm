//%attributes = {}
// Method: JMI_getPO () -> 
// ----------------------------------------------------
// by: mel: 07/20/05, 14:05:50
// ----------------------------------------------------
// Modified by: Mel Bohince (12/13/18) option to get po to vendor with 2 paramters

C_LONGINT:C283($num)
C_TEXT:C284($1; $0)

If (Length:C16($1)>8)  //jobit
	READ ONLY:C145([Customers_Order_Lines:41])
	
	If ([Job_Forms_Items:44]Jobit:4#$1)
		READ ONLY:C145([Job_Forms_Items:44])
		$num:=qryJMI($1)
	End if 
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			$0:=[Customers_Order_Lines:41]PONumber:21
		Else 
			$0:=[Job_Forms_Items:44]OrderItem:2
		End if 
	Else 
		$0:="n/f"
	End if 
	
Else   //jobform
	READ ONLY:C145([Purchase_Orders_Job_forms:59])
	QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2=$1)
	If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
		$0:=Substring:C12([Purchase_Orders_Job_forms:59]POItemKey:1; 1; 7)
	Else 
		$0:="PO n/f"
	End if 
End if 
