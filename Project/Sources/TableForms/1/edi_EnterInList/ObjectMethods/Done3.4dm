QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="New@"; *)
QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_line_status:55="Change@")
ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_arkay_planner:68; >; [Customers_Order_Lines:41]OrderLine:3; >)