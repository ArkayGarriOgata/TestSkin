//%attributes = {"publishedWeb":true}
//PM: RM_ConsumeBin(->bin;required) -> required
//@author mlb - 2/13/03  11:07
//zero needed or zero in bin will simply pass thru
//negetive bins will create 'not met' conditions that should be investigated.

C_POINTER:C301($binPtr; $1)
C_LONGINT:C283($amtNeeded; $2; $amtStillNeeded; $0)

If (Count parameters:C259=2)  //two params required
	If (($1->)>=0)  //don't pass a negative bin
		$binPtr:=$1
		
		If ($2>=0)  //don't pass negative requirements
			$amtNeeded:=$2
			
			Case of 
				: ($amtNeeded=0)  //nothing required
					$amtStillNeeded:=0
					
				: (($binPtr->)=0)  //bin is empty
					$amtStillNeeded:=$amtNeeded
					
				: (($binPtr->)>=$amtNeeded)  //we got enough, 
					$binPtr->:=($binPtr->)-$amtNeeded  //relieve the bin
					$amtStillNeeded:=0  //signal satisfied
					
				Else   //bin is empty or can partially fill need
					$amtStillNeeded:=$amtNeeded-($binPtr->)
					$binPtr->:=0  //empty the bin
			End case 
			
			$0:=$amtStillNeeded
			
		Else 
			BEEP:C151
			//ALERT("amount needed needs to be zero or more")
			
			$0:=30000000
			
		End if 
		
	Else 
		BEEP:C151
		$0:=20000000
		
	End if 
	
Else 
	BEEP:C151
	$0:=10000000
	
End if 