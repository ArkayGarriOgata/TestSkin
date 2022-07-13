//%attributes = {}
// -------
// Method: FG_ScrapQtyInLocation   ( ) ->
// By: Mel Bohince @ 06/02/16, 14:55:38
// Description
// because the kills are never scanned rite, find a way to make
// scrap transaction and delete bins
// ----------------------------------------------------
// Modified by: Mel Bohince (3/28/17) use fifo cost

READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods:26])

If (User in group:C338(Current user:C182; "RoleSuperUser"))
	QUERY:C277([Finished_Goods_Locations:35])
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	
	If ($numRecs>0)
		
		uConfirm("Delete the "+String:C10($numRecs)+" records after making Scrap transactions?"; "Delete"; "Keep")
		If (ok=1)
			
			$i:=0
			uThermoInit($numRecs; "Scrapping kills...")
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
				
				CREATE SET:C116([Finished_Goods_Locations:35]; "Kills")
				
			Else 
				
				ARRAY LONGINT:C221($_Kills; 0)
				LONGINT ARRAY FROM SELECTION:C647([Finished_Goods_Locations:35]; $_Kills)
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			For ($i; 1; $numRecs)
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
					
					USE SET:C118("Kills")
					
					READ WRITE:C146([Finished_Goods_Locations:35])
					GOTO SELECTED RECORD:C245([Finished_Goods_Locations:35]; $i)
					
					
				Else 
					
					READ WRITE:C146([Finished_Goods_Locations:35])
					GOTO RECORD:C242([Finished_Goods_Locations:35]; $_Kills{$i})
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				uThermoUpdate($i)
				
				FGX_NewFG_Transaction("sCrap"; Current date:C33; "wtf"; ?23:23:23?)
				[Finished_Goods_Transactions:33]ProductCode:1:=[Finished_Goods_Locations:35]ProductCode:1
				[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods_Locations:35]CustID:16  //
				
				[Finished_Goods_Transactions:33]JobNo:4:=Substring:C12([Finished_Goods_Locations:35]JobForm:19; 1; 5)
				[Finished_Goods_Transactions:33]JobForm:5:=[Finished_Goods_Locations:35]JobForm:19
				[Finished_Goods_Transactions:33]JobFormItem:30:=[Finished_Goods_Locations:35]JobFormItem:32  //•080495  MLB  UPR 1490
				[Finished_Goods_Transactions:33]OrderNo:15:=""
				[Finished_Goods_Transactions:33]OrderItem:16:=""
				
				[Finished_Goods_Transactions:33]Reason:26:="Reject"  //subject for reason-used in reporting, sorting, very uniform
				[Finished_Goods_Transactions:33]ReasonNotes:28:="Obsolete"
				[Finished_Goods_Transactions:33]ActionTaken:27:="Problem scanning kill"
				[Finished_Goods_Transactions:33]Qty:6:=[Finished_Goods_Locations:35]QtyOH:9
				[Finished_Goods_Transactions:33]Location:9:="SC:R_obsolete"
				[Finished_Goods_Transactions:33]viaLocation:11:=[Finished_Goods_Locations:35]Location:2
				[Finished_Goods_Transactions:33]Skid_number:29:=[Finished_Goods_Locations:35]skid_number:43
				
				//[Finished_Goods_Transactions]CoGSExtended:=JIC_Scrap (([Finished_Goods_Transactions]CustID+":"+[Finished_Goods_Transactions]ProductCode);[Finished_Goods_Transactions]Qty;->[Finished_Goods_Transactions]CoGSextendedMatl;->[Finished_Goods_Transactions]CoGSextendedLabor;->[Finished_Goods_Transactions]CoGSextendedBurden)
				//[Finished_Goods_Transactions]CoGS_M:=[Finished_Goods_Transactions]CoGSExtended/[Finished_Goods_Transactions]Qty*1000
				
				qryJMI([Finished_Goods_Locations:35]JobForm:19; [Finished_Goods_Transactions:33]JobFormItem:30)
				// Modified by: Mel Bohince (3/28/17) relieve the fifo
				[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Scrap(([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1); [Finished_Goods_Transactions:33]Qty:6; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
				If ([Finished_Goods_Transactions:33]Qty:6>0)
					[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/[Finished_Goods_Transactions:33]Qty:6*1000
				Else 
					[Finished_Goods_Transactions:33]CoGS_M:7:=0
				End if 
				
				qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)
				[Finished_Goods_Transactions:33]FG_Classification:22:=[Finished_Goods:26]ClassOrType:28
				
				SAVE RECORD:C53([Finished_Goods_Transactions:33])
				
			End for 
			uThermoClose
			
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
			
			
			READ WRITE:C146([Finished_Goods_Locations:35])
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
				
				USE SET:C118("Kills")
				util_DeleteSelection(->[Finished_Goods_Locations:35])
				CLEAR SET:C117("Kills")
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Locations:35]; $_Kills)
				
				util_DeleteSelection(->[Finished_Goods_Locations:35])
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			
		End if   //ok to proceed 
		
	Else 
		BEEP:C151
		ALERT:C41("None found")
	End if 
	
Else 
	uConfirm("Nope, not authorized.")
End if 

UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
UNLOAD RECORD:C212([Job_Forms_Items:44])
UNLOAD RECORD:C212([Job_Forms_Items_Costs:92])
UNLOAD RECORD:C212([Finished_Goods:26])