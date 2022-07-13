
Case of 
	: (Form event code:C388=On Data Change:K2:15)
		iitotal1:=0
		For ($i; 1; Size of array:C274(aPicked))
			iitotal1:=iitotal1+aPicked{$i}
		End for 
		
		//If (iitotal1>0)
		//OBJECT SET ENABLED(bInvoice;True)
		//Else 
		//OBJECT SET ENABLED(bInvoice;False)
		//End if 
		
		OBJECT SET ENABLED:C1123(bInvoice; False:C215)
End case 
