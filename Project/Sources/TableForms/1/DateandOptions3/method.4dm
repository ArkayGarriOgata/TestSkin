//(LP) - [control];"DateAndOptions"  - CS - 12/22/96
//variables definitions used here are shared by the uLinkRelated() interface.

If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateEnd; dDateBegin)
	If (dDateEnd=!00-00-00!)
		dDateEnd:=4D_Current_date
	End if 
	dDateBegin:=Date:C102(FiscalYear("start"; 4D_Current_date))
	
	
	rbOrig:=1  //intialize Raadio buttons
End if 
//eop