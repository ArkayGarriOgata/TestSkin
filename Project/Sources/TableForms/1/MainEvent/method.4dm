
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeMainEvent
		If (User in group:C338(Current user:C182; "RoleSuperUser"))
			util_MainWindowVisible("Show")
		End if 
		SET TIMER:C645(60*60*20)
		
	: (Form event code:C388=On Resize:K2:27)
		GET WINDOW RECT:C443(<>mewLeft; <>mewTop; <>mewRight; <>mewBottom; <>MainEventWindow)  //save the window position
		$remembered:=New process:C317("util_SetWindowPosition"; <>lMinMemPart; "Saving User Preference"; "MainEventWindow"; <>mewLeft; <>mewTop; <>mewRight; <>mewBottom)
		If (False:C215)
			util_SetWindowPosition
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		GET WINDOW RECT:C443(<>mewLeft; <>mewTop; <>mewRight; <>mewBottom; <>MainEventWindow)  //save the window position
		
		$remembered:=New process:C317("util_SetWindowPosition"; <>lMinMemPart; "Saving User Preference"; "MainEventWindow"; <>mewLeft; <>mewTop; <>mewRight; <>mewBottom)
		If (False:C215)
			util_SetWindowPosition
		End if 
		CANCEL:C270
		
	: (Form event code:C388=On Timer:K2:25)
		If (<>TEST_VERSION)
			BEEP:C151
			ALERT:C41("REMINDER: You are using a test version of aMs. Updates will not be saved."; "I know")
		End if 
		
		util_ForceQuitUsers
		
	: (Form event code:C388=On Outside Call:K2:11)  // Added by: Mark Zinke (1/24/13)
		CANCEL:C270
		
End case 