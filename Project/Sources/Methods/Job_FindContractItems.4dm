//%attributes = {"publishedWeb":true}
//PM: Job_FindContractItems() -> number changed
//@author mlb - 4/25/01  12:09
//if an item is considered contract, increase the want to the 
//qty that was good so the allocation covers all the cartons made
//rather than the lower of want or good

C_LONGINT:C283($i; $numChg; $numFG; $0)
ARRAY LONGINT:C221($aWant; 0)
ARRAY LONGINT:C221($aGood; 0)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY DATE:C224($aMod; 0)
ARRAY TEXT:C222($aWho; 0)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "jmiBeforeContract")
	
Else 
	
	ARRAY LONGINT:C221($_jmiBeforeContract; 0)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_jmiBeforeContract)
	
	
End if   // END 4D Professional Services : January 2019 

SELECTION TO ARRAY:C260([Job_Forms_Items:44]CustId:15; $aCustId; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Good:10; $aGood; [Job_Forms_Items:44]Qty_Want:24; $aWant; [Job_Forms_Items:44]PlnnrDate:35; $aMod; [Job_Forms_Items:44]PlnnrWho:34; $aWho)
$numChg:=0
$today:=4D_Current_date

For ($i; 1; Size of array:C274($aCustId))
	If (FG_isSellable($aCustId{$i}; $aCPN{$i}))
		If ($aWant{$i}<$aGood{$i})
			$aWant{$i}:=$aGood{$i}
			$numChg:=$numChg+1
			$aMod{$i}:=$today
			$aWho{$i}:="SELL"
		End if 
	End if 
End for 

If ($numChg>0)
	ARRAY TO SELECTION:C261($aWant; [Job_Forms_Items:44]Qty_Want:24; $aWho; [Job_Forms_Items:44]PlnnrWho:34; $aMod; [Job_Forms_Items:44]PlnnrDate:35)
End if 

$0:=$numChg
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("jmiBeforeContract")
	CLEAR NAMED SELECTION:C333("jmiBeforeContract")  //•110199  mlb  preserve the selection
	
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_jmiBeforeContract)
End if   // END 4D Professional Services : January 2019 
ARRAY LONGINT:C221($aWant; 0)
ARRAY LONGINT:C221($aGood; 0)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aCPN; 0)