//(LP)[CustomerOrder]'OrderAcknMissin:
Case of 
	: (Form event code:C388=On Load:K2:1)
		RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
End case 
//EOP