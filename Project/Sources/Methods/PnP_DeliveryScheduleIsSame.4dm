//%attributes = {}
// Method: PnP_DeliveryScheduleIsSame () -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 13:57:50
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($fcstTotal; $ourRelTotal; $numFcst; $numRel; $0)

If (Length:C16($1)>0)
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=$1)
	$numFcst:=Records in selection:C76([Finished_Goods_DeliveryForcasts:145])
	If ($numFcst>0)
		$fcstTotal:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
	Else 
		$fcstTotal:=0
	End if 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	$numRel:=Records in selection:C76([Customers_ReleaseSchedules:46])
	If ($numRel>0)
		$ourRelTotal:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	Else 
		$ourRelTotal:=0
	End if 
	
	$0:=$fcstTotal-$ourRelTotal
	
End if 