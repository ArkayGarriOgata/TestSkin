// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 2/8/02  11:26
// ----------------------------------------------------
// Form Method: [JTB_Job_Transfer_Bags].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Length:C16([JTB_Job_Transfer_Bags:112]PjtNumber:2)>0)  //• mlb - 9/11/02  14:34
			SetObjectProperties(""; ->[JTB_Job_Transfer_Bags:112]Jobform:3; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		Else 
			SetObjectProperties(""; ->[JTB_Job_Transfer_Bags:112]Jobform:3; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		If (Length:C16(Old:C35([JTB_Job_Transfer_Bags:112]Jobform:3))=0) & (Length:C16([JTB_Job_Transfer_Bags:112]Jobform:3)=8)
			JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Assigned to Jobform "+[JTB_Job_Transfer_Bags:112]Jobform:3)
		End if 
End case 