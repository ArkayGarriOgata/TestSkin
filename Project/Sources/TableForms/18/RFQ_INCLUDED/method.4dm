If (Form event code:C388=On Display Detail:K2:22)
	QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Process_Specs:18]ID:1; *)
	QUERY:C277([Process_Specs_Machines:28];  & ; [Process_Specs_Machines:28]CustID:2=[Process_Specs:18]Cust_ID:4)
	numProcess:=Records in selection:C76([Process_Specs_Machines:28])
End if 
//