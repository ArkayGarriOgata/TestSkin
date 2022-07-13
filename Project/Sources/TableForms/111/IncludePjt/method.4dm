//[generic];"include"
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
End case 

app_SelectIncludedRecords(->[JPSI_Job_Physical_Support_Items:111]ID:1)
