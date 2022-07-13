
Case of 
	: (Form event code:C388=On Load:K2:1)
		IBOL_IntraPlanTransfer("purge_bol")
		
		OBJECT SET ENABLED:C1123(*; "PrintBOL"; False:C215)
		OBJECT SET ENABLED:C1123(*; "ShowSkid"; False:C215)
		
End case 
