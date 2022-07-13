//%attributes = {"publishedWeb":true}
//PM: JML_StatusFromMachineTickets({jobform}) -> 
//@author mlb - 7/17/01  13:23
//• mlb - 1/28/02  16:13 switch to manual method on press schdule
//• mlb - 6/5/02  09:30 don't set the sheeted date
//• mlb - 8/15/02  13:11 don't set the GlueReady date

C_TEXT:C284($jobform; $1)

If (Count parameters:C259=1)
	$jobform:=$1
	If (Length:C16($jobform)=8)
		READ WRITE:C146([Job_Forms_Master_Schedule:67])
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
	Else 
		$jobform:=""
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		BEEP:C151
		zwStatusMsg("ERROR"; "JML_StatusFromMachineTickets's parameter must have 8 characters")
	End if 
Else 
	$jobform:=[Job_Forms_Master_Schedule:67]JobForm:4
End if 
//zwStatusMsg ("Status";$jobform+"'s Machine Tickets")
//*Get the Jobs status via MachineTickets
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$jobform)
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
	C_BOOLEAN:C305($wasSet)
	$wasSet:=False:C215
	SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $aCC; [Job_Forms_Machine_Tickets:61]DateEntered:5; $aDateMT)
	For ($wc; 1; Size of array:C274($aCC))
		Case of 
			: (Position:C15($aCC{$wc}; <>PRESSES)>0)
				//• mlb - 1/28/02  16:13 switch to manual method on press schdule                
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]Printed;$aDateMT{$wc})
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateStockRecd:17; $aDateMT{$wc})
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DateStockSheeted;$aDateMT{$wc})
				//If ($aCC{$wc}#"417")
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagApproved:49; $aDateMT{$wc})
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagReceived:48; $aDateMT{$wc})
				//End if 
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DatePlatesRecd;$aDateMT{$wc})
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DateInkRecd;$aDateMT{$wc})
				If (False:C215)
					[Job_Forms_Master_Schedule:67]Operations:36:=Replace string:C233([Job_Forms_Master_Schedule:67]Operations:36; $aCC{$wc}+" "; $aCC{$wc}+"*")
				End if 
				
			: (Position:C15($aCC{$wc}; " 401 402 403 ")>0)
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DatePlatesRecd:39; $aDateMT{$wc})
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagApproved:49; $aDateMT{$wc})
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagReceived:48; $aDateMT{$wc})
				
			: (Position:C15($aCC{$wc}; <>BLANKERS)>0)
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]GlueReady;$aDateMT{$wc})
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DateDiesStampingRecd
				//«;$aDateMT{$wc})
				
			: (Position:C15($aCC{$wc}; <>STAMPERS)>0)
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DateDiesStampingRecd
				//«;$aDateMT{$wc})
				
			: (Position:C15($aCC{$wc}; <>SHEETERS)>0)
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateStockRecd:17; $aDateMT{$wc})
				//$wasSet:=util_setDateIfNull (->[JobMasterLog]DateStockSheeted;$aDateMT{$wc})
		End case 
		
	End for 
End if 
//