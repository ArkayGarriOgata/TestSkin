//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/29/12, 11:21:59
// ----------------------------------------------------
// Method: RamaForecast
// ----------------------------------------------------

C_DATE:C307(dDatePrinted)
C_TIME:C306(hTimePrinted)
C_TEXT:C284(tPrintTitle)
C_LONGINT:C283($xlTotalHeight; $xlMargen; $xlPrintablePixels)
C_LONGINT:C283(xlPageNum)

util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "SimpleForecastPrint")
PRINT SETTINGS:C106
tPrintTitle:=Get window title:C450
PDF_setUp(tPrintTitle+" Report "+String:C10(TSTimeStamp)+"pdf"; True:C214)
GET PRINTABLE AREA:C703($xlPrintablePixels)

$xlTotalHeight:=0
$xlMargen:=$xlPrintablePixels-40  //Leave room for the footer.
dDatePrinted:=Current date:C33
hTimePrinted:=Current time:C178
xlPageNum:=1

tPeriod1:=fcst_period1
tPeriod2:=fcst_period2
tPeriod3:=fcst_period3
tPeriod4:=fcst_period4
tPeriod5:=fcst_period5
tPeriod6:=fcst_period6

If (OK=1)
	$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form header:K43:3)
	
	For ($i; 1; Size of array:C274(PickListBox))
		tGCAST:=aCPN{$i}
		xlOnHand:=aQtyOnHand{$i}
		xlWIP:=aQtyWIP{$i}
		xlPastDue:=aPeriod0{$i}
		xlPeriod1:=aPeriod1{$i}
		xlPeriod2:=aPeriod2{$i}
		xlPeriod3:=aPeriod3{$i}
		xlPeriod4:=aPeriod4{$i}
		xlPeriod5:=aPeriod5{$i}
		xlPeriod6:=aPeriod6{$i}
		
		If ($xlTotalHeight<$xlMargen)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form detail:K43:1)
		Else 
			$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form footer:K43:2)
			PAGE BREAK:C6(>)
			xlPageNum:=xlPageNum+1
			$xlTotalHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form header:K43:3)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form detail:K43:1)
		End if 
		
		If ($i=Size of array:C274(PickListBox))  //Print the footer on the last page.
			//Print the Totals line
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form break1:K43:15)
			
			Repeat 
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form break0:K43:14)
			Until ($xlTotalHeight>=$xlMargen)
			$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimpleForecastPrint"; Form footer:K43:2)
			PAGE BREAK:C6
		End if 
	End for 
End if 