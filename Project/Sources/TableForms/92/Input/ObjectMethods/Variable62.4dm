If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
	rReal2:=Round:C94([Job_Forms_Items_Costs:92]RemainingTotal:12/([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000); 2)
Else 
	rReal2:=0
End if 
