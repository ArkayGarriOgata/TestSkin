//%attributes = {}
// ----------------------------------------------------
// Method: RM_PostReceipt_SP   ( ) ->
// By: Mel Bohince @ 03/03/16, 13:18:56
// Description
// wait for records created by RM_PostReceipts and process until no 
// [Raw_Materials_Transactions]Xfer_State:="Pending" exist, changing to "Posted"
// ----------------------------------------------------
// Modified by: Mel Bohince (4/20/16) taken out of service, using old way cause clerk wants imediate feedback that an po had a receipt
// downside with old way is that if transaction gets cancelled, all the data entry is lost


READ WRITE:C146([Raw_Materials:21])
READ WRITE:C146([Purchase_Orders_Items:12])
READ ONLY:C145([Purchase_Orders_Job_forms:59])
READ ONLY:C145([Raw_Materials_Groups:22])
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])  //transactions already existing and is "pending", unless dp issue required
READ ONLY:C145([Job_Forms:42])
READ WRITE:C146([Job_Forms_Materials:55])

C_LONGINT:C283($i; $winRef; $numToPost; $numRM; $poItem; $numRMG; $server_pid)
C_BOOLEAN:C305($success)

C_LONGINT:C283($delay; $error; $server_pid; expireAt; $interval; $loop; $revolution)
process_name:="RM_PostReceipt_SP"

