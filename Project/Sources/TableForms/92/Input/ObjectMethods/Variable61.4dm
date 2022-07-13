If ([Job_Forms_Items_Costs:92]AllocatedQuantity:14>0)
	rReal1:=Round:C94([Job_Forms_Items_Costs:92]AllocatedTotal:7/([Job_Forms_Items_Costs:92]AllocatedQuantity:14/1000); 2)
Else 
	rReal1:=0
End if 