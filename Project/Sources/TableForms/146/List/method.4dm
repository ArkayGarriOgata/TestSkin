app_basic_list_form_method

Case of 
	: (Form event code:C388=On Outside Call:K2:11)
		QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]Delivered:6=!00-00-00!)
		CANCEL:C270
		
	: (Form event code:C388=On Load:K2:1)
		If (<>PHYSICAL_INVENORY_IN_PROGRESS)
			OBJECT SET ENABLED:C1123(bIssue; False:C215)
		End if 
End case 