Case of 
	: ($1="init")
		$server_pid:=Process number:C372(process_name; *)
		If ($server_pid#0)
			
			expireAt:=1  //run until this var gets set to zero by a call with "die!" from the server
			$second:=60
			$delay:=60*$second  //Check for quit every 60 seconds, revolution 15 minute intervals
			$interval:=5
			$revolution:=1
			Repeat 
				//utl_Logfile ("RMX.log";"Revolution: "+String($revolution))
				//gather the needed records
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_State:33="Pending"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
				$numTransactions:=Records in selection:C76([Raw_Materials_Transactions:23])
				If ($numTransactions>0)
					$winRef:=NewWindow(300; 400; 6; Pop up window:K34:14; "Posting Receipts")
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
						
						CREATE SET:C116([Raw_Materials_Transactions:23]; "pendingTransactions")
						
						
					Else 
						
						ARRAY LONGINT:C221($_pendingTransactions; 0)
						LONGINT ARRAY FROM SELECTION:C647([Raw_Materials_Transactions:23]; $_pendingTransactions)
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					MESSAGE:C88("Posting "+String:C10($numTransactions)+" transactions\r")
					utl_Logfile("RMX.log"; "Revolution: "+String:C10($revolution)+" there are "+String:C10($numTransactions)+" transactions to post")
					For ($transaction; 1; $numTransactions)
						If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
							
							USE SET:C118("pendingTransactions")
							GOTO SELECTED RECORD:C245([Raw_Materials_Transactions:23]; $transaction)
							
						Else 
							
							GOTO RECORD:C242([Raw_Materials_Transactions:23]; $_pendingTransactions{$transaction})
							
						End if   // END 4D Professional Services : January 2019 query selection
						
						MESSAGE:C88("      Rec'r#"+String:C10([Raw_Materials_Transactions:23]ReceivingNum:23))
						QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)  //  //must have a valid r/m number
						$numRM:=Records in selection:C76([Raw_Materials:21])
						
						QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
						$numPO:=Records in selection:C76([Purchase_Orders_Items:12])
						
						$numRMG:=qryRMgroup([Raw_Materials:21]Commodity_Key:2; !00-00-00!)  //•081399  mlb  incase there are duplicates use latest one
						//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]Raw_Matl_Code=aRMCode{$i};*)
						
						//don't start if pieces cant be gathered and loaded
						Case of 
							: ($numRM<1)
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" RM not found")
								
							: ($numRM>1)
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" RM not unique")
								
							: (Not:C34(fLockNLoad(->[Raw_Materials:21])))
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" RM locked")
								
							: ($numPO<1)
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" POI not found")
								
							: (Not:C34(fLockNLoad(->[Purchase_Orders_Items:12])))
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" POI locked")
								
							: ($numRMG<1)
								utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" RMG not found")
								//just skip this record for this revolution
								
							Else 
								MESSAGE:C88("    Posting receiver "+String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+"as type "+String:C10([Raw_Materials_Groups:22]ReceiptType:13)+"\r")
								START TRANSACTION:C239
								$success:=True:C214  //optimistic
								
								[Raw_Materials:21]LastPurDate:44:=[Raw_Materials_Transactions:23]XferDate:3
								SAVE RECORD:C53([Raw_Materials:21])
								
								//fill in some missing data on the transaction
								[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
								[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
								[Raw_Materials_Transactions:23]CompanyID:20:=[Purchase_Orders_Items:12]CompanyID:45
								[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
								[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
								[Raw_Materials_Transactions:23]consignment:27:=[Purchase_Orders_Items:12]Consignment:49
								SAVE RECORD:C53([Raw_Materials_Transactions:23])  //RM_MillRelieveInventory callsed later may reload it
								
								Case of 
									: ([Raw_Materials_Groups:22]ReceiptType:13=1)  //inventoried item
										$success:=RM_receive_inventory  //update the bin and po item
										
									: ([Raw_Materials_Groups:22]ReceiptType:13=2)  //direct purchase   
										$success:=RM_receive_direct_purchase
										
									: ([Raw_Materials_Groups:22]ReceiptType:13=3)  //expense item  
										$success:=RM_receive_expense_item
										
									Else   //no valid receipt type
										$success:=False:C215
										MESSAGE:C88("Receipt Type could not be determined for "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+". Its receipt was not recorded.\r")
								End case   //receipt type
								
								If ($success)
									[Raw_Materials_Transactions:23]Xfer_State:33:="Posted"
									SAVE RECORD:C53([Raw_Materials_Transactions:23])
									
									
									VALIDATE TRANSACTION:C240
									utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" as type "+String:C10([Raw_Materials_Groups:22]ReceiptType:13)+" OK")
									MESSAGE:C88("OK \r")
									
								Else 
									CANCEL TRANSACTION:C241
									utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" as type "+String:C10([Raw_Materials_Groups:22]ReceiptType:13)+" NOGO")
									MESSAGE:C88("NOGO \r")
								End if 
								
								UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
								UNLOAD RECORD:C212([Purchase_Orders_Items:12])
								UNLOAD RECORD:C212([Purchase_Orders_Job_forms:59])
								UNLOAD RECORD:C212([Raw_Materials_Locations:25])
								UNLOAD RECORD:C212([Raw_Materials:21])
								
						End case   //attempt made
						
					End for 
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
						
						CLEAR SET:C117("pendingTransactions")
						
						
					Else 
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					CLOSE WINDOW:C154($winRef)
				End if   //transactions to post
				
				//mail on failures
				//QUERY([Raw_Materials_Transactions];[Raw_Materials_Transactions]Xfer_State="Error")
				//If (Records in selection([Raw_Materials_Transactions])>0)
				//$winRef:=NewWindow (300;400;6;Pop up window;"Reporting Errors")
				//utl_Logfile ("RMX.log";String(Records in selection([Raw_Materials_Transactions]))+" Error'd RMX records")
				//CLOSE WINDOW($winRef)
				//End if 
				
				///////////////////////////////////
				///////////////////////////////////
				$loop:=0
				While (expireAt>0) & ($loop<$interval)  //keep running, delay 15 times for a minute
					DELAY PROCESS:C323(Current process:C322; $delay)  // minute
					$loop:=$loop+1
				End while 
				
				$revolution:=$revolution+1
			Until (<>fQuit4D)
			
		Else 
			utl_Logfile("RMX.log"; process_name+" already running as pid "+String:C10($server_pid))
		End if   //not currently running
		
	: ($1="die!")  //called by On Server Shutdown
		$server_pid:=Process number:C372(process_name; *)
		If ($server_pid#0)
			SET PROCESS VARIABLE:C370($server_pid; expireAt; 0)
			DELAY PROCESS:C323($server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "RM_PostReceipt_SP (die!) pid = "+String:C10(server_pid)+" called.")
		
End case 
