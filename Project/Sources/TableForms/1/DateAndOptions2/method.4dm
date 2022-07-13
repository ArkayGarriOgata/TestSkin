//(LP) - [control];"DateAndOptions2"  - CS - 1/7/97
//This is used by rRptRmReciepts().
//variables definitions used here are shared by the uLinkRelated() interface.

If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateEnd; dDateBegin)
	If (dDateEnd=!00-00-00!)
		dDateEnd:=4D_Current_date
	End if 
	rbRcvOnly:=1  //intialize Radio buttons
End if 
//eop