//%attributes = {}
// _______
// Method: PS_PrePressMetaColor   (columnName) ->
// By: MelvinBohince @ 03/07/22, 12:49:30
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (3/21/22) add color for completed

C_OBJECT:C1216($0)
C_OBJECT:C1216($meta; $colorObj)
C_TEXT:C284($1; $columnName; $jobInfo)
C_LONGINT:C283($completed)

If (Count parameters:C259=1)
	$columnName:=$1
	$jobInfo:=This:C1470.JobInfo
	$custName:=This:C1470.Customer
	$completed:=This:C1470.Completed
	
Else   //test
	$columnName:="Column3"
	$jobInfo:="ok"
	$custName:="Cosmax"  //"Len Ron Mfg."
	$colorObj:=Cust_Name_ColorO
	$completed:=This:C1470.Completed
	
End if 

$meta:=New object:C1471

If ($completed=0)  // Modified by: MelvinBohince (3/21/22) //not complete
	
	If (Position:C15("HOLD"; $jobInfo)>0) | (Position:C15("KILL"; $jobInfo)>0) | (Position:C15("CLOS"; $jobInfo)>0)
		$meta.stroke:="#E2B41E"
		$meta.fill:="#F5F5DC"
		
	Else 
		$colorObj:=Cust_Name_ColorO($custName)
		
		$meta.cell:=New object:C1471
		
		$meta.cell[$columnName]:=New object:C1471("stroke"; $colorObj.tForeground; "fill"; $colorObj.tBackground)
		
	End if 
	
Else   // Modified by: MelvinBohince (3/21/22) 
	$meta.stroke:="#FFFFFF"  //white
	$meta.fill:="#B6B6B4"  //on grey
End if   //complete


$0:=$meta
