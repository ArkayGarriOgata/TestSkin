//%attributes = {"publishedWeb":true}
//Procedure: Batch_MTtoFG()  032097  MLB
//read machineTickets and create f/g transactions 
//if appropriate; see also gXferFGwip
//•022499  MLB  chg to have general purpose batch date file

C_LONGINT:C283(ilastMT; i1; ilastMT; $err)
C_DATE:C307(dDateBegin)

//*Check authorization and set semiphore
If (User in group:C338(Current user:C182; "WorkInProcess"))
	If (Not:C34(Semaphore:C143("BatchMachTicket")))
		//*Get the last time stamp processed
		NewWindow(150; 30; 4; -722; "Batching Machine Tickets to F/G")
		
		READ WRITE:C146([z_batch_run_dates:77])
		Repeat 
			$err:=Batch_RunDate("Get"; "MTtoFG"; ->dDateBegin; ->i1; ->ilastMT)
			If ($err=0)
				//*Find the most recent Machinetickets 
				READ ONLY:C145([Job_Forms_Machine_Tickets:61])
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>ilastMT)
				If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
					//*Record most recent timestamp
					ARRAY LONGINT:C221($aTimeStamp; 0)
					SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]TimeStampEntered:17; $aTimeStamp)
					SORT ARRAY:C229($aTimeStamp; <)
					ilastMT:=$aTimeStamp{1}
					ARRAY LONGINT:C221($aTimeStamp; 0)
					i1:=TSTimeStamp
					dDateBegin:=TS2Date(i1)
					$err:=Batch_RunDate("Set"; "MTtoFG"; ->dDateBegin; ->i1; ->ilastMT)
					//*include only those that processed f/g items
					QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4#0)
					If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
						ARRAY TEXT:C222($aJForm; 0)
						ARRAY LONGINT:C221($aQty; 0)
						ARRAY INTEGER:C220($aItem; 0)
						ARRAY DATE:C224($aDate; 0)
						ARRAY TEXT:C222($aCC; 0)
						SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobForm:1; $aJForm; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $aItem; [Job_Forms_Machine_Tickets:61]DateEntered:5; $aDate; [Job_Forms_Machine_Tickets:61]Good_Units:8; $aQty; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17; $aTimeStamp; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $aCC)
						//*Create a receipt transaction for each MT
						uThermoInit(Size of array:C274($aJForm); "Creating F/G transactions and CC inventory")
						For ($i; 1; Size of array:C274($aJForm))
							sCriterion5:=$aJForm{$i}  //[FG_Locations]JobForm
							i1:=$aItem{$i}  //[FG_Locations]JobFormItem  
							qryJMI(sCriterion5; i1)
							sCriterion1:=[Job_Forms_Items:44]ProductCode:3
							sCriterion2:=[Job_Forms_Items:44]CustId:15
							sCriterion6:=[Job_Forms_Items:44]OrderItem:2
							sCriterion9:="Batch_MT"  //[FG_Transactions]Reason  `subject for reason-used in reporting, sorting, very un
							sCriterion7:=String:C10($aDate{$i}; <>MIDDATE)
							sCriterion8:=""  //[FG_Transactions]ActionTaken
							rReal1:=$aQty{$i}  //[FG_Transactions]Qty
							//*    Differentiate between Haup and Roa transactions 
							sCriterion3:="WIP"
							//If (Position($aCC{$i};" 411 412 402 403 443 468 476 477 492 493 ")>0)  `processed in Roanoke
							sCriterion4:="CC:R"
							//Else 
							//sCriterion4:="CC:"
							//End if 
							sCriter10:=String:C10($aTimeStamp{$i})  //[FG_Transactions]SkidTicketNo
							$s:=FG_receive_from_WIP(1)
							
							uThermoUpdate($i)
						End for 
						uThermoClose
						
						ARRAY TEXT:C222($aJForm; 0)
						ARRAY LONGINT:C221($aQty; 0)
						ARRAY INTEGER:C220($aItem; 0)
						ARRAY DATE:C224($aDate; 0)
						ARRAY TEXT:C222($aCC; 0)
						ARRAY LONGINT:C221($aTimeStamp; 0)
						
					Else 
						BEEP:C151
						MESSAGE:C88("No F/G Machine Tickets to process.")
					End if 
					
				Else 
					BEEP:C151
					MESSAGE:C88("No Machine Tickets to process.")
				End if 
				
			Else 
				BEEP:C151
				MESSAGE:C88("Can't batch MachineTickets without prior batch date.")
			End if 
			
			If (<>fContinue)
				DELAY PROCESS:C323(Current process:C322; 32000)  //about 8 minutes
			End if 
			
		Until (Not:C34(<>fContinue))
		//*Clear semiphore
		CLEAR SEMAPHORE:C144("BatchMachTicket")
		CLOSE WINDOW:C154
		
	Else 
		BEEP:C151
		ALERT:C41("Someone else is currently batching Machine Tickets.")
	End if   //set semaphore
End if   //authorized
uWinListCleanup