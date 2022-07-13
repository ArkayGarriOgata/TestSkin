//bOlder
//
as_of_displayed:=as_of_displayed-1  // will be set to 3 first time
If (as_of_displayed<1)  //stay in bounds
	as_of_displayed:=1
End if 
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
			Else 
				OBJECT SET ENABLED:C1123(bOlder; False:C215)
			End if 
		End if 
	End if 
End if 

If (as_of_displayed>3)
	OBJECT SET ENABLED:C1123(bNewer; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bNewer; False:C215)
End if 

USE SET:C118("by_cpn")
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion7)


// ******* Verified  - 4D PS - January 2019 (end) *********
iiTotal1:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
ARRAY BOOLEAN:C223(ListBox1; 0)
SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDateDue; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; aQty; [Finished_Goods_DeliveryForcasts:145]refer:3; asDiff)
MULTI SORT ARRAY:C718(aDateDue; >; aQty; >; asDiff)
ARRAY BOOLEAN:C223(ListBox1; Size of array:C274(aDateDue))

//If ($numDelfors>1)
//$t1:=aDELFOR_dates{$numDelfors-1}
USE SET:C118("by_cpn")
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion8)


// ******* Verified  - 4D PS - January 2019 (end) *********
iiTotal2:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
ARRAY BOOLEAN:C223(ListBox2; 0)
SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDate; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; aRel; [Finished_Goods_DeliveryForcasts:145]refer:3; asDiff2)
MULTI SORT ARRAY:C718(aDate; >; aRel; >; asDiff2)
ARRAY BOOLEAN:C223(ListBox2; Size of array:C274(aDate))

//If ($numDelfors>2)
//$t2:=aDELFOR_dates{$numDelfors-2}
USE SET:C118("by_cpn")
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=sCriterion9)


// ******* Verified  - 4D PS - January 2019 (end) *********
iiTotal3:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
ARRAY BOOLEAN:C223(ListBox3; 0)
SELECTION TO ARRAY:C260([Finished_Goods_DeliveryForcasts:145]DateDock:4; aDateDock; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; accQty; [Finished_Goods_DeliveryForcasts:145]refer:3; aPOnum)
MULTI SORT ARRAY:C718(aDateDock; >; accQty; >; aPOnum)
ARRAY BOOLEAN:C223(ListBox3; Size of array:C274(aDateDock))
