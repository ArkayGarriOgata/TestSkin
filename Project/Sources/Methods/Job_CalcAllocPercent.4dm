//%attributes = {"publishedWeb":true}
//PM:  Job_CalcAllocPercent  102799  mlb
//calc the alloc percent of a forms item and retrn the total
//see also Est_CalcAllocPercent
//•110199  mlb  preserve the selection
//020800 option to use good count rather than just want and
//allocate based on lesser of want or good

C_REAL:C285($0; $TotalSqIn)
C_POINTER:C301($1)  //field to use as allocation basis
C_LONGINT:C283($i; $numJMI)
ARRAY REAL:C219($aSqIn; 0)
ARRAY LONGINT:C221($aWant; 0)
ARRAY LONGINT:C221($aGood; 0)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "jmiBeforeAlloc")  //•110199  mlb  preserve the selection
	
Else 
	
	ARRAY LONGINT:C221($_jmiBeforeAlloc; 0)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_jmiBeforeAlloc)
End if   // END 4D Professional Services : January 2019 

$TotalSqIn:=0  //get total sq in`upr 160 1/9/95

If (Count parameters:C259=0)  //use want as basis
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]SqInches:22; $aSqIn; [Job_Forms_Items:44]Qty_Want:24; $aWant; [Job_Forms_Items:44]AllocationPercent:23; $aAllocation)
	ARRAY LONGINT:C221($aGood; Size of array:C274($aWant))
Else   //use actual as basis after verifing it  
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]SqInches:22; $aSqIn; [Job_Forms_Items:44]Qty_Want:24; $aWant; $1->; $aGood; [Job_Forms_Items:44]AllocationPercent:23; $aAllocation)
End if 
$numJMI:=Size of array:C274($aSqIn)
For ($i; 1; $numJMI)  //get total sq in`upr 160 1/9/95
	If (Count parameters:C259=0)
		$TotalSqIn:=$TotalSqIn+($aSqIn{$i}*$aWant{$i})
	Else 
		If ($aGood{$i}>$aWant{$i})
			$TotalSqIn:=$TotalSqIn+($aSqIn{$i}*$aWant{$i})
		Else 
			$TotalSqIn:=$TotalSqIn+($aSqIn{$i}*$aGood{$i})
		End if 
	End if 
End for 
$0:=$TotalSqIn

For ($i; 1; $numJMI)  //get total sq in`upr 160 1/9/95
	If (Count parameters:C259=0)
		$aAllocation{$i}:=uNANCheck((($aSqIn{$i}*$aWant{$i})/$TotalSqIn)*100)
	Else 
		If ($aGood{$i}>$aWant{$i})
			$aAllocation{$i}:=uNANCheck((($aSqIn{$i}*$aWant{$i})/$TotalSqIn)*100)
		Else 
			$aAllocation{$i}:=uNANCheck((($aSqIn{$i}*$aGood{$i})/$TotalSqIn)*100)
		End if 
	End if 
End for 
ARRAY TO SELECTION:C261($aAllocation; [Job_Forms_Items:44]AllocationPercent:23)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("jmiBeforeAlloc")  //•110199  mlb  preserve the selection
	CLEAR NAMED SELECTION:C333("jmiBeforeAlloc")  //•110199  mlb  preserve the selection
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_jmiBeforeAlloc)
End if   // END 4D Professional Services : January 2019 

ARRAY REAL:C219($aSqIn; 0)
ARRAY LONGINT:C221($aWant; 0)