// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/24/13, 13:23:26
// ----------------------------------------------------
// Method: [zz_control].MainEventIcons
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		//BeforeMainEventButtons ("Icons")
		SET TIMER:C645(60*60*20)
		
	: (Form event code:C388=On Timer:K2:25)
		If (<>TEST_VERSION)
			BEEP:C151
			ALERT:C41("REMINDER: You are using a test version of aMs. Updates will not be saved."; "I know")
		End if 
		
		util_ForceQuitUsers
		
	: (Form event code:C388=On Outside Call:K2:11)
		CANCEL:C270
		
End case 