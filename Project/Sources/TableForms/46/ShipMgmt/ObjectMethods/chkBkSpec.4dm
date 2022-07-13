// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.chkBkSpec   ( ) ->
// By: Mel Bohince @ 06/23/20, 15:11:00
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($caseCnt; $skid; $layer; $under; $over)
$caseCnt:=Form:C1466.editEntity.FINISHED_GOOD.PACKING_SPEC.CaseCount
$skid:=Form:C1466.editEntity.FINISHED_GOOD.PACKING_SPEC.UnitsPerSkid
$layer:=Form:C1466.editEntity.FINISHED_GOOD.PACKING_SPEC.CasesPerLayer*$caseCnt
Case of 
	: ($caseCnt>0) & (Form:C1466.editEntity.Sched_Qty>0)
		If (Mod:C98(Form:C1466.editEntity.Sched_Qty; $caseCnt)>0)
			$under:=Int:C8(Form:C1466.editEntity.Sched_Qty/$caseCnt)*$caseCnt
			$over:=(Int:C8(Form:C1466.editEntity.Sched_Qty/$caseCnt)+1)*$caseCnt
			BEEP:C151
			ALERT:C41("Odd Lot Multiple!\rCases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer)+"\r Suggest shipping "+String:C10($under)+" or "+String:C10($over))
			
		Else 
			BEEP:C151
			ALERT:C41("Great! Even Lot Multiple.\rCases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer))
		End if 
		
	: ($caseCnt=0)
		ALERT:C41("Packing Specifications are not completed.")
		
	: (Form:C1466.editEntity.Sched_Qty=0)
		ALERT:C41("Enter a Scheduled Quantity first.\rCases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer))
End case 

