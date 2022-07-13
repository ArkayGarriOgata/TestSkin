//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 12/13/05, 15:22:06
// ----------------------------------------------------
// Method: JOB_getOutlineQuantities
// Description
// for corrugate allocation
//based on  JOB_getOutlineNumbers({jobform})
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($0)
ARRAY TEXT:C222(aOutlineNum; 0)
ARRAY LONGINT:C221(aNumberCartons; 0)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "holdJMI")
	
	
Else 
	
	ARRAY LONGINT:C221($_holdJMI; 0)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_holdJMI)
	
End if   // END 4D Professional Services : January 2019 
CUT NAMED SELECTION:C334([Finished_Goods:26]; "holdFG")

If (Count parameters:C259=1)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1)
End if 

If (Records in selection:C76([Job_Forms_Items:44])>0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Want:24; $aWant)
	QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPN)
	SELECTION TO ARRAY:C260([Finished_Goods:26]OutLine_Num:4; $aOutlineNum; [Finished_Goods:26]ProductCode:1; $aCPN2)
	DISTINCT VALUES:C339([Finished_Goods:26]OutLine_Num:4; aOutlineNum)
	$0:=Size of array:C274(aOutlineNum)
	ARRAY LONGINT:C221(aNumberCartons; $0)  //this is the grouped array
	For ($i; 1; Size of array:C274($aCPN))
		$hit:=Find in array:C230($aCPN2; $aCPN{$i})  //find the outline of the fg on htis jmi
		If ($hit>-1)
			$outline:=$aOutlineNum{$hit}
			$hit:=Find in array:C230(aOutlineNum; $outline)  //get the index of that outline
			If ($hit>-1)
				aNumberCartons{$hit}:=aNumberCartons{$hit}+$aWant{$i}  //increment the qty of that item
			End if 
		End if 
	End for 
	SORT ARRAY:C229(aOutlineNum; aNumberCartons; >)
Else 
	$0:=0
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("holdJMI")
	CLEAR NAMED SELECTION:C333("holdJMI")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_holdJMI)
	
	
End if   // END 4D Professional Services : January 2019 

USE NAMED SELECTION:C332("holdFG")