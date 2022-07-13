//(S) ItemNo:[OrderChgHistory]'OrderChg_Items'Output'ItemNo

Case of 
	: (Form event code:C388=On Data Change:K2:15)
		sChgOrdItem("*")
End case 