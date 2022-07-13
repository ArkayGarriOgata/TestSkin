//%attributes = {"publishedWeb":true}
//PM: RM_AllocationTest(rmcode;jf) -> $hasStock=true | false
//@author mlb - 3/28/02  12:59
//there must be an open alloc for the job, else fail

C_BOOLEAN:C305($hasStock; $0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_REAL:C285($onhand)
C_LONGINT:C283($numAlloc; $i)

$hasStock:=False:C215

MESSAGES OFF:C175

If (Length:C16($1)>0) & (Length:C16($2)=8)
	READ ONLY:C145([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$1)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		$onhand:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
		
		READ ONLY:C145([Raw_Materials_Allocations:58])
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=$1; *)
		QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Qty_Issued:6=0)
		If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
			//calc the chronological balance      
			SELECTION TO ARRAY:C260([Raw_Materials_Allocations:58]JobForm:3; $aJF; [Raw_Materials_Allocations:58]Date_Allocated:5; $aDate; [Raw_Materials_Allocations:58]Qty_Allocated:4; $aQtyAlloc)
			$numAlloc:=Size of array:C274($aJF)
			ARRAY TEXT:C222($aSortKey; $numAlloc)
			For ($i; 1; $numAlloc)
				$aSortKey{$i}:=String:C10($aDate{$i}; Internal date short:K1:7)+$aJF{$i}
			End for 
			SORT ARRAY:C229($aSortKey; $aDate; $aJF; $aQtyAlloc; >)
			ARRAY TEXT:C222($aSortKey; 0)
			ARRAY LONGINT:C221($aBalance; $numAlloc)
			
			For ($i; 1; $numAlloc)
				$aBalance{$i}:=$onhand
				$onhand:=$onhand-$aQtyAlloc{$i}
			End for 
			
			//see if form in question will have a positive balance
			$i:=Find in array:C230($aJF; $2)
			If ($i>-1)
				If ($aBalance{$i}>=$aQtyAlloc{$i})
					$hasStock:=True:C214
				End if 
			End if 
			
		End if   //no open allocations for this code
	End if   //none onhand  
End if   //params

$0:=$hasStock