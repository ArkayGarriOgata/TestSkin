//%attributes = {"publishedWeb":true}
//(p) rLaserPO
//prints the new (11/13/97) laser printable PO form
//$1 - string - anything printing from inside a PO
//• 11/13/97 cs  created
//• 1/21/98 cs define a number of vars, removing truncation error
//• 2/19/98 cs modified report - added PO total &
//    listed Job form id(s) for each item (if they exist)
//   commented out sort on PO number before printing.
//   reworked interface slightly to make it easier to use.
//• 3/2/98 cs added ability to print directly from inside PO
//• 3/2/98 cs fixed problem with Authorization code - a small typo
// would stop signatures from printing - with no warning to user
//• 3/6/98 cs make print order match selected entry order
//• 3/19/98 cs remove status of printed/faxed
//• 3/25/98 cs I use an apply to selectio to set the printed field
//  which lost my current selection - fixed
//• 3/26/98 cs try again - this fixed the problem IF the apply to selectio WAS the
//  problem - it was not there was an extra unload record
//  ALSO - adjusted logic on update of print state so that the 'printed' field
//  only will get set if the record is printed WITH a sig.
//•090299  mlb  UPR 2047 adapt to print from list layouts

C_BOOLEAN:C305(fContinue; $Continue)
C_TEXT:C284(t3; saddress1; saddress2; szip; sPhone; t2)  //• 1/21/98 cs 
C_TEXT:C284($1; $2; sState)  //• 1/21/98 cs  `•090299  mlb  UPR 2047 adapt to print from list layouts
C_TEXT:C284(sCity)  //• 1/21/98
C_TEXT:C284(sName)  //• 1/21/98 cs 
C_TEXT:C284(sType)  //• 1/21/98 cs 
C_TEXT:C284($Print)
C_TEXT:C284(sMachLabel1)

Case of 
	: (Count parameters:C259=0)  //printing from pallete
		READ WRITE:C146([Purchase_Orders:11])
		READ ONLY:C145([Purchase_Orders_Items:12])
		READ ONLY:C145([Users:5])
		DEFAULT TABLE:C46([Purchase_Orders:11])
		SET MENU BAR:C67(<>DefaultMenu)
		DIALOG:C40([Purchase_Orders:11]; "SelectPO")
		
	: (Count parameters:C259=2)  //printing from list `•090299  mlb  UPR 2047 adapt to print from list layouts
		READ WRITE:C146([Purchase_Orders:11])
		OK:=1
		
	Else   //printg from inside PO
		SAVE RECORD:C53([Purchase_Orders:11])  //• 4/24/98 cs fining problems with status changes
		OK:=1
End case 

If (OK=1)
	fContinue:=False:C215
	$Print:=POGetAuthorize
	
	Case of   //user selected to stop
		: ($Print="Stop")
			$Continue:=False:C215
		: ($Print="NoSig")  //print with no signature
			
			$Continue:=True:C214
		Else   //print with signature 
			$Continue:=True:C214
			fContinue:=True:C214
	End case 
	
	If ($Continue)
		$numPOs:=Records in selection:C76([Purchase_Orders:11])
		SET WINDOW TITLE:C213("Printing "+String:C10($numPOs)+" PURCHASE ORDERs ")
		FORM SET OUTPUT:C54([Purchase_Orders:11]; "LaserPO")
		UNLOAD RECORD:C212([Users:5])
		READ ONLY:C145([Users:5])
		util_PAGE_SETUP(->[Purchase_Orders:11]; "LaserPO")
		PRINT SETTINGS:C106
		
		If (OK=1)
			<>fContinue:=True:C214  //◊fContinue = flag that user stopped printing
			ON ERR CALL:C155("eCancelPrint")
			
			If (Count parameters:C259=0) | (Count parameters:C259=2)  //if printing from palette printing one or more `•090299  mlb  UPR 2047 adapt to p
				For ($i; 1; $numPOs)
					$Po:=uParseString(t1; 1; Char:C90(13); ->t1)  //• 3/6/98 cs start - make printing order match selected entry order
					
					USE SET:C118("printThese")
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$Po)  //• 3/6/98 cs end
					
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					If (<>fContinue)
						PO_PrintOrder($Print)
						NEXT RECORD:C51([Purchase_Orders:11])
					Else 
						$i:=$i+$numPOs
					End if 
				End for 
				
				
				CLEAR SET:C117("PrintThese")
				uClearSelection(->[Purchase_Orders:11])
				
			Else   //1param, printing from inside PO
				
				UNLOAD RECORD:C212([Purchase_Orders:11])
				READ WRITE:C146([Purchase_Orders:11])
				LOAD RECORD:C52([Purchase_Orders:11])
				PO_PrintOrder($Print)
			End if 
		End if   //params
		
		CLEAR SET:C117("printThese")  //• 3/6/98 cs moved from dialog
		
		ON ERR CALL:C155("")
	End if 
End if 

FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
<>fContinue:=True:C214