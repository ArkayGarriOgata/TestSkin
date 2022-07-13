
$numFGs:=qryFinishedGood("#CPN"; sCPN)
DISTINCT VALUES:C339([Finished_Goods:26]ProductCode:1; aCPN)
If (Size of array:C274(aCPN)>0)
	aCPN:=1
	nextItem:=aCPN
	sCPN:=aCPN{nextItem}
Else 
	sCPN:=""
End if 
ELC_DeliveryScheduleSelect(sCPN)
rb3:=1