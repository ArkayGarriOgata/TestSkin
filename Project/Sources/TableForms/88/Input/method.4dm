// ----------------------------------------------------
// Form Method: [Customers_Invoices].Input
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------
// Modified by: MelvinBohince (5/12/22) add INV_openActualsPage
// Modified by: MelvinBohince (5/18/22) don't do CoGS calc until requested by going to next page

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		If (Not:C34(User_AllowedCustomer([Customers_Invoices:88]CustomerID:6; ""; "via INV:"+String:C10([Customers_Invoices:88]InvoiceNumber:1))))
			bDone:=1
			CANCEL:C270
		End if 
		
		If (showCoGScalc)  // Modified by: MelvinBohince (5/18/22) don't do CoGS calc until requested by going to next page
			INV_openActualsPage
		End if 
		
		If (User in group:C338(Current user:C182; "AccountsReceivable"))
			SetObjectProperties("private@"; -><>NULL; True:C214)
		Else 
			SetObjectProperties("private@"; -><>NULL; False:C215)
		End if 
		
		If ([Customers_Invoices:88]CoGS_FiFo:38=0)
			SetObjectProperties(""; ->[Customers_Invoices:88]CoGS_FiFo:38; True:C214; ""; True:C214; Black:K11:16; Yellow:K11:2)
			OBJECT SET BORDER STYLE:C1262([Customers_Invoices:88]CoGS_FiFo:38; Border Sunken:K42:31)
			Core_ObjectSetColor(->[Customers_Invoices:88]CoGS_FiFo:38; -(Red:K11:4+(256*White:K11:1)))
		Else 
			SetObjectProperties(""; ->[Customers_Invoices:88]CoGS_FiFo:38; True:C214; ""; False:C215)
			OBJECT SET BORDER STYLE:C1262([Customers_Invoices:88]CoGS_FiFo:38; Border None:K42:27)
			Core_ObjectSetColor(->[Customers_Invoices:88]CoGS_FiFo:38; -(Black:K11:16+(256*White:K11:1)))
		End if 
		
		t1:=fGetAddressText([Customers_Invoices:88]BillTo:10)
		// Modified by: Mel Bohince (7/15/21) add OA's account id
		t1:=t1+"\r\rOpenAcct's ID: "+Invoice_CustomerMapping([Customers_Invoices:88]BillTo:10)
		t2:=fGetAddressText([Customers_Invoices:88]ShipTo:9)
		dDate:=Invoice_GetDateDue([Customers_Invoices:88]Terms:18; [Customers_Invoices:88]Invoice_Date:7)
		sCustName:=CUST_getName([Customers_Invoices:88]CustomerID:6)
		
		If (iMode=2)
			ARRAY TEXT:C222(aInvoStatus; 0)
			LIST TO ARRAY:C288("InvoiceStatus"; aInvoStatus)
			ARRAY TEXT:C222(aInvoTerms; 0)
			LIST TO ARRAY:C288("Terms"; aInvoTerms)
		Else 
			ARRAY TEXT:C222(aInvoStatus; 1)
			aInvoStatus{1}:=[Customers_Invoices:88]Status:22
			ARRAY TEXT:C222(aInvoTerms; 1)
			aInvoTerms{1}:=[Customers_Invoices:88]Terms:18
			OBJECT SET ENABLED:C1123(bValidate; False:C215)
		End if 
		
		util_ComboBoxSetup(->aInvoStatus; [Customers_Invoices:88]Status:22)
		util_ComboBoxSetup(->aInvoTerms; [Customers_Invoices:88]Terms:18)
End case 