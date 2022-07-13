//%attributes = {"publishedWeb":true}
//POI_zeroQtyOpen(poi#)

C_TEXT:C284($1)

READ WRITE:C146([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$1)
If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	zwStatusMsg("ZERO QTY"; String:C10(Records in selection:C76([Purchase_Orders_Items:12]))+" Items will be set to zero")
	APPLY TO SELECTION:C70([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27:=0)
Else 
	BEEP:C151
	zwStatusMsg("ZERO QTY"; $1+" was not found")
End if 

REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)