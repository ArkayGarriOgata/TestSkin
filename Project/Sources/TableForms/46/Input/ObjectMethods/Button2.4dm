READ ONLY:C145([Finished_Goods:26])
$i:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
If ($i>0)
	$caseCnt:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	$skid:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
	$layer:=PK_getLayerCount([Customers_ReleaseSchedules:46]ProductCode:11)
	Case of 
		: ($caseCnt>0) & ([Customers_ReleaseSchedules:46]Sched_Qty:6>0)
			If (Mod:C98([Customers_ReleaseSchedules:46]Sched_Qty:6; $caseCnt)>0)
				$under:=Int:C8([Customers_ReleaseSchedules:46]Sched_Qty:6/$caseCnt)*$caseCnt
				$over:=(Int:C8([Customers_ReleaseSchedules:46]Sched_Qty:6/$caseCnt)+1)*$caseCnt
				BEEP:C151
				ALERT:C41("Odd Lot Multiple!"+Char:C90(13)+"Cases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer)+Char:C90(13)+" Suggest shipping "+String:C10($under)+" or "+String:C10($over))
				
			Else 
				BEEP:C151
				ALERT:C41("Great! Even Lot Multiple."+Char:C90(13)+"Cases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer))
			End if 
			
		: ($caseCnt=0)
			ALERT:C41("Packing Specifications are not completed.")
		: ([Customers_ReleaseSchedules:46]Sched_Qty:6=0)
			ALERT:C41("Enter a Scheduled Quantity first."+Char:C90(13)+"Cases pack = "+String:C10($caseCnt)+"  Skid = "+String:C10($skid)+" Layer = "+String:C10($layer))
	End case 
	
	//PK_ShippingContainerUI ([Finished_Goods]OutLine_Num)
	
Else 
	ALERT:C41("Can't find the F/G record.")
End if 
