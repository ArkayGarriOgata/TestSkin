//%attributes = {"publishedWeb":true}
//gVendContDel: [VENDCONTLINK] deletion

gDeleteRecord(->[Vendors_Contacts:53])
//RELATE MANY([VENDOR]ID)
QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)