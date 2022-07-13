//%attributes = {"publishedWeb":true}
//PM:  JIC_RemainingAddTo(jobit;qty)  111599  mlb
//recalc the remaining costs of a jobit

C_LONGINT:C283($2; $qtyWithCost; $hasJMI; $numJIC)
C_TEXT:C284($1)
C_REAL:C285($0)

If ([Job_Forms_Items_Costs:92]Jobit:3#$1)
	READ WRITE:C146([Job_Forms_Items_Costs:92])
	$numJIC:=qryJIC($1)
Else 
	$numJIC:=1
	If (Read only state:C362([Job_Forms_Items_Costs:92]))
		READ WRITE:C146([Job_Forms_Items_Costs:92])
		LOAD RECORD:C52([Job_Forms_Items_Costs:92])
	End if 
End if 

If ($numJIC>0)
	$qtyWithCost:=$2
	//If ($qtyWithCost>0)
	$hasJMI:=qryJMI($1)  //set query limit(1) still in effect
	If ($hasJMI>0)
		If (([Job_Forms_Items_Costs:92]RemainingQuantity:15+$qtyWithCost)>[Job_Forms_Items_Costs:92]AllocatedQuantity:14)
			$qtyWithCost:=[Job_Forms_Items_Costs:92]AllocatedQuantity:14-[Job_Forms_Items_Costs:92]RemainingQuantity:15
		End if 
		If (Not:C34([Job_Forms_Items:44]FormClosed:5))
			[Job_Forms_Items_Costs:92]RemainingQuantity:15:=[Job_Forms_Items_Costs:92]RemainingQuantity:15+$qtyWithCost
			[Job_Forms_Items_Costs:92]RemainingMaterial:9:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]PldCostMatl:17; 2)
			[Job_Forms_Items_Costs:92]RemainingLabor:10:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]PldCostLab:18; 2)
			[Job_Forms_Items_Costs:92]RemainingBurden:11:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]PldCostOvhd:19; 2)
			[Job_Forms_Items_Costs:92]RemainingTotal:12:=[Job_Forms_Items_Costs:92]RemainingMaterial:9+[Job_Forms_Items_Costs:92]RemainingLabor:10+[Job_Forms_Items_Costs:92]RemainingBurden:11
		Else 
			[Job_Forms_Items_Costs:92]RemainingQuantity:15:=[Job_Forms_Items_Costs:92]RemainingQuantity:15+$qtyWithCost
			[Job_Forms_Items_Costs:92]RemainingMaterial:9:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]Cost_Mat:12; 2)
			[Job_Forms_Items_Costs:92]RemainingLabor:10:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]Cost_LAB:13; 2)
			[Job_Forms_Items_Costs:92]RemainingBurden:11:=Round:C94([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000*[Job_Forms_Items:44]Cost_Burd:14; 2)
			[Job_Forms_Items_Costs:92]RemainingTotal:12:=[Job_Forms_Items_Costs:92]RemainingMaterial:9+[Job_Forms_Items_Costs:92]RemainingLabor:10+[Job_Forms_Items_Costs:92]RemainingBurden:11
		End if 
	End if 
	//End if 
	$0:=[Job_Forms_Items_Costs:92]RemainingTotal:12
	SAVE RECORD:C53([Job_Forms_Items_Costs:92])
	
Else   //no jic record
	$0:=-1
End if 