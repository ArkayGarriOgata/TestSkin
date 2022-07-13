//%attributes = {}

// Method: wms_api_Send_Case ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/18/15, 12:34:56
// ----------------------------------------------------
// Description
// insert a case in to wms
// Modified by: Mel Bohince (2/18/16) `could be subform'd
//-------------------------------------------------
// Modified by: Mel Bohince (3/29/16) warehouse other than R creates problems
// Modified by: Mel Bohince (8/30/21) change stack to <>lBigMemPart

If (Count parameters:C259=0)
	//If (<>pid_=0)  //singleton
	$pid_:=New process:C317("wms_api_Send_Case"; <>lBigMemPart; "ADD CASE"; "init")
	If (False:C215)
		wms_api_Send_Case
	End if 
	
	
Else 
	Case of 
		: ($1="init")
			SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
			$WMS_TypeCode:=<>WMS_TypeCode  //this tell you whether coming from wms_palette>addcase or qa_palette>putawayproof  200 v 100
			wms_bin_id:=Request:C163("Scan 'To' Location (like BNVFG_1):"; ""; "Ok"; "Cancel")  //"BNRFG"
			If (ok=1)
				If (Substring:C12(wms_bin_id; 1; 2)="BN")  // Modified by: Mel Bohince (2/18/16) remove the R
					$continue:=True:C214
				Else   //not looking like a bin or location scan
					BEEP:C151
					$continue:=False:C215
				End if 
			Else   //cancel
				$continue:=False:C215
			End if 
			
			If ($continue)
				$warehouse:="R"  // Modified by: Mel Bohince (3/29/16) warehouse other than R creates problems// Substring(wms_bin_id;3;1)
				$ams_location:=Substring:C12(wms_bin_id; 4; 2)
				
				Case of 
					: (Position:C15("XC"; $ams_location)>0)
						$case_status_code:=350
						
					: (Position:C15("FG"; $ams_location)>0)
						$case_status_code:=100
						
					: (Position:C15("CC"; $ams_location)>0)
						$case_status_code:=1
						
					: (Position:C15("SC"; $ams_location)>0)
						$case_status_code:=400
						
					Else 
						$case_status_code:=500
				End case 
				
				Repeat 
					
					$case_id:=Request:C163("Scan CASE to "+wms_bin_id+":"; ""; "Ok"; "Cancel")
					If (ok=1)
						If (Length:C16($case_id)=22)
							$continue:=True:C214
							If (util_isNumeric($case_id))
								$continue:=True:C214
							Else 
								$continue:=False:C215
								uConfirm("Case Id's are all numbers. (jobit+7serial+6qty)"; "OK"; "Help")
							End if 
						Else   //not looking like a case
							uConfirm("Case Id's are 22 numeric characters. (jobit+7serial+6qty)"; "OK"; "Help")
							$continue:=False:C215
						End if 
					Else   //cancel
						$continue:=False:C215
					End if 
					
					
					If ($continue)
						$jobit:=WMS_CaseId($case_id; "jobit")
						$case_qty:=Num:C11(WMS_CaseId($case_id; "qty"))
						$numJMI:=qryJMI($jobit)
						If ($numJMI>0)  // Modified by: Mel Bohince (2/18/16) `could be subform'd
							wms_api_SendJobits
							
							$success:=wms_api_Send_Super_Case("initCase")
							If ($success)
								$jobit_stripped:=Substring:C12($case_id; 1; 9)
								$insert_datetime:=4D_Current_date
								$update_datetime:=4D_Current_date
								$success:=wms_api_Send_Super_Case("insertCase"; $case_id; $insert_datetime; $case_qty; $jobit_stripped; $case_status_code; $ams_location; wms_bin_id; $insert_datetime; $update_datetime; <>zResp; $warehouse)
								If ($success)
									zwStatusMsg("ADD CASE"; $case_id+" has been added to WMS in location "+wms_bin_id)
									
									If (Not:C34(<>PHYSICAL_INVENORY_IN_PROGRESS))  //update ams also
										//trick ams into processing transaction
										If ($WMS_TypeCode=100)
											sFrom:="wip"
										Else 
											sFrom:=""
										End if 
										
										CREATE RECORD:C68([WMS_aMs_Exports:153])
										[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])*-1
										[WMS_aMs_Exports:153]TypeCode:2:=$WMS_TypeCode
										[WMS_aMs_Exports:153]StateIndicator:3:="S"
										[WMS_aMs_Exports:153]TransDate:4:=$update_datetime
										[WMS_aMs_Exports:153]TransTime:5:=String:C10(4d_Current_time; HH MM SS:K7:1)
										[WMS_aMs_Exports:153]ModWho:6:=<>zResp
										[WMS_aMs_Exports:153]Jobit:9:=$jobit
										[WMS_aMs_Exports:153]BinId:10:=wms_bin_id
										[WMS_aMs_Exports:153]from_Bin_id:17:=sFrom  //"WIP"
										[WMS_aMs_Exports:153]ActualQty:11:=$case_qty
										[WMS_aMs_Exports:153]To_aMs_Location:12:=$ams_location
										[WMS_aMs_Exports:153]From_aMs_Location:13:=""
										[WMS_aMs_Exports:153]Skid_number:14:=""  //working with cases here, never a skid, i think ;-)
										[WMS_aMs_Exports:153]case_id:15:=$case_id
										[WMS_aMs_Exports:153]number_of_cases:16:=1
										[WMS_aMs_Exports:153]PostDate:18:=$update_datetime
										[WMS_aMs_Exports:153]PostTime:19:=String:C10(4d_Current_time; HH MM SS:K7:1)
										SAVE RECORD:C53([WMS_aMs_Exports:153])
										If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
											
											UNLOAD RECORD:C212([WMS_aMs_Exports:153])  // Modified by: Mel Bohince (9/9/15) 
											REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
											
										Else 
											
											REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
											
										End if   // END 4D Professional Services : January 2019 
										
									End if   //PhyInv
									
								Else 
									zwStatusMsg("ADD CASE"; $case_id+" FAILED")
								End if 
								
							Else 
								uConfirm("Could not connect to WMS database."; "OK"; "Help")
							End if   //connect wms
							
							$success:=wms_api_Send_Super_Case("kill")
							
						Else 
							uConfirm($jobit+" was not found in aMs."; "OK"; "Help")
						End if   //jobit
					End if   //ok
					
				Until (ok=0)
				
			End if   //ok
			
	End case 
	
End if   //params
