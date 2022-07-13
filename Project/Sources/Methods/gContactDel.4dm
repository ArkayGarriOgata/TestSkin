//%attributes = {"publishedWeb":true}
//gContactDel:

RELATE MANY:C262([Contacts:51]ContactID:1)

If (gDeleteRecord(->[Contacts:51]))
	DELETE SELECTION:C66([Customers_Contacts:52])
	DELETE SELECTION:C66([Vendors_Contacts:53])
End if 