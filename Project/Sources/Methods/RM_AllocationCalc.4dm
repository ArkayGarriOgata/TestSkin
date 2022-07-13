//%attributes = {"publishedWeb":true}
//PM:  RM_AllocationCalc  110999  mlb
//calculate future balance at current time
//return true if supply is greater than demand
//formerly  `fAllocationCalc  12/7/94 so it matches the allocation report
//•031897  MLB  use arrays
// Modified by: MelvinBohince (2/23/22) change ARRAY REAL($aAlloc;0) ARRAY REAL($aIssued;0) to real 

C_TEXT:C284($1)  //=the rm code
C_BOOLEAN:C305($0)  //=the available qty for that r/m
C_LONGINT:C283($i)

READ ONLY:C145([Purchase_Orders_Items:12])

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=$1; *)
QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	ARRAY REAL:C219($aQty; 0)
	ARRAY REAL:C219($aNum; 0)
	ARRAY REAL:C219($aDenom; 0)
	SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Open:27; $aQty; [Purchase_Orders_Items:12]FactNship2cost:29; $aNum; [Purchase_Orders_Items:12]FactDship2cost:37; $aDenom)
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	iOnOrder:=0
	For ($i; 1; Size of array:C274($aQty))
		iOnOrder:=iOnOrder+($aQty{$i}*($aDenom{$i}/$aNum{$i}))
	End for 
	ARRAY REAL:C219($aQty; 0)
	ARRAY REAL:C219($aNum; 0)
	ARRAY REAL:C219($aDenom; 0)
	//iOnOrder:=Sum([PO_ITEMS]QtyOpen)*([PO_ITEMS]FactNship2cost/[PO_ITEMS
	//«]FactDship2cost)
Else 
	iOnOrder:=0
End if 

READ ONLY:C145([Raw_Materials_Locations:25])
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$1)
If (Records in selection:C76([Raw_Materials_Locations:25])>0)
	ARRAY REAL:C219($aQty; 0)
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]QtyOH:9; $aQty)
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	iOnHand:=0
	For ($i; 1; Size of array:C274($aQty))
		iOnHand:=iOnHand+$aQty{$i}
	End for 
	ARRAY REAL:C219($aQty; 0)
	//iOnHand:=Sum([RM_BINS]QtyOH)
Else 
	iOnHand:=0
End if 

iAllocated:=0
iIssued:=0
QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=$1)
//FIRST RECORD([RM_Allocations])
If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
	ARRAY REAL:C219($aAlloc; 0)  // Modified by: MelvinBohince (2/23/22) change ARRAY REAL($aAlloc;0) ARRAY REAL($aIssued;0) to real 
	ARRAY REAL:C219($aIssued; 0)
	SELECTION TO ARRAY:C260([Raw_Materials_Allocations:58]Qty_Allocated:4; $aAlloc; [Raw_Materials_Allocations:58]Qty_Issued:6; $aIssued)
	REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
	For ($i; 1; Size of array:C274($aAlloc))
		If ($aAlloc{$i}>$aIssued{$i})
			iAllocated:=iAllocated+$aAlloc{$i}
			iIssued:=iIssued+$aIssued{$i}
		End if 
		//NEXT RECORD([RM_Allocations])
	End for 
	ARRAY REAL:C219($aAlloc; 0)
	ARRAY REAL:C219($aIssued; 0)
End if 

iOpen:=(iOnOrder+iOnHand)-(iAllocated-iIssued)
$0:=(iOpen>0)