If ([Raw_Materials_Locations:25]QtyOH:9<rReal1)
	BEEP:C151
	ALERT:C41("On hand Quantity is not sufficient to cover that transfer.")
	rReal1:=0
End if 
//