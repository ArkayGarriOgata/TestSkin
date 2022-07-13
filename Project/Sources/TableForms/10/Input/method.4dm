Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Record number:C243([y_batches:10])=New record:K29:1)
			[y_batches:10]BC:4:=True:C214
		End if 
		QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1=[y_batches:10]BatchName:1)
		ORDER BY:C49([y_batch_distributions:164]; [y_batch_distributions:164]EmailAddress:2; >)
End case 
//