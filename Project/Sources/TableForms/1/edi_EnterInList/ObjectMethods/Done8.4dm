FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "edi_compare")
util_PAGE_SETUP(->[Customers_Order_Lines:41]; "edi_compare")
PRINT SELECTION:C60([Customers_Order_Lines:41])
FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")