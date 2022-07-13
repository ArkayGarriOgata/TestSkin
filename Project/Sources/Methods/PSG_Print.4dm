//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/26/12, 10:23:06
// ----------------------------------------------------
//***TODO Method: GlueSchedulePrintList
// Description:
// Print List for the Glue Schedule dialog.
// ----------------------------------------------------

C_DATE:C307(dDatePrinted; dDate)
C_TIME:C306(hTimePrinted)
C_TEXT:C284(tPrintTitle; tGluer; tPriority; tCustomer; tProductCode; tJobit; tStyle; tOutline; tSeperate; tPrinted; tDieCut; tComments)
C_LONGINT:C283($xlTotalHeight; $xlMargen; $xlPrintablePixels)
C_LONGINT:C283(xlPageNum; xlTotalPlanned; xlTotalReleased)

util_PAGE_SETUP(->[ProductionSchedules:110]; "GlueSchedulePrint")
PRINT SETTINGS:C106
If (ok=1)
	tPrintTitle:=Get window title:C450
	PDF_setUp(tPrintTitle+"_Report_"+String:C10(TSTimeStamp)+"pdf"; True:C214)
	GET PRINTABLE AREA:C703($xlPrintablePixels)
	
	$xlTotalHeight:=0
	$xlMargen:=$xlPrintablePixels-80  //Leave room for the footer.
	dDatePrinted:=Current date:C33
	hTimePrinted:=Current time:C178
	xlPageNum:=1
	xlTotalPlanned:=0
	xlTotalReleased:=0
	
	If (OK=1)
		$xlTotalHeight:=$xlTotalHeight+Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form header:K43:3)
		
		For ($i; 1; Size of array:C274(aGlueListBox))
			If (Not:C34(abHidden{$i}))  // Added by: Mark Zinke (2/7/14) We need to take the hidden status into account.
				GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{aGlueListBox})
				tGluer:=aGluer{$i}
				If (aPrior{[Job_Forms_Items:44]Priority:48}=0)
					tPriority:="N/S"
				Else 
					tPriority:=String:C10(aPrior{[Job_Forms_Items:44]Priority:48})
				End if 
				tCustomer:=aCustLine{$i}
				tProductCode:=aCPN{$i}
				tJobit:=aJobit{$i}
				xlQtyPlanned:=aQtyPlnd{$i}
				xlQtyReleased:=aQtyReleased{$i}
				dReleased:=aReleased{$i}
				dHRD:=aHRD{$i}
				tStyle:=aStyle{aGlueListBox}
				tOutline:=aOutline{$i}
				tSeperate:=aSeparate{aGlueListBox}
				tPrinted:=aPrinted{$i}
				tDieCut:=aDieCut{$i}
				tComments:=aComment{$i}
				
				xlTotalPlanned:=xlTotalPlanned+xlQtyPlanned
				xlTotalReleased:=xlTotalReleased+xlQtyReleased
				
				If ($xlTotalHeight<$xlMargen)
					$xlTotalHeight:=$xlTotalHeight+Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form detail:K43:1)
				Else 
					$xlHeight:=Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form footer:K43:2)
					PAGE BREAK:C6(>)
					xlPageNum:=xlPageNum+1
					$xlTotalHeight:=Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form header:K43:3)
					$xlTotalHeight:=$xlTotalHeight+Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form detail:K43:1)
				End if 
				
				If ($i=Size of array:C274(aGlueListBox))  //Print the footer on the last page.
					//Print the Totals line
					$xlTotalHeight:=$xlTotalHeight+Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form break1:K43:15)
					
					Repeat 
						$xlTotalHeight:=$xlTotalHeight+Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form break0:K43:14)
					Until ($xlTotalHeight>=$xlMargen)
					$xlHeight:=Print form:C5([ProductionSchedules:110]; "GlueSchedulePrint"; Form footer:K43:2)
					PAGE BREAK:C6
				End if 
			End if 
		End for 
	End if 
End if   //ok print settings
