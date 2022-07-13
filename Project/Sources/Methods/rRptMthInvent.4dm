//%attributes = {"publishedWeb":true}
//rRptMthInvent      report on all fg's with either qty or open orders 

//3/3/95 made into a proc

//called from rRptMthEndSuite and doFGrptRecords

//•053095  MLB  UPR 1622

C_TEXT:C284($1)  //parameter suppresses interaction dialogs

C_TEXT:C284($oneCust)
C_REAL:C285(tOpenRel; tWIP; tOrdStk; tExcess; tWithOR; tNetShipped; tOpenOR)
C_LONGINT:C283($exclude; $search)
C_REAL:C285(tStock; tStock2; tStockBH; tStock2Ex; tStockEx)  //added for upr 02/23/95

C_REAL:C285(tStockt; tStockBHt; tStockEXt)
READ ONLY:C145([Customers_Order_Lines:41])

If (Count parameters:C259=1)
	$exclude:=0
	$search:=0
	$oneCust:="00000"
Else 
	BEEP:C151
	C_DATE:C307(dDateEnd)
	dDateEnd:=Current date:C33  //•080195  MLB  UPR 1490
	
	$exclude:=uConfirm("Exclude order lines that have a 'Notified Of Expiration' date on them?"; "Exclude"; "Include")
	$search:=uConfirm("This report includes all F/G's with stock or open orders."+Char:C90(13)+"Do you wish to search within this selection?"; "Search"; "As-is")
	$oneCust:=Substring:C12(Request:C163("If this is for one customer, enter the customer id:"; "00000"); 1; 5)  //•053095  MLB  UPR 1622
	
End if 

If ($oneCust="00000")  //•053095  MLB  UPR 1622
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0)
Else 
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=$oneCust)
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
	CREATE SET:C116([Finished_Goods:26]; "WithQty")
	
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
	RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
	zwStatusMsg(""; "")
	
	
End if   // END 4D Professional Services : January 2019 query selection
MESSAGE:C88(Char:C90(13))
MESSAGE:C88(Char:C90(13)+"  "+String:C10(Records in set:C195("WithQty"))+" F/G's with quantity in stock.")

qryOpenOrdLines  //•080195  MLB  UPR 1490

CREATE SET:C116([Customers_Order_Lines:41]; "OpenOrders")


//upr 1439 2/22/95

If ($exclude=1)
	//qryOpenOrdLines ("*")
	
	USE SET:C118("OpenOrders")
	If ($oneCust#"00000")  //•053095  MLB  UPR 1622
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$oneCust; *)  //•080195  MLB  UPR 1490
		
	End if 
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]_NotifiedOfExpir:39=!00-00-00!)  //•080195  MLB  UPR 1490
	
Else 
	//qryOpenOrdLines 
	
	USE SET:C118("OpenOrders")
	If ($oneCust#"00000")  //•053095  MLB  UPR 1622
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$oneCust)
	End if 
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 1)
	CREATE SET:C116([Finished_Goods:26]; "WithOpens")
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
	RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Finished_Goods:26])
	CREATE SET:C116([Finished_Goods:26]; "WithOpens")
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection

MESSAGE:C88(Char:C90(13)+"  "+String:C10(Records in set:C195("WithOpens"))+" F/G's with open orders.")
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	UNION:C120("WithQty"; "WithOpens"; "Both")
	USE SET:C118("Both")
	
	MESSAGE:C88(Char:C90(13)+Char:C90(13)+"  "+String:C10(Records in set:C195("Both"))+" F/G's can be reported.")
	CLEAR SET:C117("Both")
	CLEAR SET:C117("WithOpens")
	CLEAR SET:C117("WithQty")
	
Else 
	
	UNION:C120("WithQty"; "WithOpens"; "WithOpens")
	USE SET:C118("WithOpens")
	
	MESSAGE:C88(Char:C90(13)+Char:C90(13)+"  "+String:C10(Records in set:C195("WithOpens"))+" F/G's can be reported.")
	CLEAR SET:C117("WithOpens")
	CLEAR SET:C117("WithQty")
	
End if   // END 4D Professional Services : January 2019 query selection


If ($search=1)
	BEEP:C151
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Finished_Goods:26])
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	$searched:=" (plus user specified search in selection)"
Else 
	$searched:=""
End if 

If ($oneCust#"00000")  //•053095  MLB  UPR 1622
	
	$searched:=$searched+" Cust ID = "+$oneCust
End if 

MESSAGE:C88(Char:C90(13)+Char:C90(13)+"  "+String:C10(Records in selection:C76([Finished_Goods:26]))+" F/G's will be reported.")
ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
<>fContinue:=True:C214
ON EVENT CALL:C190("eCancelPrint")

MESSAGES OFF:C175
If (Records in selection:C76([Finished_Goods:26])>0)  //upr 1432 chip 02/15/95
	
	BREAK LEVEL:C302(1; 1)
	ACCUMULATE:C303([Finished_Goods:26]zCount:30; tStock; tStockBH; tStockEx)  //`added for upr 02/23/95
	
	util_PAGE_SETUP(->[Finished_Goods:26]; "InventoryReport")
	FORM SET OUTPUT:C54([Finished_Goods:26]; "InventoryReport")
	t2:="INVENTORY MONTHLY"
	t2b:="All CPN's With Either Qty On-hand or Open Orders"+$searched
	t3:="Sorted by Customer & CPN"
	If (Count parameters:C259=0)  //•053095  MLB  UPR 1622
		
		//uReportProcess 
		
		uNowOrDelay
	End if 
	PDF_setUp(<>pdfFileName)
	PRINT SELECTION:C60([Finished_Goods:26]; *)
Else 
	If (Count parameters:C259=0)
		ALERT:C41("There were NO Records Matching Your Criteria, Found to Print.")
	End if 
End if 
FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
MESSAGES ON:C181
ON EVENT CALL:C190("")
CLEAR SET:C117("OpenOrders")
CLEAR SET:C117("OneCustOpenOrders")
//