//vAddContac1  script Customer Order layout. -JML     9/13/93

//C_TEXT($Contact)
//$Contact:=gContactSelect ("Purchasing Agent";[CustomerOrder]CustID)
//If ($Contact # "")
//` [CustomerOrder]Contact_Agent:=$contact
//End if 
READ ONLY:C145([Contacts:51])
$recNo:=fPickList(->[Contacts:51]LastName:26; ->[Contacts:51]Company:3; ->[Contacts:51]FirstName:27; ("@"+Substring:C12([Customers_Orders:40]CustomerName:39; 1; 5)+"@"))  //get all for the intended commodity

If ($recNo#-1)
	GOTO RECORD:C242([Contacts:51]; $recNo)
	[Customers_Orders:40]Contact_Agent:36:=Substring:C12(([Contacts:51]FirstName:27+" "+[Contacts:51]LastName:26+" "+[Contacts:51]Phone:10); 1; 50)
	[Customers_Orders:40]EmailTo:38:=[Contacts:51]EmailAddress:14
End if 
REDUCE SELECTION:C351([Contacts:51]; 0)