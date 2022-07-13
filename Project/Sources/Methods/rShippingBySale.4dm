//%attributes = {"publishedWeb":true}
//(p) rShippingBySales
//•070196  MLB  fix range check error, when rep has no customers
//printed from Month End Suite
// Modified by: Mel Bohince (12/6/17) email to Debra

C_TEXT:C284(sCustoemr; sSalesman; sBy; $distributionList; $1; $docPath)
C_LONGINT:C283($PageRecs; $CurRec; $CurCust; lPage)
C_BOOLEAN:C305($fExit)

If (Count parameters:C259=1)  // Modified by: Mel Bohince (12/6/17) 
	$distributionList:=$1
End if 

gClearShipRpt  //clear report values
lPage:=1
$PageRecs:=36
$CurRec:=1
$CurCust:=1
$fExit:=False:C215

$YearBegin:=FiscalYear("start"; dDateBegin)  //[x_fiscal_calendars]StartDate
sBy:="Sorted by Salesperson"
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
CREATE SET:C116([Finished_Goods_Transactions:33]; "ToPrint")  //records i n date range to print from

//ALL RECORDS([Salesmen])
QUERY:C277([Salesmen:32]; [Salesmen:32]Active:12=True:C214)
SELECTION TO ARRAY:C260([Salesmen:32]ID:1; $aSales)  //build array of sales people
SORT ARRAY:C229($aSales; >)
$SalesMan:=1  //current sales person
QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=$aSales{$SalesMan})  //get all customers for this sales person
ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
SELECTION TO ARRAY:C260([Customers:16]ID:1; $aDistinct)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	USE SET:C118("ToPrint")
	If (Size of array:C274($aDistinct)>0)  //•070196  MLB fix range check error
		
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})
	Else 
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	End if 
	
Else 
	
	If (Size of array:C274($aDistinct)>0)  //•070196  MLB fix range check error
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$YearBegin; *)  //get transactions for the current year
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})
	Else 
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection

CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
CREATE SET:C116([Finished_Goods_Transactions:33]; "Returns")
DIFFERENCE:C122("Printing"; "Returns"; "Printing")  //remove returns from this customers shipped
util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "rShipping.h")
MESSAGES OFF:C175
$docPath:=PDF_setUp(<>pdfFileName)

$winRef:=NewWindow(350; 30; 6; 1; "")
MESSAGE:C88("Printing Report…"+String:C10($Salesman))

While (Not:C34($fExit))
	If (Size of array:C274($aDistinct)>0)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aDistinct{$CurCust})
		sCustomer:=[Customers:16]Name:2
		sSalesId:=[Customers:16]SalesmanID:3
		RELATE ONE:C42([Customers:16]SalesmanID:3)
		sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
	Else 
		sCustomer:="Customer Not Found"
		sSalesId:=$aSales{$Salesman}
	End if 
	gCalcShipRptVal("*")  //calcs all values for detail for the customer at $CurCust in $aDistinct
	
	Case of 
		: ($CurRec=1) & (lPage=1)  //this is first record on first page
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=$CurRec+1
		: ($CurRec<=$PageRecs)  //printing normal detail
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=$CurRec+1
		Else   //printed as many as possible
			PAGE BREAK:C6(>)  //print page (as one job)
			lPage:=lPage+1
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
			Print form:C5([Finished_Goods_Transactions:33]; "rShipping.d")  //print detail
			$CurRec:=1
	End case 
	
	DIFFERENCE:C122("ToPrint"; "Printing"; "ToPrint")
	$CurCust:=$CurCust+1
	
	If ($CurCust>Size of array:C274($aDistinct))  //need to setup new sales person 
		$SalesMan:=$SalesMan+1
		
		MESSAGE:C88(<>sCr+"Printing Report…"+String:C10($Salesman))
		If ($SalesMan>Size of array:C274($aSales))
			$fExit:=True:C214
		Else   //next salesman, print total line for sales person
			Case of 
				: ($CurRec=1)  //this is first record on page  
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
					gClearShipSub
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$aSales{$Salesman})
					sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					$CurRec:=$CurRec+4
				: ($CurRec+4<=$PageRecs)  //printing salesmans footer
					Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
					gClearShipSub
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$aSales{$Salesman})
					sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					$CurRec:=$CurRec+4
				: ($CurRec+1<=$PageRecs)  //enought for footer
					Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
					gClearShipSub
					PAGE BREAK:C6(>)  //print page (as one job)
					lPage:=lPage+1
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
					QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$aSales{$Salesman})
					sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					$CurRec:=0  //NO details printed at this time
				Else   //won't fit all fit 
					PAGE BREAK:C6(>)  //print page (as one job)
					lPage:=lPage+1
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
					gClearShipSub
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
					QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$aSales{$Salesman})
					sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
					Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
					$CurRec:=4
			End case 
			QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=$aSales{$SalesMan})  //get all customers for this sales person
			ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
			SELECTION TO ARRAY:C260([Customers:16]ID:1; $aDistinct)
			$CurCust:=1
			USE SET:C118("ToPrint")
			If (Size of array:C274($aDistinct)>0)
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})
					CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
					CREATE SET:C116([Finished_Goods_Transactions:33]; "Returns")
					DIFFERENCE:C122("Printing"; "Returns"; "Printing")  //remove returns from this customers shippe
					
					
				Else 
					
					SET QUERY DESTINATION:C396(Into set:K19:2; "Returns")
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust}; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					USE SET:C118("ToPrint")
					SET QUERY DESTINATION:C396(Into set:K19:2; "Printing")
					QUERY SELECTION BY FORMULA:C207([Finished_Goods_Transactions:33]; \
						([Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})\
						#(\
						([Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})\
						 & ([Finished_Goods_Transactions:33]XactionType:2#"Ship")\
						)\
						)
					
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					
					
				End if   // END 4D Professional Services : January 2019 
			Else 
				CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "Returns")
				CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "Printing")
			End if 
		End if 
	Else 
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			USE SET:C118("ToPrint")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Printing")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Returns")
			DIFFERENCE:C122("Printing"; "Returns"; "Printing")  //remove returns from this customers shipped
			
			
		Else 
			USE SET:C118("ToPrint")
			SET QUERY DESTINATION:C396(Into set:K19:2; "Printing")
			QUERY SELECTION BY FORMULA:C207([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]CustID:12=$aDistinct{$CurCust})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Ship")\
				)
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
	End if 
End while 

If ($CurRec+3<=($PageRecs-1))  //if there is enough room for footer 
	Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
	gClearShipSub
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"  
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.f")  //print footer
Else   //not enough room
	PAGE BREAK:C6(>)
	lPage:=lPage+1
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H")  //print header
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.H2")  //print salesmans name
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"
	Print form:C5([Finished_Goods_Transactions:33]; "rShipping.s")  //print spacer"  
	Print form:C5([Finished_Goods_Transactions:33]; "ShippedBySale.1")  //print footer for this sales person
	gClearShipSub
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

If (Count parameters:C259=1)
	EMAIL_Sender("Analysis of Shipped Sales by Salesrep "+fYYMMDD(Current date:C33); ""; "Advance copy attached"; $distributionList; $docPath)
End if 
