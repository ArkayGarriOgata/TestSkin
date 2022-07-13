//%attributes = {}

ARRAY LONGINT:C221($anOrderNumber; 0)
ARRAY POINTER:C280($apRelatedField; 0)

APPEND TO ARRAY:C911($apRelatedField; ->[Customers_Orders:40]OrderNumber:1)
APPEND TO ARRAY:C911($apRelatedField; ->[Customers_Order_Lines:41]OrderNumber:1)
APPEND TO ARRAY:C911($apRelatedField; ->[Customers_ReleaseSchedules:46]OrderNumber:2)
APPEND TO ARRAY:C911($apRelatedField; ->[Customers_ReleaseSchedules:46]OrderLine:4)
APPEND TO ARRAY:C911($apRelatedField; ->[Customers_Order_Change_Orders:34]OrderNo:5)
APPEND TO ARRAY:C911($apRelatedField; ->[Customers_Invoices:88]OrderLine:4)  //INV_testCommission
APPEND TO ARRAY:C911($apRelatedField; ->[Jobs:15]OrderNo:15)
APPEND TO ARRAY:C911($apRelatedField; ->[Finished_Goods_Specifications:98]OrderNumber:59)
APPEND TO ARRAY:C911($apRelatedField; ->[Finished_Goods_Transactions:33]OrderNo:15)
APPEND TO ARRAY:C911($apRelatedField; ->[Finished_Goods:26]LastOrderNo:18)
APPEND TO ARRAY:C911($apRelatedField; ->[Prep_Charges:103]OrderNumber:8)

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1>=80000; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]OrderNumber:1<90000)

SELECTION TO ARRAY:C260([Customers_Orders:40]OrderNumber:1; $anOrderNumber)

Core_Record_DocRelated(->$anOrderNumber; ->$apRelatedField)
