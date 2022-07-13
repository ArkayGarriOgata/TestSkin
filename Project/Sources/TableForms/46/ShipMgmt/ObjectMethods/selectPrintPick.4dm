// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.selectPrintPick   ( ) ->
// By: Mel Bohince @ 06/10/20, 11:24:54
// Description
// based on sPrintPickLists
// ----------------------------------------------------
// Added by: Mel Bohince (6/26/20) progress indicator

REL_getRecertificationRequired  //used by the Print Pick rpt btn so init here

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
USE ENTITY SELECTION:C1513(Form:C1466.selected)
$rels:=Records in selection:C76([Customers_ReleaseSchedules:46])
If ($rels>0)
	
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "PickList4b")
	PRINT SETTINGS:C106
	
	If (ok=1)
		READ ONLY:C145([Customers:16])  //••
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1; >)
		dAsof:=4D_Current_date
		tTime:=4d_Current_time
		
		BREAK LEVEL:C302(2; 1)
		ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
		xReptTitle:="Release Pick Sheet"
		xComment:="'one page per release'"
		FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList4b")
		
		ARRAY LONGINT:C221($_OnePagers; 0)
		LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_OnePagers)
		C_LONGINT:C283($i)
		ON EVENT CALL:C190("eCancelProc")
		<>fContinue:=True:C214
		
		C_LONGINT:C283($outerBar; $outerLoop; $out)  // Added by: Mel Bohince (6/26/20) progress indicator
		$outerBar:=Progress New  //new progress bar
		Progress SET TITLE($outerBar; "Printing Picks")  //optional init of the thermoeters title
		Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration
		C_BOOLEAN:C305($continueInteration)
		$continueInteration:=True:C214  //option to break out of ForEach
		
		For ($i; 1; $rels)
			// Added by: Mel Bohince (6/26/20) progress indicator
			Progress SET PROGRESS($outerBar; $i/$outerLoop)  //update the thermometer
			Progress SET MESSAGE($outerBar; String:C10($i)+" of "+String:C10($rels))  //optional verbose status
			
			$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
			If ($continueInteration)  //respect the cancel if necessary
				//
				
				GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $_OnePagers{$i})
				If (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
					xReptTitle:="EPD:"+String:C10([Customers_ReleaseSchedules:46]user_date_2:49; System date long:K1:3)+" Release Pick Sheet"
				End if 
				$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+".pdf"
				If (Length:C16($docName)>31)
					$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10($i)+".pdf"
				End if 
				PDF_setUp($docName)
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				If (Not:C34(<>fContinue))
					$i:=$i+$rels
				End if 
				
			Else 
				$i:=1+$rels  //break
			End if   //$continueInteration
		End for 
		Progress QUIT($outerBar)  //remove the thermometer
		ON EVENT CALL:C190("")
		
	End if   //print settings
	
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
Else   //btn shuldn't be enabled
	uConfirm("Please select the Release(s) for which to print the Pick List."; "Try Again"; "Cancel")
End if   //rec in sel