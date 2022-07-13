If (Form event code:C388=On Display Detail:K2:22)
	If ([Raw_Materials_Transactions:23]ActExtCost:10<0)
		Core_ObjectSetColor(->[Raw_Materials_Transactions:23]ActExtCost:10; -3; True:C214)
	Else 
		Core_ObjectSetColor(->[Raw_Materials_Transactions:23]ActExtCost:10; -15; True:C214)
	End if 
End if 
//
app_basic_list_form_method