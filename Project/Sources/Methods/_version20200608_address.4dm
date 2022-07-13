//%attributes = {}
// _______
// Method: _version2020608_address   ( ) ->
// By: Mel Bohince @ 06/08/20, 12:23:08
// Description
// cleanse the address table
// ----------------------------------------------------
//NOT DONE
//NOT DONE
//NOT DONE
ARRAY TEXT:C222($aAddressIDs; 0)

READ WRITE:C146([Addresses:30])
READ WRITE:C146([Customers_Addresses:31])
READ ONLY:C145([Customers_ReleaseSchedules:46])

//lauder linked addresses
//QUERY([Customers_Addresses];[Customers_Addresses]AddressType="ship to";*)
QUERY:C277([Customers_Addresses:31]; [Customers:16]ParentCorp:19="Estée Lauder Companies")
//remove redundancy
DISTINCT VALUES:C339([Customers_Addresses:31]CustAddrID:2; $aAddressIDs)
//these are all of those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aAddressIDs)
CREATE SET:C116([Addresses:30]; "all")  //these are all the address records linked to ELC

//active releases
QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Shipto:10; $aAddressIDs)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
//active shiptos
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aAddressIDs)
//find those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aAddressIDs)
CREATE SET:C116([Addresses:30]; "used")  //thise are used for shiptos

QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Billto:22; $aAddressIDs)
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
//active billtos
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Billto:22; $aAddressIDs)
//find those address records
QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aAddressIDs)
CREATE SET:C116([Addresses:30]; "usedBillTo")  //these are used for billtos

UNION:C120("used"; "usedBillTo"; "used")
USE SET:C118("used")  //combined billtos and shiptos
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Active:12:=True:C214)

//separate the wheat from the chaff
DIFFERENCE:C122("all"; "used"; "notUsed")

USE SET:C118("notUsed")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Active:12:=False:C215)

//remove any [Customers_Addresses] that point to inactive addresses
RELATE ONE SELECTION:C349([Customers_Addresses:31]; [Addresses:30])
APPLY TO SELECTION:C70([Customers_Addresses:31]; [Customers_Addresses:31]Label_ID:4:=-1)


