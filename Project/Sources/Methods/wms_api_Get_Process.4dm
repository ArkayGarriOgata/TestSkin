//%attributes = {}
// Method: wms_api_Get_Process
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/24/08, 09:21:57
// ----------------------------------------------------
// Description
// spawn a process to get the wms transactions and process them
// Parameters
// Modified by: Mel Bohince (11/18/12)added the & sign to compound search prior to deletions
// Modified by: Mel Bohince (8/30/21) change stack to <>lBigMemPart
// ----------------------------------------------------

C_LONGINT:C283($1; $loop_interval; $numberImported; <>WMS_GET_PID; $delay_in_minutes; <>WMS_ERROR)
C_TEXT:C284($2; $which; $which_transactions)

If (Count parameters:C259=0)
	If (<>WMS_GET_PID=0)
		<>WMS_ERROR:=0
		uConfirm("Do a one time check or loop forever?"; "Once"; "Loop")
		zwStatusMsg("HINT"; "100=receipt,150=adj,200=move,300=pick,400=return,500=ship, all ,move,or pick")
		If (ok=1)
			$which:=Request:C163("Which transactions"; "100"; "Import"; "Cancel")
			If (ok=1)
				<>WMS_GET_PID:=New process:C317("wms_api_Get_Process"; <>lBigMemPart; "wms_api_Get_Process"; 0; $which)
				If (False:C215)
					wms_api_Get_Process
				End if 
				
			End if 
		Else 
			$which:=Request:C163("Which transactions"; "all"; "Continue"; "Cancel")
			If (ok=1)
				$delay_in_minutes:=Num:C11(Request:C163("How many minutes between loops?"; "5"; "OK"; "Cancel"))
				If (ok=1)
					C_TEXT:C284($r)
					$r:=Char:C90(13)
					$msg:="Poling for WMS to aMs Transactions"+$r
					$msg:=$msg+"Mode = "+" Loop"+$r
					$msg:=$msg+"Interval = "+String:C10($delay_in_minutes)+" minutes"+$r
					$msg:=$msg+"Transactions = "+$which+$r
					//util_FloatingAlert ($msg)
					zwStatusMsg("WMS_GET"; $which+" transactions, every "+String:C10($delay_in_minutes)+" minutes")
					<>WMS_GET_PID:=New process:C317("wms_api_Get_Process"; <>lMidMemPart; "wms_api_Get_Process"; 60*60*$delay_in_minutes; $which)
				End if 
			End if 
		End if 
		
	Else 
		uConfirm("Only one instance of wms_api_Get_Process should be running at a time. Try restart"+"ing."; "OK"; "Help")
	End if 
	
