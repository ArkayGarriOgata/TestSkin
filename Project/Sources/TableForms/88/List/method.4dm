// _______
// Method: [Customers_Invoices].List   ( ) ->
// By: MelvinBohince @ 060399
//•060399  mlb  UPR 236 change sort and use pass thru
// Modified by: MelvinBohince (3/14/22) add on-rigft-click to Excel

app_basic_list_form_method
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Addresses:30]ID:1#[Customers_Invoices:88]BillTo:10)  //•060399  mlb  
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Invoices:88]BillTo:10)
		End if 
		C_TEXT:C284($state)
		$state:=[Customers_Invoices:88]Status:22
		Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(12+(256*12)); True:C214)
		Case of 
			: ($state="Approved")  //green text
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(9+(256*12)); True:C214)
			: ($state="Pending")  //red text 
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(3+(256*12)); True:C214)
			: ($state="Hold")  //white on red text 
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(0+(256*3)); True:C214)
			: ($state="Paid")  //light blue
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(7+(256*12)); True:C214)
			: ($state="Posted")  // grey
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(10+(256*12)); True:C214)
			Else 
				Core_ObjectSetColor(->[Customers_Invoices:88]Status:22; -(15+(256*12)); True:C214)
		End case 
		
		If ([Customers_Invoices:88]ExtendedPrice:19>0)
			Core_ObjectSetColor(->[Customers_Invoices:88]ExtendedPrice:19; -(15+(256*12)); True:C214)
		Else 
			Core_ObjectSetColor(->[Customers_Invoices:88]ExtendedPrice:19; -(3+(256*12)); True:C214)
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		
	: (Form event code:C388=On Clicked:K2:4)  // Modified by: MelvinBohince (3/14/22) add on-rigft-click to Excel
		C_LONGINT:C283($mouseButton)
		C_REAL:C285($mouseX; $mouseY)
		GET MOUSE:C468($mouseX; $mouseY; $mouseButton)
		
		If ($mouseButton=2)  //2 = Right button down
			INV_RightClickToExcel
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		b1:=0
		b2:=1  //•060399  mlb  UPR 236 change sort anduse pass thru
		cb1:=1
		dDateBegin:=!00-00-00!
		Case of 
			: (sCriterion1="Pending")
				lastTab:=2
			: (sCriterion1="Approved")
				lastTab:=3
			: (sCriterion1="Posted")
				lastTab:=4
			: (sCriterion1="Paid")
				lastTab:=5
			: (sCriterion1="Hold")
				lastTab:=6
			Else 
				lastTab:=1  //the find tab
		End case 
		SELECT LIST ITEMS BY POSITION:C381(iInvoiceTabs; lastTab)
		
		FORM GOTO PAGE:C247(1)
		
		
End case 
//
