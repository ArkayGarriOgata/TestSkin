If (iMode=2)
	iOpen:=iOpen+[Raw_Materials_Allocations:58]Qty_Allocated:4  //subtract out current value
End if 

Case of 
	: (rReal1>iOpen)
		BEEP:C151
		ALERT:C41("That will exceed the available quantity. Make a requisition.")
		//rReal1:=0
		//GOTO AREA(rReal1)
		
	: ((iOpen-rReal1)<[Raw_Materials:21]ReorderPoint:12)
		BEEP:C151
		ALERT:C41("Reorder point reached. Please make a requisition.")
		
End case 
//