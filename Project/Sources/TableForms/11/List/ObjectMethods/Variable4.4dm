//(S) List'bPrint

$Continue:=True:C214
zwStatusMsg("PRINTING POs"; "Only those in status = Approved")
CUT NAMED SELECTION:C334([Purchase_Orders:11]; "beforePrint")
USE SET:C118("UserSet")  //use POs user selected to process

Case of 
	: (Records in set:C195("UserSet")=0)
		uConfirm("Select the Purchase Orders that you wish to print."; "OK"; "Help")
		USE NAMED SELECTION:C332("beforePrint")
		
	Else 
		uConfirm("Print all selected or only Approved?"; "All"; "Approved")  //may need hardcpy for sig from plt mgr
		If (ok=0)
			SET QUERY DESTINATION:C396(Into set:K19:2; "notRiteStatus")
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Status:15#"Approved")
				If (Records in set:C195("notRiteStatus")>0)
					COPY SET:C600("notRiteStatus"; "$notRiteStatus")
					DIFFERENCE:C122("UserSet"; "$notRiteStatus"; "UserSet")
					CLEAR SET:C117("$notRiteStatus")
					USE SET:C118("UserSet")
				End if 
				CLEAR SET:C117("notRiteStatus")
				
			Else 
				
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
		End if 
		
		$Count:=Records in selection:C76([Purchase_Orders:11])
		If ($Count>0)
			SET WINDOW TITLE:C213("Printing "+String:C10($Count)+" PURCHASE ORDERs ")
			
			util_PAGE_SETUP(->[Purchase_Orders:11]; "LaserPO")
			
			If (OK=1)
				<>fContinue:=True:C214  //◊fContinue = flag that user stopped printing
				ON ERR CALL:C155("eCancelPrint")
				
				$Print:=POGetAuthorize
				UNLOAD RECORD:C212([Users:5])
				If ($Print#"Stop")
					PRINT SETTINGS:C106
					If (ok=0)
						$Count:=0
					End if 
				Else 
					$Count:=0
				End if 
				
				uThermoInit($Count; "Approving Purchase Orders...")
				For ($i; 1; $Count)
					PO_PrintOrder($Print)
					
					NEXT RECORD:C51([Purchase_Orders:11])
					uThermoUpdate($i; 1)
				End for 
				uThermoClose
				
				ON ERR CALL:C155("")
			End if 
			
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
			
		Else 
			BEEP:C151
			ALERT:C41("There are no Approved PO's selected.")
		End if   //count
		USE NAMED SELECTION:C332("beforePrint")
		HIGHLIGHT RECORDS:C656  //([PURCHASE_ORDER])
		zwStatusMsg("PRINTING POs"; "Highlighted Purchase Orders have been printed.")
		BEEP:C151
		fNameWindow(filePtr)
		
End case 