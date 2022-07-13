//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/26/12, 09:15:39
// ----------------------------------------------------
// Method: RamaInTransitInventoryPrint
// Description:
// Print code for Rama In Transit and Inventory dialog.
// ----------------------------------------------------

C_DATE:C307(dDatePrinted; dDate)
C_TIME:C306(hTimePrinted)
C_TEXT:C284(tPrintTitle; tGCAST; tBin; tPalletID; tStatus)
C_LONGINT:C283($xlTotalHeight; $xlMargen; $xlPrintablePixels)
C_LONGINT:C283(xlPageNum; xlTotalOnHand; xlOnHand)

tPrintTitle:=Get window title:C450
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "InTransitPrint")
PRINT SETTINGS:C106
PDF_setUp(tPrintTitle+" Report "+String:C10(TSTimeStamp)+"pdf"; True:C214)
GET PRINTABLE AREA:C703($xlPrintablePixels)

$xlTotalHeight:=0
$xlMargen:=$xlPrintablePixels-40  //Leave room for the footer.
dDatePrinted:=Current date:C33
hTimePrinted:=Current time:C178
xlPageNum:=1
xlTotalOnHand:=0

If (OK=1)
	$xlTotalHeight:=$xlTotalHeight+Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form header:K43:3)
	
	For ($i; 1; Size of array:C274(InvListBox))
		tGCAST:=aCPN{$i}
		tBin:=aBin{$i}
		xlOnHand:=aQtyOnHand{$i}
		tPalletID:=aPallet{$i}
		tStatus:=aState{$i}
		dDate:=aDateOfMfg{$i}
		
		xlTotalOnHand:=xlTotalOnHand+xlOnHand
		
		If ($xlTotalHeight<$xlMargen)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form detail:K43:1)
		Else 
			$xlHeight:=Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form footer:K43:2)
			PAGE BREAK:C6(>)
			xlPageNum:=xlPageNum+1
			$xlTotalHeight:=Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form header:K43:3)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form detail:K43:1)
		End if 
		
		If ($i=Size of array:C274(InvListBox))  //Print the footer on the last page.
			//Print the Totals line
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form break1:K43:15)
			
			Repeat 
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form break0:K43:14)
			Until ($xlTotalHeight>=$xlMargen)
			$xlHeight:=Print form:C5([Finished_Goods_Locations:35]; "InTransitPrint"; Form footer:K43:2)
			PAGE BREAK:C6
		End if 
	End for 
End if 