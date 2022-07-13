//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/05/12, 14:39:33
// ----------------------------------------------------
// Method: Rama_PrintTransactions
// Description:
// Prints the transactions either "By Date" or "Subtotalled".
// ----------------------------------------------------
// Modified by: Mel Bohince (3/3/15) num the xlBOL on the rpt and don't force PDF

C_LONGINT:C283($xlPrintWhat; $xlPrintedRow; $1; xlQty; xlPageNum; xlSubTotalQty; xlTotalQty)

C_LONGINT:C283($xlTotalHeight; $xlPrintablePixels)
C_REAL:C285(xrCost; xrSubTotalCost; xrTotalCost)
C_TEXT:C284(tService; tPalletID; tJobForm; tGCAST; tPrintTitle; tBOL)
C_DATE:C307(dDate; dInvoiced; dPaid; dDatePrinted)
C_BOOLEAN:C305($bBreakRow)

util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "Rama_PrintTransactions")
PRINT SETTINGS:C106

If (OK=1)  // Added by: Mark Zinke (8/30/13) Added to respect the Cancel button.
	tPrintTitle:=Get window title:C450
	If (bYes=1)  //By Date
		// Modified by: Mel Bohince (3/3/15) num the xlBOL on the rpt and don't force PDF
		PDF_setUp(tPrintTitle+" Report (by Date) "+String:C10(TSTimeStamp)+"pdf")  //;True)
	Else   //Subtotalled
		PDF_setUp(tPrintTitle+" Report (Subtotalled) "+String:C10(TSTimeStamp)+"pdf")  //;True)
	End if 
	GET PRINTABLE AREA:C703($xlPrintablePixels)  //593 for landscape, usually
	
	$xlPrintWhat:=$1
	xlSubTotalQty:=0
	xlTotalQty:=0
	xrSubTotalCost:=0
	xrTotalCost:=0
	dDatePrinted:=Current date:C33
	hTimePrinted:=Current time:C178
	xlPageNum:=1
	$xlTotalHeight:=0
	$xlMargen:=$xlPrintablePixels-40  //Leave room for the footer.
	
	If ($xlPrintWhat=1)  //Print By Date
		tPrintTitle:="Rama Transactions, By Date"
		LISTBOX SORT COLUMNS:C916(InvListBox; 1; >)
	Else   //Print Subtotalled
		tPrintTitle:="Rama Transactions, Subtotal by GCAST"
		LISTBOX SORT COLUMNS:C916(InvListBox; 6; >)
	End if 
	
	$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form header:K43:3)
	
	For ($i; 1; Size of array:C274(aDateIncurred))
		dDate:=aDateIncurred{$i}
		tJobForm:=aJobForm{$i}
		xlQty:=aiQty{$i}
		xrCost:=aCost{$i}
		tService:=aRMcode{$i}
		tGCAST:=aCPN{$i}
		dInvoiced:=aDateInvoiced{$i}
		dPaid:=aDatePaid{$i}
		tPalletID:=aPallet{$i}
		xlBOL:=Num:C11(aBOL{$i})  // Modified by: Mel Bohince (3/3/15) num the xlBOL on the rpt and don't force PDF
		If ($xlPrintWhat=0)
			xlSubTotalQty:=xlSubTotalQty+xlQty
			xrSubTotalCost:=xrSubTotalCost+xrCost
		End if 
		
		xlTotalQty:=xlTotalQty+xlQty
		xrTotalCost:=xrTotalCost+xrCost
		
		If ($xlTotalHeight<$xlMargen)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form detail:K43:1)
		Else 
			$xlHeight:=Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form footer:K43:2)
			PAGE BREAK:C6(>)
			xlPageNum:=xlPageNum+1
			$xlTotalHeight:=Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form header:K43:3)
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form detail:K43:1)
		End if 
		
		If ($xlPrintWhat=0)  //Print subtotalled. Multiple If statements cuz it's easier to read.
			If ($i<Size of array:C274(aDateIncurred))  //So we don't go over the size of the array.
				If (aCPN{$i}#aCPN{$i+1})
					If ($xlTotalHeight<$xlMargen)
						$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form break2:K43:16)
					Else 
						$xlHeight:=Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form footer:K43:2)
						PAGE BREAK:C6(>)
						xlPageNum:=xlPageNum+1
						$xlTotalHeight:=Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form header:K43:3)
						$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form break2:K43:16)
					End if 
					xlSubTotalQty:=0
					xrSubTotalCost:=0
				End if 
			End if 
		End if 
		
		If ($i=Size of array:C274(aDateIncurred))  //Print the footer on the last page.
			If ($xlPrintWhat=0)  //Print subtotalled
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form break2:K43:16)
			End if 
			//Print the Totals line
			$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form break1:K43:15)
			
			Repeat 
				$xlTotalHeight:=$xlTotalHeight+Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form break0:K43:14)
			Until ($xlTotalHeight>=$xlMargen)
			$xlHeight:=Print form:C5([Raw_Materials_Transactions:23]; "Rama_PrintTransactions"; Form footer:K43:2)
			PAGE BREAK:C6
		End if 
	End for 
End if 