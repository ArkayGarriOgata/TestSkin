If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$numDLFR:=ELC_query(->[Finished_Goods_DeliveryForcasts:145]Custid:12)
	
	
Else 
	$criteria:=ELC_getName
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	QUERY BY FORMULA:C48([Finished_Goods_DeliveryForcasts:145]; \
		([Finished_Goods_DeliveryForcasts:145]Custid:12=[Customers:16]ID:1)\
		 & ([Customers:16]ParentCorp:19=$criteria)\
		)
	
	$numDLFR:=Records in selection:C76([Finished_Goods_DeliveryForcasts:145])
	
End if   // END 4D Professional Services : January 2019 ELC_query
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; aCPN)

If (Size of array:C274(aCPN)>0)
	aCPN:=1
	nextItem:=aCPN
	sCPN:=aCPN{nextItem}
Else 
	sCPN:=""
End if 
ELC_DeliveryScheduleSelect(sCPN)
sCriterion1:=""