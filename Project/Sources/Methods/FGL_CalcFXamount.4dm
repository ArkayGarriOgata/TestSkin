//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/27/07, 08:59:46
// ----------------------------------------------------
// Method: FGL_CalcFXamount(jobit{;qty})
// Description
// 
//
// Parameters
// ----------------------------------------------------

CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "jmibeforeCalc")
CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "fglbeforeCalc")
C_LONGINT:C283($sofar; $allowed; $FXqty; $jmi; $2)  //•101398  MLB  add up subforms
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$1)
$jmi:=Records in selection:C76([Job_Forms_Items:44])

$sofar:=0
$allowed:=0
If ($jmi>0)
	$sofar:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	$allowed:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
End if 
If (Count parameters:C259>1)
	$sofar:=$sofar+$2
End if 
$FXdue:=$sofar-$allowed
If ($FXdue>0)  //see if there have been moves to FX
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FX@")
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$FXqty:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		$FXqty:=0
	End if 
	
	If ($FXqty<$FXdue)
		BEEP:C151
		ALERT:C41("Planned Qty Exceeded. Should be "+String:C10($FXdue)+" in FX, only "+String:C10($FXqty)+" found.")
	End if 
End if 
USE NAMED SELECTION:C332("jmibeforeCalc")
USE NAMED SELECTION:C332("fglbeforeCalc")
