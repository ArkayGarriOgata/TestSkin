//%attributes = {"publishedWeb":true}
//gCCAddrDel: [CUSTAddressLink] deletion
//10/12/94  upr 1241

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=[Customers_Addresses:31]CustAddrID:2; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Billto:22=[Customers_Addresses:31]CustAddrID:2; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=[Customers_Addresses:31]CustID:1)
If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	BEEP:C151
	ALERT:C41("There are Releases that reference this address id, please assign a new address to"+" them.")
End if 

gDeleteRecord(->[Customers_Addresses:31])
CLEAR NAMED SELECTION:C333("beforeDelete")
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
CUT NAMED SELECTION:C334([Customers_Addresses:31]; "beforeDelete")