Else 
	$loop_interval:=$1
	$which_transactions:=$2
	$numberImported:=0
	READ ONLY:C145([Job_Forms_Items_Costs:92])  // Modified by: Mel Bohince (3/9/21) 
	READ WRITE:C146([WMS_aMs_Exports:153])
	utl_Logfile("wms_api.log"; "*** WMS Sync started for "+$which_transactions+" transactions, interval of  "+String:C10($loop_interval/3600)+" minutes")
	
	Repeat 
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date.`v0.1.0-JJG (05/16/16) - added 
		<>WMS_ERROR:=0
		$accumulater:=0
		$numberImported:=wms_api_Get_Same_From_To
		If ($numberImported>0)
			utl_Logfile("wms_api.log"; "!!! "+String:C10($numberImported)+" same from/to ignored")
		End if 
		
		Case of 
			: ($which_transactions="receipt") | (Num:C11($which_transactions)=100)
				zwStatusMsg("IMPORTING"; "100=receipt")
				//$numberImported:=wms_api_Get_aMs_Transactions ("100")
				$numberImported:=wms_api_Get_Receipts
				
			: ($which_transactions="adjust") | (Num:C11($which_transactions)=150)
				zwStatusMsg("IMPORTING"; "150=adjust")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("150")
				
			: ($which_transactions="move") | (Num:C11($which_transactions)=200)
				zwStatusMsg("IMPORTING"; "200=move")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("200")
				$accumulater:=$accumulater+$numberImported
				
				zwStatusMsg("IMPORTING"; "350=addcase")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("350")
				$accumulater:=$accumulater+$numberImported
				
				zwStatusMsg("IMPORTING"; "400=return")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("400")
				$accumulater:=$accumulater+$numberImported
				
				zwStatusMsg("IMPORTING"; "450=rmcase")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("450")
				$accumulater:=$accumulater+$numberImported
				$numberImported:=$accumulater
				
			: ($which_transactions="pick")
				zwStatusMsg("IMPORTING"; "300=pick")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("300")
				$accumulater:=$accumulater+$numberImported
				
				zwStatusMsg("IMPORTING"; "500=ship")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("500")
				$accumulater:=$accumulater+$numberImported
				$numberImported:=$accumulater
				
			: ($which_transactions="all")
				// Modified by: Mel Bohince (11/15/12), test for duplicate id's before import to make recovery possible
				ALL RECORDS:C47([WMS_aMs_Exports:153])
				ARRAY LONGINT:C221(aExsistingTransactions; 0)
				SELECTION TO ARRAY:C260([WMS_aMs_Exports:153]id:1; aExsistingTransactions)
				
				zwStatusMsg("IMPORTING"; "100=receipt")
				$numberImported:=wms_api_Get_Receipts
				$accumulater:=$accumulater+$numberImported
				
				zwStatusMsg("IMPORTING"; "200=move")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("200")
				$accumulater:=$accumulater+$numberImported
				
				
				// Modified by: Mel Bohince (10/24/18) reactivate 150 type transactions
				zwStatusMsg("IMPORTING"; "150=adjust")
				$numberImported:=$numberImported+wms_api_Get_aMs_Transactions("150")
				$accumulater:=$accumulater+$numberImported
				
				//zwStatusMsg ("IMPORTING";"300=pick")
				//$numberImported:=$numberImported+wms_api_Get_aMs_Transactions ("300")
				//$accumulater:=$accumulater+$numberImported
				//zwStatusMsg ("IMPORTING";"350=addcase")
				//$numberImported:=$numberImported+wms_api_Get_aMs_Transactions ("350")
				//$accumulater:=$accumulater+$numberImported
				//zwStatusMsg ("IMPORTING";"400=return")
				//$numberImported:=$numberImported+wms_api_Get_aMs_Transactions ("400")
				//$accumulater:=$accumulater+$numberImported
				//zwStatusMsg ("IMPORTING";"450=rmcase")
				//$numberImported:=$numberImported+wms_api_Get_aMs_Transactions ("450")
				//$accumulater:=$accumulater+$numberImported
				//zwStatusMsg ("IMPORTING";"500=ship")
				//$numberImported:=$numberImported+wms_api_Get_aMs_Transactions ("500")
				//$accumulater:=$accumulater+$numberImported
				$numberImported:=$accumulater
				
			Else 
				uConfirm("'"+$which+"' was not understood"; "OK"; "Help")
		End case 
		
		If ($numberImported>0)
			utl_Logfile("wms_api.log"; "!!!  "+String:C10($numberImported)+" transactions imported")
		End if 
		
		If ($loop_interval>0)
			wms_api_process_transactions
			
		Else 
			If ($numberImported>0)
				uConfirm("Process the "+String:C10($numberImported)+" transactions now?"; "Yes"; "No")
				If (ok=1)
					wms_api_process_transactions
				End if 
				
			Else 
				QUERY:C277([WMS_aMs_Exports:153]; [WMS_aMs_Exports:153]StateIndicator:3="S")
				If (Records in selection:C76([WMS_aMs_Exports:153])>0)
					uConfirm("Process the PRIOR transactions now?"; "Yes"; "No")
					If (ok=1)
						wms_api_process_transactions
					End if 
				End if 
			End if 
		End if 
		
		//remove old ones
		$daysToKeep:=14  // Added by: Mel Bohince (1/17/20) 
		
		QUERY:C277([WMS_aMs_Exports:153]; [WMS_aMs_Exports:153]StateIndicator:3="X"; *)
		QUERY:C277([WMS_aMs_Exports:153];  & ; [WMS_aMs_Exports:153]TransDate:4<(4D_Current_date-$daysToKeep))  // Modified by: Mel Bohince (11/18/12)added the & sign to compound search
		If (Records in selection:C76([WMS_aMs_Exports:153])>0)
			utl_Logfile("wms_api.log"; "^^^  "+String:C10(Records in selection:C76([WMS_aMs_Exports:153]))+" deleted from prior to "+String:C10((4D_Current_date-$daysToKeep); System date short:K1:1))
			$locks:=util_DeleteSelection(->[WMS_aMs_Exports:153])
		End if 
		REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
		zwStatusMsg("WMS_GET"; "Pausing for "+String:C10($loop_interval/60/60)+" minutes at "+String:C10(Current time:C178; HH MM SS:K7:1))
		<>WMS_ERROR:=0
		DELAY PROCESS:C323(Current process:C322; $loop_interval)
		If (<>fQuit4D) | (Not:C34(<>run_wms))
			$loop_interval:=0
		End if 
	Until ($loop_interval=0)
	<>WMS_GET_PID:=0
	<>WMS_ERROR:=0
	utl_Logfile("wms_api.log"; "*** WMS Sync Stopped")
	//util_FloatingAlert ("Stopped")
	//util_FloatingAlert ("")
	zwStatusMsg("WMS_GET"; "Stopped at "+String:C10(Current time:C178; HH MM SS:K7:1))
End if 