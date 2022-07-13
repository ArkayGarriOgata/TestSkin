//%attributes = {"publishedWeb":true}
//PM:  uStartRespSetup  
//was  `(p) zRespSetup
//setup the ◊zresp var used to track current user
//• 8/19/97 cs created - to replace utodostartup

If (Records in table:C83([Users:5])=0)
	If ((Current user:C182="Designer") | (Current user:C182="Administrator"))  //is there at least one user record
		BEEP:C151
		ALERT:C41("You must add AT LEAST one Responsibility record!")
		
		Open window:C153(2; 40; 508; 338; 8; "Add at least one USER Record")
		Repeat   //force user to create record
			ADD RECORD:C56([Users:5]; *)
		Until ((Records in table:C83([Users:5])#0) & (OK=0))
		CLOSE WINDOW:C154
	End if 
End if 

READ WRITE:C146([Users:5])
If (Current user:C182="Designer@")
	QUERY:C277([Users:5]; [Users:5]UserName:11="Designer")
Else 
	QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)  //locate current user in user table
End if 

If (Records in selection:C76([Users:5])#1)  //if not found (or too many found)
	BEEP:C151
	ALERT:C41("You have not been registered as a user, contact your administrator.")
	
	If (Current user:C182#"Designer")  //if this is not the designer quit
		QUIT 4D:C291
	End if 
	
Else   //the was only one user record found
	<>zResp:=[Users:5]Initials:1  //get their initials
	<>zRespDept:=[Users:5]WorksInDept:15  //• 9/22/97 cs added to track users department
	
	C_LONGINT:C283($buildNumberOf4D)
	C_TEXT:C284($versionString)
	$buildNumberOf4D:=0
	$versionString:=Application version:C493($buildNumberOf4D; *)
	[Users:5]Client4Dversion:19:=$buildNumberOf4D
	[Users:5]WorkstationEnvironment:63:=Get system info:C1571
	[Users:5]LastLogIn:64:=TS2iso(TSTimeStamp)
	SAVE RECORD:C53([Users:5])
	
	NotifierSpawn
	
	$path:=util_DocumentPath("get")  //create the ams_document folder in documnets if necessary
	
	If (<>zResp="")  //if there are no initals in the record
		
		Repeat   //request them until they are entered, 2 or 3 characters
			<>zResp:=Uppercase:C13(Request:C163("Please enter your initials: (2 or 3 characters)"))
		Until ((<>zResp#"") & (ok=1)) & ((Length:C16(<>zResp)>1) & (Length:C16(<>zResp)<=3))
		[Users:5]Initials:1:=<>zResp  //save to table
		SAVE RECORD:C53([Users:5])
	End if 
	
	$remembered:=util_GetWindowPosition("MainEventWindow"; -><>mewLeft; -><>mewTop; -><>mewRight; -><>mewBottom)
	$inbounds:=util_ScreenCoordinatesInbounds(<>mewLeft; <>mewTop; <>mewRight; <>mewBottom)
	If ($inbounds) & ($remembered)  //mMainEvent
		//use the last position:: ◊MainEventWindow:=Open window(◊mewLeft;◊mewTop;◊mewRight;◊mewBottom;◊sAPPNAME;"wCloseWinBox")
	Else   //upper left of main window
		<>mewLeft:=10
		<>mewTop:=48
		<>mewRight:=514
		<>mewBottom:=344
		$remembered:=util_SetWindowPosition("MainEventWindow"; <>mewLeft; <>mewTop; <>mewRight; <>mewBottom)  //use defaults
	End if 
	
	If (Current user:C182="Administrator")
		If ([Users:5]NotifyPressSchdChg:22=New record:K29:1)  //-3
			[Users:5]NotifyPressSchdChg:22:=0
			SAVE RECORD:C53([Users:5])
			//LOAD RECORD([z_administrators])
			//If (BLOB size([z_administrators]UsersAndGroupsBlob)>5)
			//uConfirm ("Restore Users and Groups?";"I'm Sure";"Later")
			//If (ok=1)
			//BLOB TO USERS([z_administrators]UsersAndGroupsBlob)
			//End if 
			//
			//Else 
			//uConfirm ("Backup of Users and Groups does not exist.";"OK";"Help")
			//End if 
		End if 
	End if 
	
End if 
<>CurrentUser:=Current user:C182+"  "+<>zResp
//