//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/21/12, 10:18:13
// ----------------------------------------------------
// Method: GaylordSchedulePrint
// Description:
// Prints the Gaylord Schedule
// $1 = "List" or "Detail"
// ----------------------------------------------------

C_BOOLEAN:C305($bWhichOne; $1)
C_DATE:C307(dDockDate; dDatePrinted)
C_TIME:C306(hTimePrinted)
C_LONGINT:C283(xlQty; xlQtyAvailable; xlQtyShipped; xlPageNum)
C_LONGINT:C283($xlTotalHeight; $xlMargen; $xlPrintablePixels; xlTotalQty; xlTotalQtyAvail; xlTotalQtyShipped)
C_LONGINT:C283(xlTotalOnHand; xlTotalPicked; xlOnHand; xlPicked)
C_TEXT:C284(tGCAST; tCustRef; tReleaseNum; tPrintTitle; tBin; tPalletID; tStatus)

tPrintTitle:=Get window title:C450
util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "SimplePickPrintList")
PRINT SETTINGS:C106
GET PRINTABLE AREA:C703($xlPrintablePixels)

$bWhichOne:=$1
xlTotalQty:=0
xlTotalQtyAvail:=0
xlTotalQtyShipped:=0
xlTotalOnHand:=0
xlTotalPicked:=0
dDatePrinted:=Current date:C33
hTimePrinted:=Current time:C178
xlPageNum:=1
$xlTotalHeight:=0
$xlMargen:=$xlPrintablePixels-40  //Leave room for the footer.

If (OK=1)
	If ($bWhichOne)  //Print the list
		PDF_setUp(tPrintTitle+" List Report "+String:C10(TSTimeStamp)+"pdf"; True:C214)
		$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form header:K43:3)
		
		For ($i; 1; Size of array:C274(PickListBox))
			tGCAST:=aGCAST{$i}
			dDockDate:=aDateSched{$i}
			xlQty:=aQtySched{$i}
			xlQtyAvailable:=aQtyShipable{$i}
			xlQtyShipped:=aQtyAct{$i}
			tCustRef:=aPO{$i}
			tReleaseNum:=String:C10(aRelNum{$i})
			
			xlTotalQty:=xlTotalQty+xlQty
			xlTotalQtyAvail:=xlTotalQtyAvail+xlQtyAvailable
			xlTotalQtyShipped:=xlTotalQtyShipped+xlQtyShipped
			
			If ($xlTotalHeight<$xlMargen)
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form detail:K43:1)
			Else 
				$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form footer:K43:2)
				PAGE BREAK:C6(>)
				xlPageNum:=xlPageNum+1
				$xlTotalHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form header:K43:3)
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form detail:K43:1)
			End if 
			
			If ($i=Size of array:C274(PickListBox))  //Print the footer on the last page.
				//Print the Totals line
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form break1:K43:15)
				
				Repeat 
					$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form break0:K43:14)
				Until ($xlTotalHeight>=$xlMargen)
				$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintList"; Form footer:K43:2)
				PAGE BREAK:C6
			End if 
		End for 
		
	Else   //Print the detail
		PDF_setUp(tPrintTitle+" Detail Report "+String:C10(TSTimeStamp)+"pdf"; True:C214)
		tPrintTitleSub:="Details"
		
		tGCAST:=aGCAST{PickListBox}
		dDockDate:=aDateSched{PickListBox}
		xlQty:=aQtySched{PickListBox}
		xlQtyAvailable:=aQtyShipable{PickListBox}
		xlQtyShipped:=aQtyAct{PickListBox}
		tCustRef:=aPO{PickListBox}
		tReleaseNum:=String:C10(aRelNum{PickListBox})
		$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form header:K43:3)
		
		$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form detail:K43:1)
		For ($i; 1; Size of array:C274(InvListBox))
			tBin:=aBin{$i}
			xlOnHand:=aQtyOnHand{$i}
			xlPicked:=aPicked{$i}
			tPalletID:=aPallet{$i}
			tStatus:=aState{$i}
			
			xlTotalOnHand:=xlTotalOnHand+xlOnHand
			xlTotalPicked:=xlTotalPicked+xlPicked
			
			If ($xlTotalHeight<$xlMargen)
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form break2:K43:16)
			Else 
				$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form footer:K43:2)
				PAGE BREAK:C6(>)
				xlPageNum:=xlPageNum+1
				$xlTotalHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form detail:K43:1)
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form break2:K43:16)
			End if 
			
			If ($i=Size of array:C274(InvListBox))  //Print the footer on the last page.
				//Print the Totals line
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form break1:K43:15)
				
				Repeat 
					$xlTotalHeight:=$xlTotalHeight+Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form break0:K43:14)
				Until ($xlTotalHeight>=$xlMargen)
				$xlHeight:=Print form:C5([Customers_ReleaseSchedules:46]; "SimplePickPrintDetail"; Form footer:K43:2)
				PAGE BREAK:C6
			End if 
		End for 
	End if 
End if 