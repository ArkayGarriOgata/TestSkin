//%attributes = {"publishedWeb":true}
//JIC_Replenishgkey;qty;->malt$;->labor$;->burden$)->extendedCost2/25/00  mlb
//add into the cost buckets
//•072002  mlb  add JIC_JobitReadyToCost

C_TEXT:C284($fgKey; $1)
C_LONGINT:C283($qty; $2; $maxHeadroom)
C_REAL:C285($0; $extendedCost; $unitCost; $matl; $labor; $burden; $unitTotal; $unitMatl; $unitLabor; $unitBurden)
C_POINTER:C301($3; $4; $5)

$fgKey:=$1
$qty:=$2
$extendedCost:=0
$matl:=0
$labor:=0
$burden:=0

$numJIC:=qryJIC(""; $fgKey)
If ($numJIC>0)  //found cost records
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; <)  //newest first
		FIRST RECORD:C50([Job_Forms_Items_Costs:92])
		
		
	Else 
		
		ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; <)  //newest first
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	While ($qty>0) & (Not:C34(End selection:C36([Job_Forms_Items_Costs:92])))
		If (JIC_JobitReadyToCost([Job_Forms_Items_Costs:92]Jobit:3))  //•072002  mlb 
			$maxHeadroom:=[Job_Forms_Items_Costs:92]AllocatedQuantity:14-[Job_Forms_Items_Costs:92]RemainingQuantity:15
			Case of 
				: ($maxHeadroom<=0)
					//skip          
					
				: ($qty<=$maxHeadroom)  //add all to the bucket
					$remainingTotal:=JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; $qty)
					If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
						$unitTotal:=[Job_Forms_Items_Costs:92]RemainingTotal:12/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitMatl:=[Job_Forms_Items_Costs:92]RemainingMaterial:9/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitLabor:=[Job_Forms_Items_Costs:92]RemainingLabor:10/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitBurden:=[Job_Forms_Items_Costs:92]RemainingBurden:11/[Job_Forms_Items_Costs:92]RemainingQuantity:15
					Else 
						$unitTotal:=0
						$unitMatl:=0
						$unitLabor:=0
						$unitBurden:=0
					End if 
					
					$extendedCost:=$extendedCost+($qty*$unitTotal)
					$matl:=$matl+($qty*$unitMatl)
					$labor:=$labor+($qty*$unitLabor)
					$burden:=$burden+($qty*$unitBurden)
					$qty:=0
					
				: ($qty>$maxHeadroom)  //add what fits
					$remainingTotal:=JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; $maxHeadroom)
					If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
						$unitTotal:=[Job_Forms_Items_Costs:92]RemainingTotal:12/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitMatl:=[Job_Forms_Items_Costs:92]RemainingMaterial:9/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitLabor:=[Job_Forms_Items_Costs:92]RemainingLabor:10/[Job_Forms_Items_Costs:92]RemainingQuantity:15
						$unitBurden:=[Job_Forms_Items_Costs:92]RemainingBurden:11/[Job_Forms_Items_Costs:92]RemainingQuantity:15
					Else 
						$unitTotal:=0
						$unitMatl:=0
						$unitLabor:=0
						$unitBurden:=0
					End if 
					
					$extendedCost:=$extendedCost+($maxHeadroom*$unitTotal)
					$matl:=$matl+($maxHeadroom*$unitMatl)
					$labor:=$labor+($maxHeadroom*$unitLabor)
					$burden:=$burden+($maxHeadroom*$unitBurden)
					$qty:=$qty-$maxHeadroom
			End case 
		End if   //ready to cost
		NEXT RECORD:C51([Job_Forms_Items_Costs:92])
	End while 
End if 

$3->:=$matl
$4->:=$labor
$5->:=$burden
$0:=Round:C94($extendedCost; 2)