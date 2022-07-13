//%attributes = {}
// -------
// Method: IBOL_IntraPlanTransfer   ( ) ->
// By: Mel Bohince @ 10/31/18, 15:09:57
// Description
// create packing slip for tracking inventory being trucked to a different location, 
//    not for sale to customer
// ----------------------------------------------------
// Modified by: Mel Bohince (10/26/20) changes to Printing and Making a new BOL on [WMS_InternalBOLs];"InternalBOL_ui"
// Modified by: Mel Bohince (10/29/20) make listbox redraw after item is clicked, which would possible update teh record with current skid list
// Modified by: Mel Bohince (10/27/21) loosing selected bol after $1="get_skid_list"

C_LONGINT:C283($winRef; fileNum; vAskMePID)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile; $2)

Case of 
	: (Count parameters:C259=0)  //init
		$xlPID:=Process number:C372("InternalBOL")
		If ($xlPID=0)
			$xlPID:=uSpawnProcess("IBOL_IntraPlanTransfer"; <>lMidMemPart; "InternalBOL"; False:C215; False:C215; "init")
			If (False:C215)
				IBOL_IntraPlanTransfer
			End if 
			
		Else 
			SHOW PROCESS:C325($xlPID)
			BRING TO FRONT:C326($xlPID)
			POST OUTSIDE CALL:C329($xlPID)
		End if 
		
	: ($1="batch_update")
		If (WMS_API_4D_DoLogin)
			READ WRITE:C146([WMS_InternalBOLs:163])
			IBOL_IntraPlanTransfer("purge_bol")
			
			While (Not:C34(End selection:C36([WMS_InternalBOLs:163])))
				IBOL_IntraPlanTransfer("clear_skid_list")
				
				$bol:=[WMS_InternalBOLs:163]bol_number:2
				
				Begin SQL
					select skid_number, count(case_id) from cases 
					where bin_id = :$bol group by skid_number
					into :aSkidNumbers, :aNumCases
				End SQL
				
				$cases:=0
				$numElements:=Size of array:C274(aSkidNumbers)
				For ($i; 1; $numElements)
					$cases:=$cases+aNumCases{$i}
				End for 
				//only save if changed
				If ([WMS_InternalBOLs:163]number_of_skids:3#$numElements) | ([WMS_InternalBOLs:163]number_of_cases:4#$cases)
					[WMS_InternalBOLs:163]number_of_skids:3:=$numElements
					[WMS_InternalBOLs:163]number_of_cases:4:=$cases
					SAVE RECORD:C53([WMS_InternalBOLs:163])  //trigger_Internal_BOL
				End if 
				
				NEXT RECORD:C51([WMS_InternalBOLs:163])
			End while 
			
			WMS_API_4D_DoLogout
			
			IBOL_IntraPlanTransfer("purge_bol")
			
		Else 
			uConfirm("Could not connect to WMS database."; "OK"; "Help")
		End if 
		
		
	: ($1="init")
		READ WRITE:C146([WMS_InternalBOLs:163])
		READ ONLY:C145([WMS_SerializedShippingLabels:96])
		fileNum:=Table:C252(->[WMS_InternalBOLs:163])
		filePtr:=Table:C252(fileNum)
		sFile:=Table name:C256(filePtr)
		printMenuSupported:=True:C214
		SET MENU BAR:C67(<>DefaultMenu)
		
		ARRAY INTEGER:C220($aFieldNums; 0)  //•090195  MLB      
		COPY ARRAY:C226(<>aSlctFF{Table:C252(filePtr)}; $aFieldNums)  //aSlctField  
		
		ARRAY POINTER:C280(aSlctField; 0)
		ARRAY POINTER:C280(aSlctField; 6)  // for backward compatiblity
		ARRAY TEXT:C222(aSelectBy; 0)
		ARRAY TEXT:C222(aSelectBy; 13)
		
		vAskMePID:=0
		windowTitle:=" Internal BOL"
		OK:=1
		$winRef:=OpenFormWindow(filePtr; "InternalBOL_ui"; ->windowTitle)
		DIALOG:C40(filePtr->; "InternalBOL_ui")
		CLOSE WINDOW:C154($winRef)
		
	: ($1="purge_bol")
		QUERY:C277([WMS_InternalBOLs:163]; [WMS_InternalBOLs:163]canPurge:10=True:C214)
		If (Records in selection:C76([WMS_InternalBOLs:163])>0)
			util_DeleteSelection(->[WMS_InternalBOLs:163])
		End if 
		ALL RECORDS:C47([WMS_InternalBOLs:163])
		ORDER BY:C49([WMS_InternalBOLs:163]; [WMS_InternalBOLs:163]bol_number:2; <)
		
	: ($1="new_bol")  // Modified by: Mel Bohince (10/26/20) see test on the 'New BOL' btn calling this
		CREATE RECORD:C68([WMS_InternalBOLs:163])
		[WMS_InternalBOLs:163]Destination:11:="Arkay Warehouse, 872 Lee Hwy, Roanoke, VA 24019"
		[WMS_InternalBOLs:163]Carrier:12:="Arkay Logistics"
		
		SAVE RECORD:C53([WMS_InternalBOLs:163])  //trigger_Internal_BOL
		CREATE SET:C116([WMS_InternalBOLs:163]; "$ListboxSet")
		
		IBOL_IntraPlanTransfer("print_bol"; [WMS_InternalBOLs:163]bol_number:2)
		
		ALL RECORDS:C47([WMS_InternalBOLs:163])
		ORDER BY:C49([WMS_InternalBOLs:163]; [WMS_InternalBOLs:163]bol_number:2; <)
		
	: ($1="print_bol")
		If (Records in set:C195("$ListboxSet")>0)  // Modified by: Mel Bohince (10/26/20) 
			ARRAY LONGINT:C221($_iBOLs; 0)
			LONGINT ARRAY FROM SELECTION:C647([WMS_InternalBOLs:163]; $_iBOLs)
			
			USE SET:C118("$ListboxSet")
			For ($selected; 1; Records in selection:C76([WMS_InternalBOLs:163]))
				
				//GOTO SELECTED RECORD([WMS_InternalBOLs];$selected)
				
				$weightOverride:=[WMS_InternalBOLs:163]Weight:14
				C_TEXT:C284(tCol1; tCol2)
				tCol1:="     SKID NUMBER   #CASES\r"  //this is the manifest
				tCol2:="     SKID NUMBER   #CASES\r"  //this is the manifest
				//xText:=xText+(45*"002...012345678     33          002...012345678     33\r")
				
				$bol:=[WMS_InternalBOLs:163]bol_number:2  //$2
				IBOL_IntraPlanTransfer("get_skid_list"; $bol)
				If ($weightOverride#[WMS_InternalBOLs:163]Weight:14)
					uConfirm("Calculated Weight is "+String:C10([WMS_InternalBOLs:163]Weight:14)+", use override?"; String:C10($weightOverride); String:C10([WMS_InternalBOLs:163]Weight:14))
					If (ok=1)
						[WMS_InternalBOLs:163]Weight:14:=$weightOverride
						SAVE RECORD:C53([WMS_InternalBOLs:163])
					End if 
				End if 
				$numSkids:=Size of array:C274(aSkidNumbers)
				uThermoInit($numElements; "Making Packing Slip")
				For ($i; 1; 50)
					If ($numSkids>=$i)
						tCol1:=tCol1+"("+String:C10($i; "^^")+") "+aSkidNumbers{$i}+(3*" ")+String:C10(aNumCases{$i}; "^^^")+"\r"
						$col2Cursor:=$i+50
						If ($numSkids>=$col2Cursor)
							tCol2:=tCol2+"("+String:C10($col2Cursor; "^^")+") "+aSkidNumbers{$col2Cursor}+(3*" ")+String:C10(aNumCases{$col2Cursor}; "^^^")+"\r"
						End if 
					End if 
					uThermoUpdate($i)
				End for 
				uThermoClose
				LOAD RECORD:C52([WMS_InternalBOLs:163])
				
				PRINT SETTINGS:C106
				Print form:C5([WMS_InternalBOLs:163]; "InternalBOL_printout")
				
				NEXT RECORD:C51([WMS_InternalBOLs:163])
			End for   //each selected
			
			CREATE SELECTION FROM ARRAY:C640([WMS_InternalBOLs:163]; $_iBOLs)
			
		End if   //selection
		
	: ($1="clear_skid_list")
		ARRAY TEXT:C222(aSkidNumbers; 0)
		ARRAY LONGINT:C221(aNumCases; 0)
		ARRAY LONGINT:C221(aSkidQty; 0)
		
	: ($1="get_skid_list")  //log into wms and query for that bol
		If (Count parameters:C259>1)
			
			IBOL_IntraPlanTransfer("clear_skid_list")
			$bol:=$2
			//$bol:="BNRFG"  //"BNRFG_TRANSIT_2"
			
			If (WMS_API_4D_DoLogin)
				
				
				
				Begin SQL
					select skid_number, count(case_id), sum(qty_in_case) from cases 
					where bin_id = :$bol group by skid_number
					into :aSkidNumbers, :aNumCases, :aSkidQty
				End SQL
				
				WMS_API_4D_DoLogout
				
				
				C_LONGINT:C283($i; $numElements; $cases)
				$cases:=0
				$numElements:=Size of array:C274(aSkidNumbers)
				//uThermoInit ($numElements;"Processing Array")
				For ($i; 1; $numElements)
					If (Length:C16(aSkidNumbers{$i})>0)
						aSkidNumbers{$i}:=Substring:C12(aSkidNumbers{$i}; 1; 3)+"..."+Substring:C12(aSkidNumbers{$i}; 13)
					Else 
						aSkidNumbers{$i}:="LOOSE CASES   "
					End if 
					
					$cases:=$cases+aNumCases{$i}
					//uThermoUpdate ($i)
				End for 
				//uThermoClose 
				
				
				[WMS_InternalBOLs:163]number_of_skids:3:=$numElements
				[WMS_InternalBOLs:163]number_of_cases:4:=$cases
				[WMS_InternalBOLs:163]Weight:14:=$cases*30
				SAVE RECORD:C53([WMS_InternalBOLs:163])
				//REDRAW WINDOW(Current form window)  //doesnt work
				//iListBox:=iListBox  //doesnt work
				
				// Modified by: Mel Bohince (10/27/21) next 2 lines prevent purge
				//ALL RECORDS([WMS_InternalBOLs])  // Modified by: Mel Bohince (10/29/20) get it to redraw the listbox
				//ORDER BY([WMS_InternalBOLs];[WMS_InternalBOLs]bol_number;<)
				
			Else 
				uConfirm("Could not connect to WMS database."; "OK"; "Help")
			End if 
			
			
		Else 
			uConfirm("BOL number required to get skid list.")
		End if 
		
		
	Else 
		uConfirm("Unknown parameter 1.")
End case 
