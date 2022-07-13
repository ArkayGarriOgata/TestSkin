//%attributes = {"publishedWeb":true}
//PM: ORD_distributionSummary() -> 
//@author mlb - 11/2/01  09:06

C_TIME:C306($docRef)
C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numFGX)
C_TEXT:C284($3)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:=""
xText:=""

READ ONLY:C145([Finished_Goods_Specifications:98])
READ ONLY:C145([Prep_Charges:103])
READ ONLY:C145([Customers_Orders:40])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers:16])

//get a range of fg transactions
zwStatusMsg("PREP SUM"; "Order Distribution Summary")
MESSAGES OFF:C175
//*Find the transactions to report
REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd)
		If (Count parameters:C259=3)
			QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=($3+"@"))
		End if 
		
	Else 
		
		
		If (Count parameters:C259=3)
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=($3+"@"); *)
		End if 
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	OK:=1
	$numFGX:=Records in selection:C76([Finished_Goods_Specifications:98])
Else 
	$numFGX:=qryByDateRange(->[Finished_Goods_Specifications:98]DatePrepDone:6; "Date Range of FG Transactions")
	If ($numFGX>-1)
		OK:=1
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]DateOpened:6>=dDateBegin; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateOpened:6<=dDateEnd)
		
	Else 
		OK:=0
	End if 
End if   //params

