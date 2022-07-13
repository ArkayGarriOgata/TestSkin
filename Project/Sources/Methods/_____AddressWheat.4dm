//%attributes = {}
//Garri: this was the test code run in the Application process, really need to join the active shipto and billto before changing the “Active” tag. 
//But in the many to many Customers_Addresses table the unused should prolly be removed because the extra just
//make the user interface more difficult with the noise to signal ratio.

//lauder shiptos
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3="ship to"; *)
QUERY:C277([Customers_Addresses:31]; [Customers:16]ParentCorp:19="Est@")
//remove redundancy
DISTINCT VALUES:C339([Customers_Addresses:31]CustAddrID:2; $aShipTos)
//these are all of those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aShipTos)
CREATE SET:C116([Addresses:30]; "allShipTos")

//active releases
QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Shipto:10; $aShipTos)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
//active shiptos
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aShipTos)

//find those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aShipTos)
CREATE SET:C116([Addresses:30]; "usedShipTos")

//separate the wheat from the chaff
DIFFERENCE:C122("allShipTos"; "usedShipTos"; "notUsedShipTos")
USE SET:C118("notUsedShipTos")

ALERT:C41("allShipTos "+String:C10(Records in set:C195("allShipTos")))
ALERT:C41("usedShipTos "+String:C10(Records in set:C195("usedShipTos")))
ALERT:C41("notUsedShipTos "+String:C10(Records in set:C195("notUsedShipTos")))


//lauder Billtos
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3="Bill to"; *)
QUERY:C277([Customers_Addresses:31]; [Customers:16]ParentCorp:19="Est@")
//remove redundancy
DISTINCT VALUES:C339([Customers_Addresses:31]CustAddrID:2; $aBillTos)
//these are all of those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aBillTos)
CREATE SET:C116([Addresses:30]; "allBillTos")

//active releases
QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Billto:22; $aBillTos)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
//active Billtos
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Billto:22; $aBillTos)

//find those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aBillTos)
CREATE SET:C116([Addresses:30]; "usedBillTos")

//separate the wheat from the chaff
DIFFERENCE:C122("allBillTos"; "usedBillTos"; "notUsedBillTos")
USE SET:C118("notUsedBillTos")

ALERT:C41("allBillTos "+String:C10(Records in set:C195("allBillTos")))
ALERT:C41("usedBillTos "+String:C10(Records in set:C195("usedBillTos")))
ALERT:C41("notUsedBillTos "+String:C10(Records in set:C195("notUsedBillTos")))

//set Active to False
UNION:C120("notUsedShipTos"; "notUsedBillTos"; "setActiveFalse")
USE SET:C118("setActiveFalse")
ALERT:C41("setActiveFalse "+String:C10(Records in set:C195("setActiveFalse")))

//APPLY TO SELECTION([Addresses];[Addresses]Active:=False)

CLEAR SET:C117("allShipTos")
CLEAR SET:C117("usedShipTos")
CLEAR SET:C117("notUsedShipTos")

CLEAR SET:C117("allBillTos")
CLEAR SET:C117("usedBillTos")
CLEAR SET:C117("notUsedBillTos")

CLEAR SET:C117("setActiveFalse")
