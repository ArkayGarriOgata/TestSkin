If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$numBins:=ELC_query(->[Job_Forms_Items:44]CustId:15)
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	
	
Else 
	$criteria:=ELC_getName
	READ ONLY:C145([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Customers:16]ParentCorp:19=$criteria; *)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	$numBins:=Records in selection:C76([Job_Forms_Items:44])
	
End if   // END 4D Professional Services : January 2019 ELC_query
DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; aCPN)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$numDLFR:=ELC_query(->[Finished_Goods_DeliveryForcasts:145]Custid:12)
	
	
Else 
	$criteria:=ELC_getName
	
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	QUERY BY FORMULA:C48([Finished_Goods_DeliveryForcasts:145]; \
		([Finished_Goods_DeliveryForcasts:145]Custid:12=[Customers:16]ID:1)\
		 & ([Customers:16]ParentCorp:19=$criteria))
	
	$numDLFR:=Records in selection:C76([Finished_Goods_DeliveryForcasts:145])
	
End if   // END 4D Professional Services : January 2019 ELC_query
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; $aCPN)

For ($i; 1; Size of array:C274(aCPN))
	$hit:=Find in array:C230($aCPN; aCPN{$i})
	If ($hit=-1)
		aCPN{$i}:="ZZZ"
	End if 
End for 

SORT ARRAY:C229(aCPN; >)
$hit:=Find in array:C230(aCPN; "ZZZ")
DELETE FROM ARRAY:C228(aCPN; $hit; Size of array:C274(aCPN)-($hit-1))

If (Size of array:C274(aCPN)>0)
	aCPN:=1
	nextItem:=aCPN
	sCPN:=aCPN{nextItem}
Else 
	sCPN:=""
End if 
ELC_DeliveryScheduleSelect(sCPN)
sCriterion1:=""