If (OK=1)
	xTitle:="Prep Billing Summary by Customer for the period "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	//first get the bookings and billings  and begin to construct a spreadsheet
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5="Prep@")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4; >; [Customers_Order_Lines:41]OrderNumber:1; >)
		FIRST RECORD:C50([Customers_Order_Lines:41])
		
		
	Else 
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4; >; [Customers_Order_Lines:41]OrderNumber:1; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	$currentCust:=""
	$currentOrder:=0
	$numOL:=Records in selection:C76([Customers_Order_Lines:41])
	ARRAY TEXT:C222($aCust; $numOL)
	ARRAY LONGINT:C221($aOrder; $numOL)
	ARRAY REAL:C219($aBooked; $numOL)
	ARRAY REAL:C219($aInvoiced; $numOL)
	ARRAY REAL:C219($aQuoted; $numOL)
	ARRAY REAL:C219($aCost; $numOL)
	ARRAY REAL:C219($aNotBilled; $numOL)
	$ordCursor:=0
	uThermoInit($numOL; "Looking at orders")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; $numOL)
			If ($currentCust#[Customers_Order_Lines:41]CustID:4)  //set up an new element at customer break
				$ordCursor:=$ordCursor+1
				$currentCust:=[Customers_Order_Lines:41]CustID:4
				$aCust{$ordCursor}:=$currentCust
				$currentOrder:=[Customers_Order_Lines:41]OrderNumber:1
				$aOrder{$ordCursor}:=$currentOrder
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=0
				$aCost{$ordCursor}:=0
				$aNotBilled{$ordCursor}:=0
			End if 
			
			If ($currentOrder#[Customers_Order_Lines:41]OrderNumber:1)  //set up an new element at order break
				$ordCursor:=$ordCursor+1
				$aCust{$ordCursor}:=$currentCust
				$currentOrder:=[Customers_Order_Lines:41]OrderNumber:1
				$aOrder{$ordCursor}:=$currentOrder
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=0
				$aCost{$ordCursor}:=0
				$aNotBilled{$ordCursor}:=0
			End if 
			
			$aBooked{$ordCursor}:=$aBooked{$ordCursor}+([Customers_Order_Lines:41]Price_Per_M:8*[Customers_Order_Lines:41]Quantity:6)
			If ([Customers_Order_Lines:41]InvoiceNum:38#0)
				$aInvoiced{$ordCursor}:=$aInvoiced{$ordCursor}+([Customers_Order_Lines:41]Price_Per_M:8*[Customers_Order_Lines:41]Quantity:6)
			End if 
			
			NEXT RECORD:C51([Customers_Order_Lines:41])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY LONGINT:C221($_InvoiceNum; 0)
		ARRAY REAL:C219($_Price_Per_M; 0)
		ARRAY LONGINT:C221($_Quantity; 0)
		ARRAY LONGINT:C221($_OrderNumber; 0)
		ARRAY TEXT:C222($_CustID; 0)
		
		
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]InvoiceNum:38; $_InvoiceNum; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]OrderNumber:1; $_OrderNumber; [Customers_Order_Lines:41]CustID:4; $_CustID)
		
		For ($i; 1; $numOL; 1)
			If ($currentCust#$_CustID{$i})  //set up an new element at customer break
				$ordCursor:=$ordCursor+1
				$currentCust:=$_CustID{$i}
				$aCust{$ordCursor}:=$currentCust
				$currentOrder:=$_OrderNumber{$i}
				$aOrder{$ordCursor}:=$currentOrder
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=0
				$aCost{$ordCursor}:=0
				$aNotBilled{$ordCursor}:=0
			End if 
			
			If ($currentOrder#$_OrderNumber{$i})  //set up an new element at order break
				$ordCursor:=$ordCursor+1
				$aCust{$ordCursor}:=$currentCust
				$currentOrder:=$_OrderNumber{$i}
				$aOrder{$ordCursor}:=$currentOrder
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=0
				$aCost{$ordCursor}:=0
				$aNotBilled{$ordCursor}:=0
			End if 
			
			$aBooked{$ordCursor}:=$aBooked{$ordCursor}+($_Price_Per_M{$i}*$_Quantity{$i})
			If ($_InvoiceNum{$i}#0)
				$aInvoiced{$ordCursor}:=$aInvoiced{$ordCursor}+($_Price_Per_M{$i}*$_Quantity{$i})
			End if 
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	uThermoClose
	
	uThermoInit($ordCursor; "Getting orders' prep charges")
	For ($i; 1; $ordCursor)  //find the costs for the bookings
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=$aOrder{$i})
		If (Records in selection:C76([Prep_Charges:103])>0)
			$aQuoted{$i}:=Sum:C1([Prep_Charges:103]PriceQuoted:6)
			$aCost{$i}:=Sum:C1([Prep_Charges:103]PriceActual:5)
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	//find the unbookings in the same date range
	RELATE MANY SELECTION:C340([Prep_Charges:103]ControlNumber:1)
	QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=0)
	ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]Custid:9; >)
	uThermoInit(Records in selection:C76([Prep_Charges:103]); "Looking for unbilled prep charges.")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Prep_Charges:103]))
			$hit:=Find in array:C230($aCust; [Prep_Charges:103]Custid:9)
			If ($hit>-1)
				$aNotBilled{$hit}:=$aNotBilled{$hit}+[Prep_Charges:103]PriceActual:5
				$aQuoted{$hit}:=$aQuoted{$hit}+[Prep_Charges:103]PriceQuoted:6
				$aCost{$hit}:=$aCost{$hit}+[Prep_Charges:103]PriceActual:5
			Else 
				$ordCursor:=$ordCursor+1
				If (Size of array:C274($aCust)<$ordCursor)
					$hit:=$ordCursor+15
					ARRAY TEXT:C222($aCust; $hit)
					ARRAY LONGINT:C221($aOrder; $hit)
					ARRAY REAL:C219($aBooked; $hit)
					ARRAY REAL:C219($aInvoiced; $hit)
					ARRAY REAL:C219($aQuoted; $hit)
					ARRAY REAL:C219($aCost; $hit)
					ARRAY REAL:C219($aNotBilled; $hit)
				End if 
				
				$aCust{$ordCursor}:=[Prep_Charges:103]Custid:9
				$aOrder{$ordCursor}:=0
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=$aQuoted{$ordCursor}+[Prep_Charges:103]PriceQuoted:6
				$aCost{$ordCursor}:=$aCost{$ordCursor}+[Prep_Charges:103]PriceActual:5
				$aNotBilled{$ordCursor}:=[Prep_Charges:103]PriceActual:5
			End if 
			
			NEXT RECORD:C51([Prep_Charges:103])
			uThermoUpdate($i)
		End for 
		
	Else 
		
		ARRAY REAL:C219($_PriceActual; 0)
		ARRAY REAL:C219($_PriceQuoted; 0)
		ARRAY TEXT:C222($_Custid; 0)
		
		
		SELECTION TO ARRAY:C260([Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]Custid:9; $_Custid)
		
		For ($i; 1; Size of array:C274($_PriceActual); 1)
			$hit:=Find in array:C230($aCust; $_Custid{$i})
			If ($hit>-1)
				$aNotBilled{$hit}:=$aNotBilled{$hit}+$_PriceActual{$i}
				$aQuoted{$hit}:=$aQuoted{$hit}+$_PriceQuoted{$i}
				$aCost{$hit}:=$aCost{$hit}+$_PriceActual{$i}
			Else 
				$ordCursor:=$ordCursor+1
				If (Size of array:C274($aCust)<$ordCursor)
					$hit:=$ordCursor+15
					ARRAY TEXT:C222($aCust; $hit)
					ARRAY LONGINT:C221($aOrder; $hit)
					ARRAY REAL:C219($aBooked; $hit)
					ARRAY REAL:C219($aInvoiced; $hit)
					ARRAY REAL:C219($aQuoted; $hit)
					ARRAY REAL:C219($aCost; $hit)
					ARRAY REAL:C219($aNotBilled; $hit)
				End if 
				
				$aCust{$ordCursor}:=$_Custid{$i}
				$aOrder{$ordCursor}:=0
				$aBooked{$ordCursor}:=0
				$aInvoiced{$ordCursor}:=0
				$aQuoted{$ordCursor}:=$aQuoted{$ordCursor}+$_PriceQuoted{$i}
				$aCost{$ordCursor}:=$aCost{$ordCursor}+$_PriceActual{$i}
				$aNotBilled{$ordCursor}:=$_PriceActual{$i}
			End if 
			
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	uThermoClose
	xText:=xText+"Customer"+$t+"Order"+$t+"Booked"+$t+"Invoiced"+$t+"NotBilled"+$t+"Quoted"+$t+"Cost"+$t+"Lowballed"+$t+"Gain(Loss)"+$cr
	
	For ($i; 1; $ordCursor)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCust{$i})
		If ($aQuoted{$i}<$aCost{$i})
			$lowball:=$aCost{$i}-$aQuoted{$i}
		Else 
			$lowball:=0
		End if 
		
		xText:=xText+[Customers:16]Name:2+$t+String:C10($aOrder{$i})+$t+String:C10($aBooked{$i})+$t+String:C10($aInvoiced{$i})+$t+String:C10($aNotBilled{$i})+$t+String:C10($aQuoted{$i})+$t+String:C10($aCost{$i})+$t+String:C10($lowball)+$t+String:C10($aBooked{$i}-$aCost{$i})+$cr
	End for 
	
	$docRef:=Create document:C266("PrepBillingSummary"+fYYMMDD(dDateEnd))
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType 
	$err:=util_Launch_External_App(Document)
	xText:=""
End if 