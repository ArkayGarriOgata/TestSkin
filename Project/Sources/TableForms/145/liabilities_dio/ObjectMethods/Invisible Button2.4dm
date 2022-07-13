If (Size of array:C274(aCPN)>=(aCPN+1))
	aCPN:=aCPN+1
	nextItem:=aCPN
	sCPN:=aCPN{nextItem}
	ELC_DeliveryScheduleSelect(sCPN)
Else 
	BEEP:C151
End if 