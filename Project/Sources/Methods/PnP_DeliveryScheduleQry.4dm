//%attributes = {}
// Method: PnP_DeliveryScheduleQry (cpn) -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 11:50:21
// ----------------------------------------------------
// Description:
// script for compare form

C_TEXT:C284($1)
C_LONGINT:C283($2; i1; i2)

If (Length:C16($1)>0)
	READ ONLY:C145([Finished_Goods:26])
	qryFinishedGood("#CPN"; $1)
	skidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
	caseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=$1)
	//just show latest delfor
	DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]asOf:9; $asOf)
	If (Size of array:C274($asOf)>0)
		SORT ARRAY:C229($asOf; <)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=$1; *)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145];  & ; [Finished_Goods_DeliveryForcasts:145]asOf:9=$asOf{1})
	End if 
	
	i1:=Records in selection:C76([Finished_Goods_DeliveryForcasts:145])
	If (i1>0)
		totalDemand:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
	Else 
		totalDemand:=0
	End if 
	
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7>=(4D_Current_date-14))
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		iiTotal2:=Sum:C1([Customers_ReleaseSchedules:46]Actual_Qty:8)
	Else 
		iiTotal2:=0
	End if 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	i2:=Records in selection:C76([Customers_ReleaseSchedules:46])
	If (i2>0)
		iBB:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	Else 
		iBB:=0
	End if 
	
	iiTotal1:=totalDemand-iBB
	iiTotal3:=FGL_getInventory($1)
	iiTotal4:=JMI_getPlannedQty($1)
	
	ARRAY BOOLEAN:C223(ListBox1; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]; aRecNo; [Finished_Goods_DeliveryForcasts:145]DateDock:4; aDateDue; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; aQty; [Finished_Goods_DeliveryForcasts:145]refer:3; asDiff)
	MULTI SORT ARRAY:C718(aDateDue; >; aQty; >; aRecNo; asDiff)
	ARRAY BOOLEAN:C223(ListBox1; Size of array:C274(aDateDue))
	
	ARRAY BOOLEAN:C223(ListBox2; 0)
	
	If (COMPARE_CUSTID#"00765")  //prig code
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; aRecNum; [Customers_ReleaseSchedules:46]Promise_Date:32; aDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; aRel; [Customers_ReleaseSchedules:46]CustomerRefer:3; asDiff2; [Customers_ReleaseSchedules:46]OrderLine:4; aOrderItem)
	Else   //use schd date not promised
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; aRecNum; [Customers_ReleaseSchedules:46]Sched_Date:5; aDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; aRel; [Customers_ReleaseSchedules:46]CustomerRefer:3; asDiff2; [Customers_ReleaseSchedules:46]OrderLine:4; aOrderItem)
	End if 
	
	MULTI SORT ARRAY:C718(aDate; >; aRel; >; aRecNum; asDiff2; aOrderItem)
	ARRAY BOOLEAN:C223(ListBox2; Size of array:C274(aDate))
	
	ARRAY BOOLEAN:C223(ListBox3; 0)
	OL_findOpenMatch($1)
	ARRAY BOOLEAN:C223(ListBox3; Size of array:C274(aOrderLine))
	
	If (Count parameters:C259=1)  //handle display things
		If (iiTotal3>0)
			If (iiTotal1<0)
				OBJECT SET ENABLED:C1123(bBill; True:C214)
			Else 
				OBJECT SET ENABLED:C1123(bBill; False:C215)
			End if 
		Else 
			OBJECT SET ENABLED:C1123(bBill; False:C215)
		End if 
		
		OBJECT SET ENABLED:C1123(bMatch; False:C215)
		OBJECT SET ENABLED:C1123(b2Edit; False:C215)
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET ENABLED:C1123(b1Edit; False:C215)
		OBJECT SET ENABLED:C1123(b3Edit; False:C215)
	End if 
	
Else 
	totalDemand:=0
	iBB:=0
	iiTotal1:=0
	iiTotal2:=0
	iiTotal3:=0
	iiTotal4:=0
	ARRAY BOOLEAN:C223(ListBox1; 0)
	ARRAY BOOLEAN:C223(ListBox2; 0)
	ARRAY BOOLEAN:C223(ListBox3; 0)
	ARRAY LONGINT:C221(aRecNum; 0)
	ARRAY LONGINT:C221(aRecNo; 0)
	ARRAY DATE:C224(aDateDue; 0)
	ARRAY DATE:C224(aDate; 0)
	ARRAY LONGINT:C221(aQty; 0)
	ARRAY LONGINT:C221(aRel; 0)
	ARRAY TEXT:C222(asDiff; 0)
	ARRAY TEXT:C222(asDiff2; 0)
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
End if 