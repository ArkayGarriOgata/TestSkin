app_basic_list_form_method
If (Form event code:C388=On Load:K2:1)
	If (Read only state:C362([Customers:16]))
		OBJECT SET VISIBLE:C603(*; "Search@"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "Search@"; True:C214)
	End if 
End if 