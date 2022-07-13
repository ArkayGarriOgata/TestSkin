//Layout Proc.: StatusBar()  020597  MLB,zwstatusmsg
//•111198  MLB  dont drop messages on the floor, also use itk

Case of 
	: (Form event code:C388=On Outside Call:K2:11)
		//utl_Trace     
		StatusBarSleep:=Current time:C178+(2*60)
		If (True:C214)  //(◊PLATFORM=Macintosh 68K)
			Status1:=<>Status1
			Status2:=<>Status2
			If (<>StatusPage#0)
				//BEEP
				FORM GOTO PAGE:C247(<>StatusPage)
				<>StatusPage:=0
			End if 
			<>Status1:=""
			<>Status2:=""
		Else 
			While (False:C215)  // (ITK_NbIPCMsg(◊StatusBar)>0)
				Status1:="itk not installed"  //ITK_RcvIPCMsg(◊StatusBar)
				Status2:=""  //ITK_RcvIPCMsg(◊StatusBar)
			End while 
		End if   //true
		
		
		If (Status1="SHUTDOWN")
			CANCEL:C270
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		//utl_Trace 
		Status1:="START UP"
		Status2:="Welcome to Arkay Management System!  Please wait while everything is made ready."
		uProcessLookup
		<>aPrcsName:=0
		StatusBarSleep:=Current time:C178+(2*60)
		SET TIMER:C645(3*60*60)
		
	: (Form event code:C388=On Timer:K2:25)
		If (Current time:C178>StatusBarSleep)
			HIDE PROCESS:C324(<>StatusBar)
		Else 
			SHOW PROCESS:C325(<>StatusBar)
		End if 
		
End case 