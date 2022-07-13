//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/27/12, 10:28:19
// ----------------------------------------------------
// Method: ShippingPrintList
// ----------------------------------------------------

C_DATE:C307(dDatePrinted; dDate; dShipDate)
C_TIME:C306(hTimePrinted)
C_TEXT:C284(tPrintTitle; tBol; tSTatus; tCases; tBillTo; tShipTo; tDocAppt; tCarrier; tPrinted; tPayUse; tExecuted)
C_LONGINT:C283($xlTotalHeight; $xlMargen; $xlPrintablePixels)
C_LONGINT:C283(xlPageNum; xlBOL; xlCases)

util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "BolPrint")
PRINT SETTINGS:C106
PDF_setUp("Customers Bills of Lading Report "+String:C10(TSTimeStamp)+"pdf"; True:C214)
GET PRINTABLE AREA:C703($xlPrintablePixels)

$xlTotalHeight:=0
$xlMargen:=$xlPrintablePixels-40  //Leave room for the footer.
tPrintTitle:="Customers Bills of Lading"
dDatePrinted:=Current date:C33
hTimePrinted:=Current time:C178
xlPageNum:=1

If (OK=1)
	$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form header:K43:3)
	
	For ($i; 1; Records in selection:C76([Customers_Bills_of_Lading:49]))
		GOTO SELECTED RECORD:C245([Customers_Bills_of_Lading:49]; $i)
		xlBol:=[Customers_Bills_of_Lading:49]ShippersNo:1
		dShipDate:=[Customers_Bills_of_Lading:49]ShipDate:20
		tPrinted:=Choose:C955([Customers_Bills_of_Lading:49]WasPrinted:8; "Yes"; "No")
		tPayUse:=Choose:C955([Customers_Bills_of_Lading:49]PayUse:23; "Yes"; "No")
		tExecuted:=Choose:C955([Customers_Bills_of_Lading:49]WasBilled:29; "Yes"; "No")
		tStatus:=[Customers_Bills_of_Lading:49]Status:32
		xlCases:=[Customers_Bills_of_Lading:49]Total_Cases:14
		tBillTo:=[Customers_Bills_of_Lading:49]BillTo:4
		tShipTo:=[Customers_Bills_of_Lading:49]ShipTo:3+": "+ADDR_getCity([Customers_Bills_of_Lading:49]ShipTo:3)
		tDocAppt:=[Customers_Bills_of_Lading:49]DockAppointment:21
		tCarrier:=[Customers_Bills_of_Lading:49]Carrier:9
		
		If ($xlTotalHeight<$xlMargen)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form detail:K43:1)
		Else 
			$xlHeight:=Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form footer:K43:2)
			PAGE BREAK:C6(>)
			xlPageNum:=xlPageNum+1
			$xlTotalHeight:=Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form header:K43:3)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form detail:K43:1)
		End if 
		
		If ($i=Records in selection:C76([Customers_Bills_of_Lading:49]))  //Print the footer on the last page.
			//Print the Totals line
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form break1:K43:15)
			
			Repeat 
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form break0:K43:14)
			Until ($xlTotalHeight>=$xlMargen)
			$xlHeight:=Print form:C5([Customers_Bills_of_Lading:49]; "BolPrint"; Form footer:K43:2)
			PAGE BREAK:C6
		End if 
	End for 
End if 