//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/28/09, 10:43:55
// ----------------------------------------------------
// Method: ELC_DeliveryScheduleSelect
// ----------------------------------------------------

ARRAY BOOLEAN:C223(ListBox1; 0)
ARRAY BOOLEAN:C223(ListBox2; 0)
ARRAY BOOLEAN:C223(ListBox3; 0)
ARRAY DATE:C224(aDateDue; 0)
ARRAY DATE:C224(aDate; 0)
ARRAY DATE:C224(aDateDock; 0)
ARRAY LONGINT:C221(aQty; 0)
ARRAY LONGINT:C221(aRel; 0)
ARRAY LONGINT:C221(accQty; 0)
ARRAY TEXT:C222(asDiff; 0)
ARRAY TEXT:C222(asDiff2; 0)
ARRAY TEXT:C222(aPOnum; 0)

iiTotal1:=0
iiTotal2:=0
iiTotal3:=0
iiTotal4:=0
iiTotal5:=0
nextItem:=aCPN
sCPN:=aCPN{nextItem}

OBJECT SET ENABLED:C1123(bOlder; False:C215)
OBJECT SET ENABLED:C1123(bNewer; False:C215)

If (Length:C16(sCPN)>0)
	READ ONLY:C145([Finished_Goods:26])
	qryFinishedGood("#CPN"; sCPN)
	skidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
	caseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	iiTotal4:=FGL_getInventory(sCPN)
	iiTotal5:=JMI_getPlannedQty(sCPN)
	
	QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=sCPN)
	CREATE SET:C116([Finished_Goods_DeliveryForcasts:145]; "by_cpn")
	numObsolete:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; numObsolete)
	QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Is_Obsolete:13=True:C214)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	USE SET:C118("by_cpn")  //get last 3 delfor dates
	
	
	
	DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]asOf:9; aDELFOR_dates)
	SORT ARRAY:C229(aDELFOR_dates; <)
	
	as_of_displayed:=1
	sCriterion7:=""
	sCriterion8:=""
	sCriterion9:=""
	If (as_of_displayed<=Size of array:C274(aDELFOR_dates))
		sCriterion7:=aDELFOR_dates{as_of_displayed}
		as_of_displayed:=as_of_displayed+1
		If (as_of_displayed<=Size of array:C274(aDELFOR_dates))
			sCriterion8:=aDELFOR_dates{as_of_displayed}
			as_of_displayed:=as_of_displayed+1
			If (as_of_displayed<=Size of array:C274(aDELFOR_dates))
				sCriterion9:=aDELFOR_dates{as_of_displayed}
				If (Size of array:C274(aDELFOR_dates)>as_of_displayed)
					OBJECT SET ENABLED:C1123(bOlder; True:C214)
				End if 
			End if 
		End if 
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("by_cpn")
		QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion7)
		
	Else 
		
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=sCPN; *)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion7)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	iiTotal1:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
	ARRAY BOOLEAN:C223(ListBox1; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDateDue; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; aQty; [Finished_Goods_DeliveryForcasts:145]refer:3; asDiff)
	MULTI SORT ARRAY:C718(aDateDue; >; aQty; >; asDiff)
	ARRAY BOOLEAN:C223(ListBox1; Size of array:C274(aDateDue))
	
	//If ($numDelfors>1)
	//$t1:=aDELFOR_dates{$numDelfors-1}
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("by_cpn")
		QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion8)
		
	Else 
		
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=sCPN; *)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion8)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	iiTotal2:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
	ARRAY BOOLEAN:C223(ListBox2; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDate; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; aRel; [Finished_Goods_DeliveryForcasts:145]refer:3; asDiff2)
	MULTI SORT ARRAY:C718(aDate; >; aRel; >; asDiff2)
	ARRAY BOOLEAN:C223(ListBox2; Size of array:C274(aDate))
	
	//If ($numDelfors>2)
	//$t2:=aDELFOR_dates{$numDelfors-2}
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("by_cpn")
		QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion9)
		
		
	Else 
		
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=sCPN; *)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion9)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	iiTotal3:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
	ARRAY BOOLEAN:C223(ListBox3; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDateDock; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; accQty; [Finished_Goods_DeliveryForcasts:145]refer:3; aPOnum)
	MULTI SORT ARRAY:C718(aDateDock; >; accQty; >; aPOnum)
	ARRAY BOOLEAN:C223(ListBox3; Size of array:C274(aDateDock))
	//End if 
	//End if 
	//End if 
Else 
	REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
	CLEAR SET:C117("by_cpn")
End if 