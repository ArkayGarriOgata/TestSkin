//%attributes = {"publishedWeb":true}
//(p) rShippingByCust
//reoprt for customer sales analysis 
//printed from Month End Suite

C_TEXT:C284(sCustoemr; sSalesman; sBy)
C_LONGINT:C283($PageRecs; $CurRec; $CurCust; lPage)
C_BOOLEAN:C305($fExit)

gClearShipRpt  //clear report values
lPage:=1
$PageRecs:=38
$CurRec:=1
$CurCust:=1
$YearBegin:=FiscalYear("start"; dDateBegin)  //[x_fiscal_calendars]StartDate
sBy:="Sorted by Customer"  //used in heder of report to indicate printing sort
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip")
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$YearBegin; *)  //get transactions for the current year
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
	
	
Else 
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$YearBegin; *)  //get transactions for the current year
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
	
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Finished_Goods_Transactions:33]; "ToPrint")  //records i ndate range to print from
ARRAY TEXT:C222($aDistinct; 0)
If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
	
	DISTINCT VALUES:C339([Finished_Goods_Transactions:33]CustID:12; $aDistinct)  // seperate out all seperate customers
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CREATE EMPTY SET:C140([Customers:16]; "FoundCust")
		For ($i; 1; Size of array:C274($aDistinct))  //sort customers by name, get all customers in one search
			QUERY:C277([Customers:16]; [Customers:16]ID:1=$aDistinct{$i})
			ADD TO SET:C119([Customers:16]; "FoundCust")
		End for 
		USE SET:C118("FoundCust")
		CLEAR SET:C117("FoundCust")
		
	Else 
		
		QUERY WITH ARRAY:C644([Customers:16]ID:1; $aDistinct)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
Else 
	
	RELATE ONE SELECTION:C349([Finished_Goods_Transactions:33]; [Customers:16])
	
	
	
	
End if   // END 4D Professional Services : January 2019 

ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)  //sort them by name
SELECTION TO ARRAY:C260([Customers:16]ID:1; $aDistinct)  //transfer their Id's back to array in order

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	USE SET:C118("ToPrint")
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})  //find the first customer's fg_trans record
	
	
Else 
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$YearBegin; *)  //get transactions for the current year
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})  //find the first customer's fg_trans record
	
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
CREATE SET:C116([Finished_Goods_Transactions:33]; "Returns")
DIFFERENCE:C122("Printing"; "Returns"; "Printing")  //remove returns from this customers shipped
$fExit:=False:C215
util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "rShipping.h")
MESSAGES OFF:C175
PDF_setUp(<>pdfFileName)

$winRef:=NewWindow(350; 30; 6; 1; "")
MESSAGE:C88("Printing Report…"+String:C10($CurCust))

While (Not:C34($fExit))
	If (Size of array:C274($aDistinct)>0)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aDistinct{$CurCust})
		sCustomer:=[Customers:16]Name:2
		sSalesId:=[Customers:16]SalesmanID:3
	Else 
		sCustomer:="Unknown Customer"
		sSalesId:="??"
	End if 
	gCalcShipRptVal  //calcs all values for detail for the customer at $CurCust in $aDistinct
	
	Case of 
		: ($CurRec=1) & (lPage=1)  //this is first record on page1
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=$CurRec+1
		: ($CurRec<=$PageRecs)  //printing normal detail
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=$CurRec+1
		Else   //printed as many as possible
			PAGE BREAK:C6(>)  //print page (as one job)
			lPage:=lPage+1
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=1
	End case 
	
	DIFFERENCE:C122("ToPrint"; "Printing"; "ToPrint")  //remove the fg_Trans records just printed
	DIFFERENCE:C122("ToPrint"; "Returns"; "ToPrint")  //remove returns too
	$CurCust:=$CurCust+1  //go to next customer
	MESSAGE:C88(<>sCr+"Printing Report…"+String:C10($CurCust))
	If ($CurCust>Size of array:C274($aDistinct))  //processed all customers
		$fExit:=True:C214
	Else   //get records for next customer
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			USE SET:C118("ToPrint")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Returns")
			DIFFERENCE:C122("Printing"; "Returns"; "Printing")  //remove returns from this customers shipped
			
			
		Else 
			
			USE SET:C118("ToPrint")
			QUERY SELECTION BY FORMULA:C207([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Ship")\
				)
			
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
			
		End if   // END 4D Professional Services : January 2019 query selection
	End if 
End while 

If ($CurRec<=($PageRecs-1))  //if there is enough room for footer 
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.f")  //print footer
Else   //not enough room
	PAGE BREAK:C6(>)
	lPage:=lPage+1
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.f")  //print footer
End if 
PAGE BREAK:C6
CLEAR SET:C117("Printing")
CLEAR SET:C117("ToPrint")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	CLEAR SET:C117("Returns")
Else 
End if 
MESSAGES ON:C181
CLOSE WINDOW:C154($winRef)