//%attributes = {"publishedWeb":true}
//JIC_Scrapgkey;qty;->malt$;->labor$;->burden$)->extendedCost  2/25/00  mlb
//scrap inventory, try to consume excess first
//•072002  mlb the bin was already relieve, so add scrap back in

C_TEXT:C284($fgKey; $1)
C_LONGINT:C283($qty; $2)
C_REAL:C285($0; $extendedCost; $unitCost; $matl; $labor; $burden; $unitTotal; $unitMatl; $unitLabor; $unitBurden)
C_POINTER:C301($3; $4; $5)

$fgKey:=$1
$qty:=$2
$extendedCost:=0
$matl:=0
$labor:=0
$burden:=0
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	$numJIC:=qryJIC(""; $fgKey)
	
	QUERY SELECTION:C341([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]RemainingQuantity:15#0)  //don't bother with empties
	
	
Else 
	
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$fgKey; *)
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]RemainingQuantity:15#0)  //don't bother with empties
	
	
End if   // END 4D Professional Services : January 2019 query selection
$numJIC:=Records in selection:C76([Job_Forms_Items_Costs:92])
If ($numJIC>0)  //found cost records
	$valued:=Sum:C1([Job_Forms_Items_Costs:92]RemainingQuantity:15)
	
	READ ONLY:C145([Finished_Goods_Locations:35])
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgKey; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"BH@")
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$onhand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		$onhand:=0
	End if 
	
	$excess:=($onhand+$qty)-$valued  //•072002  mlb the bin was already relieve, so add scrap back in
	If ($excess>0)  //•072002  mlb  do minus a minus!
		$qty:=$qty-$excess
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; >)  //oldest first
		FIRST RECORD:C50([Job_Forms_Items_Costs:92])
		
	Else 
		
		ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; >)  //oldest first
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	While ($qty>0) & (Not:C34(End selection:C36([Job_Forms_Items_Costs:92])))
		
		Case of 
			: ([Job_Forms_Items_Costs:92]RemainingQuantity:15=0)
				//skip  
				
			: ([Job_Forms_Items_Costs:92]RemainingQuantity:15<0)
				[Job_Forms_Items_Costs:92]RemainingQuantity:15:=0
				[Job_Forms_Items_Costs:92]RemainingTotal:12:=0
				[Job_Forms_Items_Costs:92]RemainingMaterial:9:=0
				[Job_Forms_Items_Costs:92]RemainingLabor:10:=0
				[Job_Forms_Items_Costs:92]RemainingBurden:11:=0
				SAVE RECORD:C53([Job_Forms_Items_Costs:92])
				
			: ($qty<=[Job_Forms_Items_Costs:92]RemainingQuantity:15)  //reduce the bucket
				$unitTotal:=[Job_Forms_Items_Costs:92]RemainingTotal:12/[Job_Forms_Items_Costs:92]RemainingQuantity:15
				$unitMatl:=[Job_Forms_Items_Costs:92]RemainingMaterial:9/[Job_Forms_Items_Costs:92]RemainingQuantity:15
				$unitLabor:=[Job_Forms_Items_Costs:92]RemainingLabor:10/[Job_Forms_Items_Costs:92]RemainingQuantity:15
				$unitBurden:=[Job_Forms_Items_Costs:92]RemainingBurden:11/[Job_Forms_Items_Costs:92]RemainingQuantity:15
				
				$extendedCost:=$extendedCost+($qty*$unitTotal)
				$matl:=$matl+($qty*$unitMatl)
				$labor:=$labor+($qty*$unitLabor)
				$burden:=$burden+($qty*$unitBurden)
				
				[Job_Forms_Items_Costs:92]RemainingQuantity:15:=[Job_Forms_Items_Costs:92]RemainingQuantity:15-$qty
				[Job_Forms_Items_Costs:92]RemainingTotal:12:=[Job_Forms_Items_Costs:92]RemainingTotal:12-($qty*$unitTotal)
				[Job_Forms_Items_Costs:92]RemainingMaterial:9:=[Job_Forms_Items_Costs:92]RemainingMaterial:9-($qty*$unitMatl)
				[Job_Forms_Items_Costs:92]RemainingLabor:10:=[Job_Forms_Items_Costs:92]RemainingLabor:10-($qty*$unitLabor)
				[Job_Forms_Items_Costs:92]RemainingBurden:11:=[Job_Forms_Items_Costs:92]RemainingBurden:11-($qty*$unitBurden)
				SAVE RECORD:C53([Job_Forms_Items_Costs:92])
				$qty:=0
				
			: ($qty>[Job_Forms_Items_Costs:92]RemainingQuantity:15)  //empty the bucket
				$extendedCost:=$extendedCost+[Job_Forms_Items_Costs:92]RemainingTotal:12
				$matl:=$matl+[Job_Forms_Items_Costs:92]RemainingMaterial:9
				$labor:=$labor+[Job_Forms_Items_Costs:92]RemainingLabor:10
				$burden:=$burden+[Job_Forms_Items_Costs:92]RemainingBurden:11
				$qty:=$qty-[Job_Forms_Items_Costs:92]RemainingQuantity:15
				[Job_Forms_Items_Costs:92]RemainingQuantity:15:=0
				[Job_Forms_Items_Costs:92]RemainingTotal:12:=0
				[Job_Forms_Items_Costs:92]RemainingMaterial:9:=0
				[Job_Forms_Items_Costs:92]RemainingLabor:10:=0
				[Job_Forms_Items_Costs:92]RemainingBurden:11:=0
				SAVE RECORD:C53([Job_Forms_Items_Costs:92])
		End case 
		
		NEXT RECORD:C51([Job_Forms_Items_Costs:92])
	End while 
End if 

$3->:=$matl
$4->:=$labor
$5->:=$burden
$0:=Round:C94($extendedCost; 2)