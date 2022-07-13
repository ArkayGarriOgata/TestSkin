//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldRawMaterials() -> 
//@author mlb - 7/3/02  14:00
// ///////////////////////////////////////
// /////// what about the status field?  10/10/04
// ///////////////////////////////////
// Modified by: Mel Bohince (6/21/16) revive the section for spec inks

READ WRITE:C146([Raw_Materials:21])
READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Raw_Materials_Locations:25])
READ ONLY:C145([Process_Specs_Materials:56])
MESSAGES OFF:C175
If (<>fContinue)
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7#"")
	ARRAY TEXT:C222($aHasBOM; 0)
	DISTINCT VALUES:C339([Job_Forms_Materials:55]Raw_Matl_Code:7; $aHasBOM)
	REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
End if 

If (<>fContinue)
	
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		$recent_Inventory:=ams_RecentRMInventory("all")
		USE SET:C118($recent_Inventory)
		DISTINCT VALUES:C339([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aHasINV)
		$recent_Inventory:=ams_RecentRMInventory
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		
	Else 
		
		READ ONLY:C145([Raw_Materials_Locations:25])
		ALL RECORDS:C47([Raw_Materials_Locations:25])
		DISTINCT VALUES:C339([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aHasINV)
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If (<>fContinue)
	QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13#"")
	ARRAY TEXT:C222($aHasSpec; 0)
	DISTINCT VALUES:C339([Process_Specs_Materials:56]Raw_Matl_Code:13; $aHasSpec)
	REDUCE SELECTION:C351([Process_Specs_Materials:56]; 0)
End if 

If (<>fContinue)  // Modified by: Mel Bohince (6/21/16) revive the section for spec inks
	QUERY:C277([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]InkNumber:3#"")
	ARRAY TEXT:C222($aHasOneUp; 0)
	DISTINCT VALUES:C339([Finished_Goods_Specs_Inks:188]InkNumber:3; $aHasOneUp)
	REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
End if 

If (<>fContinue)
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1#"")
	ARRAY TEXT:C222($aHasAlloc; 0)
	DISTINCT VALUES:C339([Raw_Materials_Allocations:58]Raw_Matl_Code:1; $aHasAlloc)
	REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
End if 

If (<>fContinue)
	ALL RECORDS:C47([Purchase_Orders_Items:12])
	ARRAY TEXT:C222($aHasPOI; 0)
	DISTINCT VALUES:C339([Purchase_Orders_Items:12]Raw_Matl_Code:15; $aHasPOI)
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
End if 

If (<>fContinue)
	ARRAY TEXT:C222($aRMcode; (Size of array:C274($aHasSpec)+Size of array:C274($aHasOneUp)+Size of array:C274($aHasAlloc)+Size of array:C274($aHasBOM)+Size of array:C274($aHasINV)+Size of array:C274($aHasPOI)))
	$rmCursor:=0
	
	For ($i; 1; Size of array:C274($aHasSpec))
		$hit:=Find in array:C230($aRMcode; $aHasSpec{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasSpec{$i}
		End if 
	End for 
	
	For ($i; 1; Size of array:C274($aHasOneUp))
		$hit:=Find in array:C230($aRMcode; $aHasOneUp{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasOneUp{$i}
		End if 
	End for 
	
	For ($i; 1; Size of array:C274($aHasAlloc))
		$hit:=Find in array:C230($aRMcode; $aHasAlloc{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasAlloc{$i}
		End if 
	End for 
	
	For ($i; 1; Size of array:C274($aHasBOM))
		$hit:=Find in array:C230($aRMcode; $aHasBOM{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasBOM{$i}
		End if 
	End for 
	
	For ($i; 1; Size of array:C274($aHasINV))
		$hit:=Find in array:C230($aRMcode; $aHasINV{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasINV{$i}
		End if 
	End for 
	
	For ($i; 1; Size of array:C274($aHasPOI))
		$hit:=Find in array:C230($aRMcode; $aHasPOI{$i})
		If ($hit=-1)
			$rmCursor:=$rmCursor+1
			$aRMcode{$rmCursor}:=$aHasPOI{$i}
		End if 
	End for 
	
	ARRAY TEXT:C222($aRMcode; $rmCursor)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY WITH ARRAY:C644([Raw_Materials:21]Raw_Matl_Code:1; $aRMcode)
		CREATE SET:C116([Raw_Materials:21]; "keepThese")
		
		ALL RECORDS:C47([Raw_Materials:21])
		CREATE SET:C116([Raw_Materials:21]; "allRecords")
		
		DIFFERENCE:C122("allRecords"; "keepThese"; "deleteThese")
		USE SET:C118("deleteThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		CLEAR SET:C117("deleteThese")
		
	Else 
		
		//see line 108
		
		ALL RECORDS:C47([Raw_Materials:21])
		
	End if   // END 4D Professional Services : January 2019 
	
	util_DeleteSelection(->[Raw_Materials:21])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Transactions:23]Raw_Matl_Code:1; ->[Raw_Materials:21]Raw_Matl_Code:1)
		
	Else 
		
		
		If (<>fContinue)
			
			READ ONLY:C145([Raw_Materials:21])
			ALL RECORDS:C47([Raw_Materials:21])
			READ WRITE:C146([Raw_Materials_Transactions:23])
			RELATE MANY SELECTION:C340([Raw_Materials_Transactions:23]Raw_Matl_Code:1)
			CREATE SET:C116([Raw_Materials_Transactions:23]; "keepThese")
			ALL RECORDS:C47([Raw_Materials_Transactions:23])
			CREATE SET:C116([Raw_Materials_Transactions:23]; "allRecords")
			DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
			USE SET:C118("keepThese")
			CLEAR SET:C117("allRecords")
			CLEAR SET:C117("keepThese")
			
			
			util_DeleteSelection(->[Raw_Materials_Transactions:23])
			
		End if 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Components:60]Parent_Raw_Matl:1; ->[Raw_Materials:21]Raw_Matl_Code:1)
		
	Else 
		
		
		If (<>fContinue)
			ARRAY TEXT:C222($_Raw_Matl_Code; 0)
			READ ONLY:C145([Raw_Materials:21])
			ALL RECORDS:C47([Raw_Materials:21])
			
			READ WRITE:C146([Raw_Materials_Components:60])
			DISTINCT VALUES:C339([Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Raw_Materials_Components:60]Parent_Raw_Matl:1; $_Raw_Matl_Code)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			ALL RECORDS:C47([Raw_Materials_Components:60])
			CREATE SET:C116([Raw_Materials_Components:60]; "allRecords")
			
			DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
			USE SET:C118("keepThese")
			CLEAR SET:C117("allRecords")
			CLEAR SET:C117("keepThese")
			
			util_DeleteSelection(->[Raw_Materials_Components:60])
			
		End if 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Components:60]Compnt_Raw_Matl:2; ->[Raw_Materials:21]Raw_Matl_Code:1)
		
	Else 
		
		If (<>fContinue)
			
			ARRAY TEXT:C222($_Raw_Matl_Code; 0)
			READ ONLY:C145([Raw_Materials:21])
			ALL RECORDS:C47([Raw_Materials:21])
			READ WRITE:C146([Raw_Materials_Components:60])
			DISTINCT VALUES:C339([Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Raw_Materials_Components:60]Compnt_Raw_Matl:2; $_Raw_Matl_Code)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			ALL RECORDS:C47([Raw_Materials_Components:60])
			CREATE SET:C116([Raw_Materials_Components:60]; "allRecords")
			DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
			USE SET:C118("keepThese")
			CLEAR SET:C117("allRecords")
			CLEAR SET:C117("keepThese")
			
			util_DeleteSelection(->[Raw_Materials_Components:60])
			
		End if 
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 