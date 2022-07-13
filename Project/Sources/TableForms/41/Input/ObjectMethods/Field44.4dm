a1:=0
a2:=1
Text24:=fAddressArrows(->aShiptos; 0; ->[Customers_Order_Lines:41]defaultShipTo:17)

// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"BillTo Changed from "+Old:C35([Customers_Order_Lines:41]defaultShipTo:17)+" to "+[Customers_Order_Lines:41]defaultShipTo:17+Char:C90(Carriage return:K15:38)
