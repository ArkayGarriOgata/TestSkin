//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/18/07, 15:46:46
// ----------------------------------------------------
// Method: FGL_UpdateBinByTransaction(FGX-record-number{;fgx-id})
// Description
// update a bin based on a transaction record
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($1; $numFGL; $0)
$0:=0
C_TEXT:C284($fgx_id; $2)
C_BOOLEAN:C305($continue)
$continue:=False:C215


Case of 
	: (Count parameters:C259=0)
		$continue:=True:C214  //called by trigger
		
	: (Count parameters:C259=1)
		READ ONLY:C145([Finished_Goods_Transactions:33])
		GOTO RECORD:C242($1)
		If (Records in selection:C76([Finished_Goods_Transactions:33])=1)
			$continue:=True:C214
		End if 
		
	: (Count parameters:C259=2)
		READ ONLY:C145([Finished_Goods_Transactions:33])
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionNum:24=$2)
		If (Records in selection:C76([Finished_Goods_Transactions:33])=1)
			$continue:=True:C214
		End if 
End case 

If ($continue)
	If ([Finished_Goods_Transactions:33]LocationFromRecNo:23>No current record:K29:2)
		[Finished_Goods_Transactions:33]TransactionFailed:25:=True:C214  //pessimist
		$numFGL:=FGL_qryBin([Finished_Goods_Transactions:33]Jobit:31; [Finished_Goods_Transactions:33]viaLocation:11; [Finished_Goods_Transactions:33]Skid_number:29)
		//GOTO RECORD([Finished_Goods_Locations];[Finished_Goods_Transactions]LocationFromRecNo)
		If ($numFGL>0)
			If (fLockNLoad(->[Finished_Goods_Locations:35]))  //see FGL_InventoryShipped
				[Finished_Goods_Transactions:33]TransactionFailed:25:=False:C215
				[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9-[Finished_Goods_Transactions:33]Qty:6
				//cleanup empty bins
				If (([Finished_Goods_Locations:35]QtyOH:9=0) & (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29)))  // & ($1<0)`•010296  MLB  UPR 1802
					DELETE RECORD:C58([Finished_Goods_Locations:35])
					
				Else 
					[Finished_Goods_Locations:35]ModDate:21:=[Finished_Goods_Transactions:33]ModDate:17
					[Finished_Goods_Locations:35]ModWho:22:=[Finished_Goods_Transactions:33]ModWho:18
					SAVE RECORD:C53([Finished_Goods_Locations:35])
					UNLOAD RECORD:C212([Finished_Goods_Locations:35])
				End if 
				
				If ([Finished_Goods_Transactions:33]XactionType:2="Move")  //search for TO bin {includes pay-use}
					$numFGL:=FGL_qryBin([Finished_Goods_Transactions:33]Jobit:31; [Finished_Goods_Transactions:33]Location:9; [Finished_Goods_Transactions:33]Skid_number:29)
					If ($numFGL=0)  //if it exists
						CREATE RECORD:C68([Finished_Goods_Locations:35])
						[Finished_Goods_Locations:35]ProductCode:1:=[Finished_Goods_Transactions:33]ProductCode:1
						[Finished_Goods_Locations:35]Location:2:=[Finished_Goods_Transactions:33]Location:9
						[Finished_Goods_Locations:35]JobForm:19:=Substring:C12([Finished_Goods_Transactions:33]Jobit:31; 1; 8)  // 
						[Finished_Goods_Locations:35]JobFormItem:32:=Num:C11(Substring:C12([Finished_Goods_Transactions:33]Jobit:31; 10; 2))  //5/4/95 upr 1490
						[Finished_Goods_Locations:35]CustID:16:=[Finished_Goods_Transactions:33]CustID:12
						[Finished_Goods_Locations:35]skid_number:43:=[Finished_Goods_Transactions:33]Skid_number:29
						[Finished_Goods_Locations:35]zCount:18:=1
						[Finished_Goods_Locations:35]OrigDate:27:=[Finished_Goods_Transactions:33]XactionDate:3
					End if 
					[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+[Finished_Goods_Transactions:33]Qty:6
					[Finished_Goods_Locations:35]ModDate:21:=[Finished_Goods_Transactions:33]ModDate:17
					[Finished_Goods_Locations:35]ModWho:22:=[Finished_Goods_Transactions:33]ModWho:18
					SAVE RECORD:C53([Finished_Goods_Locations:35])
					UNLOAD RECORD:C212([Finished_Goods_Locations:35])
				End if 
				
			Else   //bin record locked
				$0:=TriggerMessage_Set(-31000-Table:C252(->[Finished_Goods_Locations:35]); "[Finished_Goods_Locations] Locked")
				utl_Logfile("shipping.log"; "FGX-id: "+[Finished_Goods_Transactions:33]XactionNum:24+" CPN: "+[Finished_Goods_Transactions:33]ProductCode:1+" Bin Locked, FGL-Location:  "+[Finished_Goods_Transactions:33]viaLocation:11+" jobit: "+[Finished_Goods_Transactions:33]Jobit:31+" TYPE: "+[Finished_Goods_Transactions:33]XactionType:2)
			End if 
			
		Else 
			$0:=TriggerMessage_Set(-31000-Table:C252(->[Finished_Goods_Locations:35]); "[Finished_Goods_Locations] Missing")
			utl_Logfile("shipping.log"; "FGX-id: "+[Finished_Goods_Transactions:33]XactionNum:24+" CPN: "+[Finished_Goods_Transactions:33]ProductCode:1+" Bin N/F, FGL-Record# "+String:C10([Finished_Goods_Transactions:33]LocationFromRecNo:23)+" TYPE: "+[Finished_Goods_Transactions:33]XactionType:2)
		End if 
		
	Else   //missing bin record number
		$0:=TriggerMessage_Set(-31000-Table:C252(->[Finished_Goods_Locations:35]); "[Finished_Goods_Locations] Record# Unknown")
		utl_Logfile("shipping.log"; "FGX-id:  "+[Finished_Goods_Transactions:33]viaLocation:11+" CPN: "+[Finished_Goods_Transactions:33]ProductCode:1+" LocationFromRecNo not found "+" jobit: "+[Finished_Goods_Transactions:33]Jobit:31+" on FGX-id: "+[Finished_Goods_Transactions:33]XactionNum:24+" TYPE: "+[Finished_Goods_Transactions:33]XactionType:2)
	End if 
	
Else   //no continue
	$0:=TriggerMessage_Set(-31000-Table:C252(->[Finished_Goods_Transactions:33]); "[Finished_Goods_Transactions]XactionNum n/f")
	utl_Logfile("shipping.log"; "FGX-id: "+[Finished_Goods_Transactions:33]XactionNum:24+" Transaction record not found "+" CPN: "+[Finished_Goods_Transactions:33]ProductCode:1+" TYPE: "+[Finished_Goods_Transactions:33]XactionType:2)
End if 
