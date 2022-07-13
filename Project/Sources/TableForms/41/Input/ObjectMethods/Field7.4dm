a1:=1
a2:=0
Text24:=fAddressArrows(->aBilltos; 0; ->[Customers_Order_Lines:41]defaultBillto:23)
// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"BillTo Changed from "+Old:C35([Customers_Order_Lines:41]defaultBillto:23)+" to "+[Customers_Order_Lines:41]defaultBillto:23+Char:C90(Carriage return:K15:38)
