Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		If ([Job_Forms_Items_Costs:92]AllocatedQuantity:14>0)
			rReal1:=Round:C94([Job_Forms_Items_Costs:92]AllocatedTotal:7/([Job_Forms_Items_Costs:92]AllocatedQuantity:14/1000); 2)
		Else 
			rReal1:=0
		End if 
		
		If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
			rReal2:=Round:C94([Job_Forms_Items_Costs:92]RemainingTotal:12/([Job_Forms_Items_Costs:92]RemainingQuantity:15/1000); 2)
		Else 
			rReal2:=0
		End if 
		
End case 
