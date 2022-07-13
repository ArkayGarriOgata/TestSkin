//© 2015 Footprints Inc. All Rights Reserved.
//Method: Form Method: DOWHAT - Created `v1.0.0-PJK (12/7/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


Case of 
	: (Form event code:C388=On Load:K2:1)  //s4.1.0-SW-change to formevent and made into a case
		OBJECT SET TITLE:C194(bdCancel; ttbdCancel)
		OBJECT SET TITLE:C194(baOK1; ttbaOK1)
		OBJECT SET TITLE:C194(baOK2; ttbaOK2)
End case 