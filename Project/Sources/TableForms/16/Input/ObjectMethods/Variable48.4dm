QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1; *)
QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
ORDER BY:C49([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2; >)
//