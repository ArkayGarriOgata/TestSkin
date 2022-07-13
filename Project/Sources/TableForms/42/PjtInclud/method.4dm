//[generic];"include"
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
End case 

app_SelectIncludedRecords(->[Job_Forms:42]JobFormID:5)
