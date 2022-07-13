//%attributes = {}
//Method:  Core_Server_LoginTest()
//Description:  This method will verfify the user wants to log into test
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bLoggingIntoTest)
	C_BOOLEAN:C305($bTestPasswordGood)
	
	C_TEXT:C284($tPassword)
	
	C_OBJECT:C1216($oRequest)
	C_OBJECT:C1216($oAlert)
	
	$bLoggingIntoTest:=(Process number:C372("Core_ServerUpaMs"; *)#0)
	$bTestPasswordGood:=False:C215
	
	$tPassword:=CorektBlank
	
	$oRequest:=New object:C1471()
	$oRequest.tMessage:="Please enter the password to log into the Test Server?"
	$oRequest.tDefault:="Log In"
	$oRequest.tValue:=Choose:C955(\
		(Current user:C182="Designer"); \
		"Test1234"; \
		CorektBlank)
	
	$oAlert:=New object:C1471()
	$oAlert.tMessage:="The password was not correct please contact amshelp@arkay.com. Thank you."
	
End if   //Done initializing

Case of   //Logging into test
		
	: (Not:C34($bLoggingIntoTest))
	: (Core_Dialog_RequestN($oRequest; ->$tPassword)=CoreknCancel)
	: ($oRequest.tValue#"Test1234")
		
	Else 
		
		$bTestPasswordGood:=True:C214
		
End case   //Done logging into test

Case of   //Allow user in
		
	: (Not:C34($bLoggingIntoTest))
	: ($bTestPasswordGood)
		
	Else   //Failed logging into test
		
		Core_Dialog_Alert($oAlert)
		
		EMAIL_Sender(\
			"[UsSp] - User "+Current system user:C484+" tried to log into test"; \
			"User tried to log into test"; \
			"Make sure to contact them and see if there is anything we can do"; \
			ArkyktAmsHelpEmail)
		
		QUIT 4D:C291
		
End case   //Done allow user in
