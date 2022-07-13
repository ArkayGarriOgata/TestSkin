If ([Raw_Materials_Locations:25]ConsignmentQty:26<rReal1)
	BEEP:C151
	ALERT:C41("Consignment Quantity is not sufficient to cover that transfer.")
	rReal1:=0
End if 
//