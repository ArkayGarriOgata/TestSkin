//(s) [chngordhistory]output'NeedDate
// track changes to need date - assign change to var dDate
//  initialized on start of CCO to Cust Order Need date
//• 7/24/97 cs created
Case of 
	: (Form event code:C388=On Data Change:K2:15)
		If (Not:C34([Customers_Order_Changed_Items:176]SpecialBilling:38))  //do not do this if the item is speciall billing
			If (Self:C308-><dDate1) | (dDate1=!00-00-00!)  // if the entered date is nearer than Order Need Date, or order needdate is empty
				dDate1:=Self:C308->
			End if 
		End if 
End case 



//