If (Form event code:C388=On Header:K2:17)
	If (Read only state:C362([Customers_Bills_of_Lading:49]))
		OBJECT SET ENABLED:C1123(bAdd; False:C215)
	End if 
	
	If (User in group:C338(Current user:C182; "RolePlanner"))  //this is the Clear Pending button
		OBJECT SET ENABLED:C1123(b12; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(b12; False:C215)
	End if 
	
	
	If (User in group:C338(Current user:C182; "RoleSuperUser"))  //this is the WMS buttons
		OBJECT SET ENABLED:C1123(wms_2; True:C214)
		OBJECT SET ENABLED:C1123(wms_3; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(wms_2; False:C215)
		OBJECT SET ENABLED:C1123(wms_3; False:C215)
	End if 
	
End if 

app_basic_list_form_method
