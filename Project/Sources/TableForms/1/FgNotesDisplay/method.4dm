// ----------------------------------------------------
// User name (OS): cs
// Date: 2/25/97
// ----------------------------------------------------
// Form Method: [zz_control].FgNotesDisplay
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		xText:=[Finished_Goods:26]ArtWorkNotes:60  //display note entry
		If (Locked:C147([Finished_Goods:26]))  //if the record is locked (user dimissed an earlier dlog)
			SetObjectProperties(""; ->xText; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
			OBJECT SET ENABLED:C1123(baOK; False:C215)  //disable save button
		Else 
			SetObjectProperties(""; ->xText; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
			OBJECT SET ENABLED:C1123(baOK; True:C214)  //disable save button
		End if 
End case 