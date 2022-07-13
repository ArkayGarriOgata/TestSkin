//%attributes = {"publishedWeb":true}
//Method: Invoice_setView()  042199  MLB
//called by tab control on output list
//tabs: Pending,Approved,Posted,Paid,Hold
C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)
C_TEXT:C284($2; $plant)
C_POINTER:C301($3; $orderBy)
CUT NAMED SELECTION:C334([Customers_Invoices:88]; "hold")

If (Count parameters:C259=3)
	$tabNumber:=$1
	$plant:=$2
	$orderBy:=$3
Else 
	$tabNumber:=Selected list items:C379(iInvoiceTabs)
	Case of 
		: (cb1=1)
			dDateBegin:=!00-00-00!
		: (cb2=1)
			dDateBegin:=4D_Current_date-31
	End case 
	
	Case of 
		: (b1=1)
			$orderBy:=->[Customers_Invoices:88]InvoiceNumber:1
		: (b2=1)
			$orderBy:=->[Customers_Invoices:88]BillTo:10
	End case 
	
End if 
//TRACE
GET LIST ITEM:C378(iInvoiceTabs; $tabNumber; $itemRef; $itemText)
Case of 
	: ($itemText="Todays")
		QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7=4D_Current_date)
	: ($itemText="Yesterdays")
		QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7=(4D_Current_date-1))
	: ($itemText="Find")
		QUERY:C277([Customers_Invoices:88])
	Else 
		QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Status:22=($itemText+"@"); *)
		QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>dDateBegin)
End case 

If (Records in selection:C76([Customers_Invoices:88])>0)
	ORDER BY:C49([Customers_Invoices:88]; $orderBy->; >)
	lastTab:=$tabNumber
Else 
	BEEP:C151
	//USE NAMED SELECTION("hold")
	//SELECT LIST ITEM(iInvoiceTabs;lastTab)
	//REDRAW LIST(iInvoiceTabs)
End if 

CREATE SET:C116([Customers_Invoices:88]; "◊LastSelection"+String:C10(Table:C252(->[Customers_Invoices:88])))
SET WINDOW TITLE:C213(fNameWindow(->[Customers_Invoices:88]))

//