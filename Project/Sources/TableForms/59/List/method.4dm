app_basic_list_form_method
If (Form event code:C388=On Display Detail:K2:22)
	RELATE ONE:C42([Purchase_Orders_Job_forms:59]POItemKey:1)
	RELATE ONE:C42([Purchase_Orders_Items:12]VendorID:39)
	
	RELATE ONE:C42([Purchase_Orders_Job_forms:59]JobFormID:2)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
End if 

