// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 08/03/01
// ----------------------------------------------------
// Method: [zz_control]QApalette
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (User in group:C338(Current user:C182; "RoleQA"))
			OBJECT SET ENABLED:C1123(*; "QA@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "QA@"; False:C215)
		End if 
		
		If (Size of array:C274(<>aQARptPop)=0)
			QA_Reports
		End if 
		
		If (<>bButtons)  // Added by: Mark Zinke (2/7/13)
			FORM GOTO PAGE:C247(2)
			GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
			SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight+30; $xlBottom-110)
		End if 
End case 