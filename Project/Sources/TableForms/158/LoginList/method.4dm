// _______
// Method: [Customer_Portal_Extracts].LoginList   ( ) ->


C_COLLECTION:C1488(coCustomers; coSelCustomers)
C_OBJECT:C1216(esLogins; esSelLogins; enLogin; oCustomer; esUsers; esSelUsers; enUser)
Case of 
	: (Form event code:C388=On Load:K2:1)
		READ WRITE:C146([Customer_Portal_Extracts:158])
		esLogins:=ds:C1482.Customer_Portal_Extracts.query("CustId = :1"; "")  //ignore the legacy records
		
End case 
OBJECT SET ENABLED:C1123(*; "SelLogin@"; (enLogin#Null:C1517))

