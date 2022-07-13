//
Case of 
	: (Form event code:C388=On Load:K2:1)
		//Shell_OutputSortColumns ("<";->[PNGA_SQL_Log]CreationDateTime_Alpha_Milli)
		//
	: ((Form event code:C388=On Display Detail:K2:22) | (Form event code:C388=On Printing Detail:K2:18))
		//
	: (Form event code:C388=On Clicked:K2:4)
		C_LONGINT:C283(bSortColumn01; bSortColumn02; bSortColumn03; bSortColumn04; bSortColumn05; bSortColumn06; bSortColumn07; bSortColumn08; bSortColumn09; bSortColumn10)
		Case of 
				
			: (bSortColumn01=1)
				//Shell_OutputSortColumns ("<";->[PNGA_SQL_Log]CreationDateTime_Alpha_Milli)
				//
		End case 
		//
	: (Form event code:C388=On Header:K2:17)
		//    
	: (Form event code:C388=On Unload:K2:2)
		//
End case 
//