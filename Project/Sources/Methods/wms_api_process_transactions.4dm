//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/14/08, 13:40:26
// ----------------------------------------------------
// Method: wms_api_process_transactions
// Description
// 
//
// Parameters
// ----------------------------------------------------
//now process them chronolgically
// Modified by: Mel Bohince (4/22/15) check locking
// Modified by: Mel Bohince (10/24/18) don't adjust "150" in shipping areas
// Modified by: Mel Bohince (2/4/19) validate jobit

//WMS_API_LoginLookup
READ WRITE:C146([WMS_aMs_Exports:153])
READ ONLY:C145([Job_Forms_Items_Costs:92])  // Modified by: Mel Bohince (12/11/20) 

QUERY:C277([WMS_aMs_Exports:153]; [WMS_aMs_Exports:153]StateIndicator:3="S")  //S would be freshly imported
ORDER BY:C49([WMS_aMs_Exports:153]; [WMS_aMs_Exports:153]id:1; >)

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break; $successful)
$break:=False:C215
$numRecs:=Records in selection:C76([WMS_aMs_Exports:153])

uThermoInit($numRecs; "Updating Records")
$loginInitials:=<>zResp  //will be swapping to the user that made the scan so ams records have correct modwho
For ($i; 1; $numRecs)
	$successful:=False:C215
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	If (fLockNLoad(->[WMS_aMs_Exports:153]; "*"))  // Modified by: Mel Bohince (4/22/15)
		
		If ([WMS_aMs_Exports:153]ModWho:6#"ams")  //filter these as not wanting to include special scanner login ams:wms used to prevent changes to ams
			<>zResp:=[WMS_aMs_Exports:153]ModWho:6
			[WMS_aMs_Exports:153]Jobit:9:=wms_api_load_transaction_variab
			
			Case of 
				: ([WMS_aMs_Exports:153]Jobit:9="ERROR")  // Modified by: Mel Bohince (2/4/19) validate jobit
					utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"[WMS_aMs_Exports]TypeCode = "+String:C10([WMS_aMs_Exports:153]TypeCode:2)+" BAD JOBIT ENCOUNTERED.")
					$successful:=True:C214  //skip
					EMAIL_Sender("WMS_aMs_EXPORTS BAD JOBIT"; ""; "Check transaction "+String:C10([WMS_aMs_Exports:153]id:1))
					
				: (Length:C16(sCriterion4)<4)  // Modified by: Mel Bohince (5/4/18) 
					utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"[WMS_aMs_Exports]TypeCode = "+String:C10([WMS_aMs_Exports:153]TypeCode:2)+" 'TO' location format failure.")
					$successful:=True:C214  //skip
					EMAIL_Sender("WMS_aMs_EXPORTS TO Location"; ""; "Check transaction "+String:C10([WMS_aMs_Exports:153]id:1))
					
				: ([WMS_aMs_Exports:153]TypeCode:2=100)  //create new case
					//execute a receipt if its interesting
					$successful:=FG_wms_receive(->sCriterion3)  // (2)
					
				: ([WMS_aMs_Exports:153]TypeCode:2=150)  //adjust super case
					If (Position:C15("ship"; sCriterion4)=0)  // Modified by: Mel Bohince (10/24/18) don't adjust if location is a staging area
						// because the revlon scenario will bill out the delta and the adjusted skid will be put-away at the lessor qty with the blue label
						$successful:=True:C214
						$numFGL:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
						If ($numFGL=0) & (rReal1>0)
							FG_makeLocation
							
						Else 
							If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
								utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Locked F/G Location "+$fgKey)
								$successful:=False:C215
							End if 
						End if 
						[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+rReal1
						If ([Finished_Goods_Locations:35]QtyOH:9#0)
							[Finished_Goods_Locations:35]ModDate:21:=dDate
							[Finished_Goods_Locations:35]ModWho:22:=<>zResp
							//[Finished_Goods_Locations]Cases:=[Finished_Goods_Locations]Cases+wms_number_cases
							SAVE RECORD:C53([Finished_Goods_Locations:35])
						Else 
							If (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29))
								DELETE RECORD:C58([Finished_Goods_Locations:35])
							End if 
						End if 
						If ($successful)
							FGX_post_transaction(dDate; 1; "Adjust"; tTime)
						End if 
						//$successful:=FG_wms_receive (->sCriterion3)  ` (2)
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							UNLOAD RECORD:C212([Finished_Goods_Locations:35])
							REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
							
						Else 
							
							REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
							
						End if   // END 4D Professional Services : January 2019 
						
					Else 
						$successful:=True:C214  // Modified by: Mel Bohince (11/26/18) so this clears
					End if 
					
				: ([WMS_aMs_Exports:153]TypeCode:2=200) | ([WMS_aMs_Exports:153]TypeCode:2=350)  //Update aMs Location or  `Add case to skid
					//execute a move if its interesting
					$successful:=FG_wms_move
					
				: ([WMS_aMs_Exports:153]TypeCode:2=300)  //Assign Case or Skid to a Release
					//tag the fg inventory with a bol-pending
					//tell the bol that picking has started
					//tell the bol's releases their counts
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=[WMS_aMs_Exports:153]Release_Number:8)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
						READ WRITE:C146([Customers_Bills_of_Lading:49])
						QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=[Customers_ReleaseSchedules:46]B_O_L_pending:45)
						If (Records in selection:C76([Customers_Bills_of_Lading:49])=1)
							
							If (BLOB size:C605([Customers_Bills_of_Lading:49]BinPicks:27)>0)
								[Customers_Bills_of_Lading:49]Status:32:="Picking"
								BOL_ListBox1("restore-from-blob")
								release_number:=[WMS_aMs_Exports:153]Release_Number:8
								$hit:=Find in array:C230(aReleases; release_number)
								If ($hit>-1)
									//count cases for each packcount 'qty_in_case
									//make additional release lines for multi case count
									//count number of skids 'skid_numb   er
									//get the ams fglocation record number 'ams_location
									If (wms_api_get_cases_by_release(release_number)>0)
										BOL_ListBox1("wms-to-bol")
										BOL_ListBox1("get-totals")
										BOL_ListBox1("save-to-blob")
										SAVE RECORD:C53([Customers_Bills_of_Lading:49])
										UNLOAD RECORD:C212([Customers_Bills_of_Lading:49])
										$successful:=True:C214
									Else 
										utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Release "+String:C10([WMS_aMs_Exports:153]Release_Number:8)+" couldn't be evaluated in WMS.")
									End if 
									
								Else   //bol doesn't have htat release
									utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"BOL# doesn't have release "+String:C10([WMS_aMs_Exports:153]Release_Number:8)+" listed.")
								End if 
							End if   //blob
							
						Else   //bol not found
							utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Release BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_pending:45))
						End if 
						
					Else   //release not found
						utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Release "+String:C10([WMS_aMs_Exports:153]Release_Number:8)+" was not found.")
					End if 
					
				: ([WMS_aMs_Exports:153]TypeCode:2=400)  //return
					
				: ([WMS_aMs_Exports:153]TypeCode:2=450)  //Remove case from skid
					//find the skid in that location and decrement the number of cases
					READ WRITE:C146([Finished_Goods_Locations:35])
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=sCriterion4; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43=sCriter10)
					If (Records in selection:C76([Finished_Goods_Locations:35])=1)
						[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24-1
						SAVE RECORD:C53([Finished_Goods_Locations:35])
						UNLOAD RECORD:C212([Finished_Goods_Locations:35])
						$successful:=True:C214
					Else 
						$successful:=True:C214
						utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Pallet "+sCriter10+" was not found, cases not decremented.")
					End if 
					
				: ([WMS_aMs_Exports:153]TypeCode:2=500)  //Release/Ship a Release/BOL
					//tell the bol its ready
					READ WRITE:C146([Customers_Bills_of_Lading:49])
					QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=[WMS_aMs_Exports:153]BOL_Number:7)
					If (Records in selection:C76([Customers_Bills_of_Lading:49])=1)
						If (Not:C34(Locked:C147([Customers_Bills_of_Lading:49])))
							[Customers_Bills_of_Lading:49]Status:32:="Ready"
							SAVE RECORD:C53([Customers_Bills_of_Lading:49])
							UNLOAD RECORD:C212([Customers_Bills_of_Lading:49])
							$successful:=True:C214
						Else 
							utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+String:C10([WMS_aMs_Exports:153]id:1)+": "+"BOL# "+String:C10([WMS_aMs_Exports:153]BOL_Number:7)+" was locked, type 500.")
							UNLOAD RECORD:C212([Customers_Bills_of_Lading:49])
						End if 
						
					Else 
						$successful:=False:C215
						utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"BOL# "+String:C10([WMS_aMs_Exports:153]BOL_Number:7)+" was not found, type 500.")
					End if 
					
				Else   //unknown
					$successful:=False:C215
					utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"[WMS_aMs_Exports]TypeCode = "+String:C10([WMS_aMs_Exports:153]TypeCode:2)+" was not understood.")
			End case 
			
			If ($successful)
				[WMS_aMs_Exports:153]StateIndicator:3:="X"
				SAVE RECORD:C53([WMS_aMs_Exports:153])
			End if 
			
		Else   //special scanner login ams:ams used to prevent changes to ams
			[WMS_aMs_Exports:153]StateIndicator:3:="-"
			SAVE RECORD:C53([WMS_aMs_Exports:153])
		End if 
		
	Else 
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": Locked")
		EMAIL_Sender("WMS_aMs_EXPORTS LOCKED"; ""; "Check the batchmac")
	End if   //locked
	
	NEXT RECORD:C51([WMS_aMs_Exports:153])
	uThermoUpdate($i)
End for 
<>zResp:=$loginInitials  //restore the login
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([WMS_aMs_Exports:153])
	
	
Else 
	
	// see line 204
	
	
End if   // END 4D Professional Services : January 2019 
uThermoClose