//%attributes = {"publishedWeb":true}
//JIC_relieve(fgkey;qty;->malt$;->labor$;->burden$)->extendedCost  2/24/00
//return the total cost of the specified quantity
//071800 allow a cut-off date

C_TEXT:C284($fgKey; $1)
C_LONGINT:C283($qty; $2; $jic; $numJMI)
C_REAL:C285($0; $extendedCost; $unitCost; $matl; $labor; $burden; $unitTotal; $unitMatl; $unitLabor; $unitBurden)
C_POINTER:C301($3; $4; $5)
C_DATE:C307($6; $cutOffDate)  //071800

$fgKey:=$1
$qty:=$2
$extendedCost:=0
$matl:=0
$labor:=0
$burden:=0

If (Count parameters:C259>5)
	$cutOffDate:=$6  //only take jic's that are not newer than this date
Else 
	$cutOffDate:=!00-00-00!
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	$numJIC:=qryJIC(""; $fgKey)
	utl_Trace
	QUERY SELECTION:C341([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]RemainingQuantity:15#0)  //don't bother with empties
	
Else 
	
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$fgKey; *)
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]RemainingQuantity:15#0)  //don't bother with empties
	utl_Trace
End if   // END 4D Professional Services : January 2019 query selection
$numJIC:=Records in selection:C76([Job_Forms_Items_Costs:92])

If ($numJIC>0)  //071800
	If ($cutOffDate#!00-00-00!)  //only look for ones that were effective at time of shipment
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Job_Forms_Items_Costs:92]; "$effectiveOnCutOffDate")
			For ($jic; 1; $numJIC)
				$numJMI:=qryJMI([Job_Forms_Items_Costs:92]Jobit:3)
				If ($numJMI>0)
					If ([Job_Forms_Items:44]Glued:33#!00-00-00!)
						If ([Job_Forms_Items:44]Glued:33<=$cutOffDate)
							ADD TO SET:C119([Job_Forms_Items_Costs:92]; "$effectiveOnCutOffDate")
						End if 
					End if 
				End if 
			End for 
			USE SET:C118("$effectiveOnCutOffDate")
			CLEAR SET:C117("$effectiveOnCutOffDate")
			
			
		Else 
			
			ARRAY LONGINT:C221($_effectiveOnCutOffDate; 0)
			
			
			For ($jic; 1; $numJIC)
				$numJMI:=qryJMI([Job_Forms_Items_Costs:92]Jobit:3)
				If ($numJMI>0)
					If ([Job_Forms_Items:44]Glued:33#!00-00-00!)
						If ([Job_Forms_Items:44]Glued:33<=$cutOffDate)
							
							APPEND TO ARRAY:C911($_effectiveOnCutOffDate; Record number:C243([Job_Forms_Items_Costs:92]))
						End if 
					End if 
				End if 
			End for 
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items_Costs:92]; $_effectiveOnCutOffDate)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		$numJIC:=Records in selection:C76([Job_Forms_Items_Costs:92])
	End if 
End if 

If ($numJIC>0)  //found cost records  
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