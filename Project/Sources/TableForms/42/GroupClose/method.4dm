// ----------------------------------------------------
// Form Method: [Job_Forms].GroupClose
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		vTotRec:=0
		ARRAY TEXT:C222(aRpt; vTotRec)  //TJF 052896
		ARRAY TEXT:C222(aJFID; vTotRec)
		ARRAY TEXT:C222(aCustName; vTotRec)
		ARRAY TEXT:C222(aLine; vTotRec)
		
		RESIZE FORM WINDOW:C890(-136; -63)  // Added by: Mark Zinke (12/30/13) 
		
		vSel:=0
		dDateEnd:=!00-00-00!
		dDateBegin:=!00-00-00!
		SetObjectProperties(""; ->dDateBegin; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->dDateEnd; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->aJobNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		aJobNo:=""
		cbPrint:=1
		rb1:=0  //completed date
		rb2:=0  //clsed date
		rb3:=0  //individual job
		rb4:=0  //complete date
End case 