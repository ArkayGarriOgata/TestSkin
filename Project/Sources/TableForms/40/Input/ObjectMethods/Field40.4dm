READ ONLY:C145([Contacts:51])
$hit:=Position:C15(" "; [Customers_Orders:40]Contact_Agent:36)
If ($hit>0)
	$firstname:=Substring:C12([Customers_Orders:40]Contact_Agent:36; 1; ($hit-1))
	$lastname:=Substring:C12([Customers_Orders:40]Contact_Agent:36; ($hit+1))
Else 
	$firstname:="@"
	$lastname:=[Customers_Orders:40]Contact_Agent:36
End if 
QUERY:C277([Contacts:51]; [Contacts:51]FirstName:27=$firstname; *)
QUERY:C277([Contacts:51];  & ; [Contacts:51]LastName:26=$lastname)

If (Records in selection:C76([Contacts:51])=1)
	[Customers_Orders:40]EmailTo:38:=[Contacts:51]EmailAddress:14
	util_ComboBoxSetup(->aEmailAddress; [Customers_Orders:40]EmailTo:38)
End if 
REDUCE SELECTION:C351([Contacts:51]; 0)