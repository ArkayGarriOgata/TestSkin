//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/13/07, 14:23:58
// ----------------------------------------------------
// Method: REL_ShippingCloseouts
// Description
// make sure shipped releases are closed and DR's are created when needed
// ----------------------------------------------------
// Modified by: Mel Bohince (1/16/14) factor in returns 

C_TEXT:C284($1; process_name)
READ WRITE:C146([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_Orders:40])
C_LONGINT:C283($rel; $numRels; $days; $variance)

process_name:="REL_ShippingCloseouts"

Case of 
	: ($1="init")
		While (Not:C34(<>fQuit4D))
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
			$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				CREATE SET:C116([Customers_ReleaseSchedules:46]; "ClosingReleases")
				
			Else 
				
				ARRAY LONGINT:C221($_ClosingReleases; 0)
				LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_ClosingReleases)
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			If ($numRels>0)
				utl_Logfile("shipping.log"; "REL_ShippingCloseouts Check: "+String:C10($numRels)+" candidates")
			End if 
			
			For ($rel; 1; $numRels)
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
					
					USE SET:C118("ClosingReleases")
					GOTO SELECTED RECORD:C245([Customers_ReleaseSchedules:46]; $rel)
					
				Else 
					
					GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $_ClosingReleases{$rel})
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If (fLockNLoad(->[Customers_ReleaseSchedules:46]))  //else get it next time
					$variance:=[Customers_ReleaseSchedules:46]Sched_Qty:6-[Customers_ReleaseSchedules:46]Actual_Qty:8
					$days:=[Customers_ReleaseSchedules:46]Sched_Date:5-[Customers_ReleaseSchedules:46]Actual_Date:7
					Case of 
						: ($variance=0)  //no variance
							$commentQty:=" "
							REL_CloseRelease("REL_ShippingCloseout")  //break
							
						: ($variance>0)  //shipped short    
							$commentQty:=" short"
							REL_CloseRelease("REL_ShippingCloseout - SHIPPED SHORT")
							RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
							If ([Customers_ReleaseSchedules:46]LastRelease:20)  //next see if another shippment will be accepted by contract underrun
								
								If ([Customers_ReleaseSchedules:46]PayU:31#1)  //•062597  MLB  ignor pay-use releases
									
									$netShipped:=[Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35  // Modified by: Mel Bohince (1/16/14) factor in returns 
									$minOrdered:=[Customers_Order_Lines:41]Quantity:6-([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]UnderRun:26/100))
									If ($netShipped<$minOrdered)
										RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
										REL_CreateNewRel($variance; [Customers_Orders:40]ContractExpires:12)
									Else   //under run was met and we're stuck with it the excess if any.
										[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+"  , LAST RELEASE MET UNDER-RUN QTY!"
										SAVE RECORD:C53([Customers_ReleaseSchedules:46])
									End if 
									
								Else   //this is a payuse
									REL_CreateNewRel($variance)
								End if   //•062597  MLB  
								
							Else   //adjust or create last release
								//• 5/15/97 cs new code        
								REL_CreateNewRel($variance)  //Lena wants Dr always, plus to know if last Rel adjusted  - create Dr
								
							End if   //last release
							
						: ($variance<0)  //shipped over    
							$commentQty:=" over"
							REL_CloseRelease("REL_ShippingCloseout - OVER SHIPPED")
							If ([Customers_ReleaseSchedules:46]PayU:31#1)  //•062597  MLB  ignor pay-use releases 
								//If ([Customers_ReleaseSchedules]LastRelease)  `decide whether total was invoiced.
								If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
									QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
								End if 
								If (Not:C34([Customers:16]Pays_Overship:42))
									[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+" "+String:C10(Abs:C99($variance))+" units shipped free of charge."
									SAVE RECORD:C53([Customers_ReleaseSchedules:46])
									
									BOL_OverShipPolicy($variance)
								End if 
								
								//Else   `adjust last release if present
								//$orderLine:=[Customers_ReleaseSchedules]OrderLine
								//CUT NAMED SELECTION([Customers_ReleaseSchedules];"findLast")
								//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OrderLine=$orderLine;*)
								//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]LastRelease=True)
								//If (Records in selection([Customers_ReleaseSchedules])#0)  `no last release to adjust          
								//[Customers_ReleaseSchedules]Sched_Qty:=[Customers_ReleaseSchedules]Sched_Qty+$variance  `subtract out the overage
								//[Customers_ReleaseSchedules]OpenQty:=[Customers_ReleaseSchedules]Sched_Qty
								//[Customers_ReleaseSchedules]ModDate:=4D_Current_date
								//[Customers_ReleaseSchedules]ModWho:=◊zResp
								//SAVE RECORD([Customers_ReleaseSchedules])
								//End if 
								//USE NAMED SELECTION("findLast")
								//End if   `overship last release
								
							End if   //•062597  MLB  ignor pay-use releases 
							
					End case 
					
					Case of 
						: ($days<0)
							$commentDate:=" late"
						: ($days>0)
							$commentDate:=" early"
						Else 
							$commentDate:=""
					End case 
					
					If (($days#0) | ($variance#0))
						utl_Logfile("shipping.log"; "REL_ShippingCloseouts Check: "+String:C10($rel)+") "+[Customers_ReleaseSchedules:46]ProductCode:11+" "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" variance: "+String:C10($variance)+" units"+$commentQty+", "+String:C10($days)+" days"+$commentDate)
					End if 
				End if 
				
				//NEXT RECORD([Customers_ReleaseSchedules])` using goto selected record command
			End for 
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				CLEAR SET:C117("ClosingReleases")
				
				REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			Else 
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					
					REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
				End if 
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			
			DELAY PROCESS:C323(Current process:C322; 60*60*60)  //delay for an hour
		End while 
		
	: ($1="die!")
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			//SET PROCESS VARIABLE(server_pid;expireAt;0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "REL_ShippingCloseouts (die!) pid = "+String:C10(server_pid)+" called.")
End case 