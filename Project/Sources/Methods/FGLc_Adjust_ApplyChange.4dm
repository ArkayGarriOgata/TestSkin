//%attributes = {}
//Method:  FGLC_Adjust_ApplyChange
//Description:  This method will apply changes
//See:  FGLc_Adjust_LoadLocation and FGLc_Adjust_Reason (for process variables)

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nLocation; $nNumberOfLocations)
	
	C_BOOLEAN:C305($bDeleteSuccess)
	C_BOOLEAN:C305($bQuantitySuccess)
	
	C_TEXT:C284($tJobIt; $tLocation; $tProductCode)
	C_TEXT:C284($tPk_Id)
	
	$nNumberOfLocations:=Size of array:C274(FGLc_abLoc_Delete)
	
	$bDeleteSuccess:=True:C214
	$bQuantitySuccess:=True:C214
	
End if   //Done Initialize

For ($nLocation; 1; $nNumberOfLocations)  //Loop thru deletes
	
	$tPk_Id:=FGLc_atLoc_Pk_id{$nLocation}
	
	Case of   //Deleted
			
		: (Not:C34(FGLc_abLoc_Delete{$nLocation}))
			
		: (Not:C34(Core_Query_UniqueRecordB(->[Finished_Goods_Locations:35]pk_id:45; ->$tPk_Id)))
			
		: (Not:C34(fLockNLoad(->[Finished_Goods_Locations:35])))
			
			$nLocation:=$nNumberOfLocations+1
			$bDeleteSuccess:=False:C215
			
		Else 
			
			$tJobIt:=[Finished_Goods_Locations:35]Jobit:33
			$tProductCode:=[Finished_Goods_Locations:35]ProductCode:1
			$tLocation:=[Finished_Goods_Locations:35]Location:2
			
			DELETE RECORD:C58([Finished_Goods_Locations:35])
			
	End case   //Done deleted 
	
End for   //Done looping thru deletes

If ($bDeleteSuccess)
	FGCreateTransaction($tJobIt; $tProductCode; $tLocation; "Deleted"; FGLC_tAdjust_Reason)
End if 

For ($nLocation; 1; $nNumberOfLocations)  //Loop thru quantity changes
	
	$tPk_Id:=FGLc_atLoc_Pk_id{$nLocation}
	
	Case of   //Quantity
			
		: (FGLc_abLoc_Delete{$nLocation})  //Marked to delete so ignore it
			
		: (FGLc_anLoc_OriginalQty{$nLocation}=FGLc_anLoc_Qty{$nLocation})  //No change
			
		: (Not:C34(Core_Query_UniqueRecordB(->[Finished_Goods_Locations:35]pk_id:45; ->$tPk_Id)))
			
		: (Not:C34(fLockNLoad(->[Finished_Goods_Locations:35])))
			
		Else   //Modify quantity
			
			[Finished_Goods_Locations:35]QtyOH:9:=FGLc_anLoc_Qty{$nLocation}
			
			$tJobIt:=[Finished_Goods_Locations:35]Jobit:33
			$tProductCode:=[Finished_Goods_Locations:35]ProductCode:1
			$tLocation:=[Finished_Goods_Locations:35]Location:2
			
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			
			FGCreateTransaction($tJobIt; $tProductCode; $tLocation; "Change Quantity"; FGLC_tAdjust_Reason)
			
	End case   //Done quantity 
	
End for   //Done looping thru quantity changes

FGLc_Adjust_Initialize(CorektPhaseInitialize)  //Start with new
