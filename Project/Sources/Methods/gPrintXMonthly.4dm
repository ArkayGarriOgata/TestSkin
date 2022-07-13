//%attributes = {"publishedWeb":true}
//(p) gPrintXMonthly
//$1 Number of Months to print at current 9, 12, or 15
//$2 (optional) use the search editor, [called from popup menu]
//1/11/94 upr 1329
//2/23/95 
//on site 3/16/95 chip
//upr 1455 add a summary report 3/23/95 chip
//•080195  MLB  UPR 1490 changed search to search selection
//•081795  MLB  hk request
//•101695  MLB  UPR 1763
//•101695  MLB  UPR 1754 inject sort by brand
//•022097  MLB  close search
//•100798  mlb  

If (False:C215)  //this report should not be used, current folks don't understand it100798  mlb
	C_REAL:C285(tOpen; tOpenTot; tCustStock; tCustTot; tStock; tStockTot; tExcess; tExcessTot)
	C_REAL:C285(tOpenDol; tOpenDolT; tCustDol; tCustDolT; tStockDol; tStockDolT; tExcessDol; tExcessDolT)
	C_LONGINT:C283($1)
	C_TEXT:C284($2)  //•081795  MLB  hk request
	t2:=$2  //•081795  MLB  hk request
	C_TEXT:C284($3)  //if present, then via popup, not MES
	C_BOOLEAN:C305($fContinue)
	C_TEXT:C284(tCust)
	
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Customers_Order_Lines:41])
	
	qryOpenOrdLines("*")  //•022097  MLB  close search
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*($1/12))))  //•081795  MLB  hk request
	
	Case of 
		: (True:C214)
			//•081795  MLB  hk request    
		: ($1=9)  //1/11/94 upr 1329    
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*0.75)))  //  `1/11/94 upr 1329
			t2:="INVENTORY 9 MO & UP"  //1/11/94 upr 1329
			
		: ($1=12)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-365))
			t2:="INVENTORY 12 MO & UP"
			
		: ($1=15)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365+(365/4))))
			t2:="INVENTORY 15 MO & UP"
			
		Else 
			BEEP:C151
			ALERT:C41("Problem in gPrintXMonthly, call Chip, Mel or Jim.")
	End case 
	
	
	If (Count parameters:C259=3)
		QUERY SELECTION:C341([Customers_Order_Lines:41])
		util_PAGE_SETUP(->[Customers_Order_Lines:41]; "InventoryReport")
		PRINT SETTINGS:C106
		Case of 
			: (Records in selection:C76([Customers_Order_Lines:41])>0) & (OK=1)
				$fContinue:=True:C214
				If (uNowOrDelay(t2))  //•101695  MLB  UPR 1763
					$fContinue:=True:C214
				Else 
					$fContinue:=False:C215
				End if 
				
			: (Records in selection:C76([Customers_Order_Lines:41])=0)
				BEEP:C151
				ALERT:C41("No Records Found Matching Your Search Criteria Found.")
				$fContinue:=False:C215
			Else   //OK=0
				$fContinue:=False:C215
		End case 
	Else 
		$fContinue:=True:C214
		util_PAGE_SETUP(->[Customers_Order_Lines:41]; "InventoryReport")
	End if 
	
	If ($fContinue)
		liValues:=1
		liCust:=1
		ARRAY REAL:C219(aTotals; 8; liValues)  //reference is doubled since I need to keep count & Dol totals
		//dimension 1 & 2 are for open items, 3 &4 are for in stock, 5 & 6 are for excess
		ARRAY TEXT:C222(aCustomer; liCust)
		
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24; >; [Customers_Order_Lines:41]CustomerLine:42; >; [Customers_Order_Lines:41]ProductCode:5; >)  //`•101695  MLB  UPR 1754 brand was cpn sort
		MESSAGES OFF:C175
		ACCUMULATE:C303([Customers_Order_Lines:41]zCount:18; tStock; tExcess; tStockDol; tExcessDol; tOpen; tOpenDol; tcustStock; tCustDol)  //on site 3/16/95 chip
		BREAK LEVEL:C302(1; 1)
		FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "InventoryReport")
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
		//upr 1455 add a summary report 3/23/95
		FIRST RECORD:C50([Customers_Order_Lines:41])  //print summary of customer totals
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; Size of array:C274(aCustomer))
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)  //any 
		FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "xMonthSummary")
		PDF_setUp(<>pdfFileName+"SUM.pdf")
		PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
		
		FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")
		MESSAGES ON:C181
	End if 
	
Else 
	BEEP:C151
	BEEP:C151
	BEEP:C151
	
End if 